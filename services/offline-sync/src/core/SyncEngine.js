const { v4: uuidv4 } = require('uuid');
const _ = require('lodash');
const jsonpatch = require('jsonpatch');
const logger = require('../utils/logger');

/**
 * Offline Sync Engine for mobile applications
 * Handles bidirectional synchronization with conflict resolution
 */
class SyncEngine {
  constructor(redisClient, eventBus) {
    this.redis = redisClient;
    this.eventBus = eventBus;
    this.conflictResolvers = new Map();
    this.syncStrategies = new Map();
    
    // Initialize default conflict resolvers
    this.initializeDefaultResolvers();
  }

  /**
   * Initialize default conflict resolution strategies
   */
  initializeDefaultResolvers() {
    // Last-Write-Wins resolver
    this.conflictResolvers.set('last-write-wins', (serverData, clientData, metadata) => {
      const serverTime = new Date(serverData.updatedAt || serverData.timestamp);
      const clientTime = new Date(clientData.updatedAt || clientData.timestamp);
      
      return clientTime > serverTime ? clientData : serverData;
    });

    // Server-Wins resolver
    this.conflictResolvers.set('server-wins', (serverData, clientData, metadata) => {
      return serverData;
    });

    // Client-Wins resolver
    this.conflictResolvers.set('client-wins', (serverData, clientData, metadata) => {
      return clientData;
    });

    // Merge resolver (for non-conflicting fields)
    this.conflictResolvers.set('merge', (serverData, clientData, metadata) => {
      return this.mergeObjects(serverData, clientData);
    });

    // Field-level resolver
    this.conflictResolvers.set('field-level', (serverData, clientData, metadata) => {
      return this.resolveFieldLevelConflicts(serverData, clientData, metadata);
    });
  }

  /**
   * Sync data from client to server
   */
  async syncFromClient(userId, deviceId, syncData) {
    try {
      const syncId = uuidv4();
      logger.info(`Starting client sync: ${syncId} for user ${userId}, device ${deviceId}`);

      const result = {
        syncId,
        userId,
        deviceId,
        timestamp: new Date().toISOString(),
        conflicts: [],
        applied: [],
        rejected: [],
        summary: {},
      };

      // Process each entity type
      for (const [entityType, entities] of Object.entries(syncData)) {
        const entityResult = await this.syncEntityType(
          userId,
          deviceId,
          entityType,
          entities,
          'client-to-server'
        );
        
        result.conflicts.push(...entityResult.conflicts);
        result.applied.push(...entityResult.applied);
        result.rejected.push(...entityResult.rejected);
        result.summary[entityType] = entityResult.summary;
      }

      // Store sync result
      await this.storeSyncResult(syncId, result);

      logger.info(`Client sync completed: ${syncId}, applied: ${result.applied.length}, conflicts: ${result.conflicts.length}`);
      
      return result;

    } catch (error) {
      logger.error('Error in syncFromClient:', error);
      throw error;
    }
  }

  /**
   * Sync data from server to client
   */
  async syncToClient(userId, deviceId, lastSyncTimestamp, entityTypes = []) {
    try {
      const syncId = uuidv4();
      logger.info(`Starting server sync: ${syncId} for user ${userId}, device ${deviceId}`);

      const result = {
        syncId,
        userId,
        deviceId,
        timestamp: new Date().toISOString(),
        lastSyncTimestamp,
        data: {},
        deletions: {},
        summary: {},
      };

      // Get changes since last sync
      for (const entityType of entityTypes) {
        const changes = await this.getServerChanges(
          userId,
          entityType,
          lastSyncTimestamp
        );
        
        result.data[entityType] = changes.data;
        result.deletions[entityType] = changes.deletions;
        result.summary[entityType] = {
          total: changes.data.length,
          deletions: changes.deletions.length,
        };
      }

      // Store sync result
      await this.storeSyncResult(syncId, result);

      logger.info(`Server sync completed: ${syncId}`);
      
      return result;

    } catch (error) {
      logger.error('Error in syncToClient:', error);
      throw error;
    }
  }

  /**
   * Sync specific entity type
   */
  async syncEntityType(userId, deviceId, entityType, entities, direction) {
    const result = {
      conflicts: [],
      applied: [],
      rejected: [],
      summary: {
        total: entities.length,
        conflicts: 0,
        applied: 0,
        rejected: 0,
      },
    };

    for (const entity of entities) {
      try {
        const syncResult = await this.syncSingleEntity(
          userId,
          deviceId,
          entityType,
          entity,
          direction
        );
        
        if (syncResult.conflict) {
          result.conflicts.push(syncResult);
          result.summary.conflicts++;
        } else if (syncResult.applied) {
          result.applied.push(syncResult);
          result.summary.applied++;
        } else {
          result.rejected.push(syncResult);
          result.summary.rejected++;
        }

      } catch (error) {
        logger.error(`Error syncing entity ${entity.id}:`, error);
        result.rejected.push({
          entityId: entity.id,
          entityType,
          error: error.message,
        });
        result.summary.rejected++;
      }
    }

    return result;
  }

  /**
   * Sync single entity with conflict detection
   */
  async syncSingleEntity(userId, deviceId, entityType, clientEntity, direction) {
    // Get current server version
    const serverEntity = await this.getServerEntity(entityType, clientEntity.id);
    
    // Check for conflicts
    const conflict = this.detectConflict(serverEntity, clientEntity);
    
    if (conflict) {
      // Resolve conflict
      const resolution = await this.resolveConflict(
        entityType,
        serverEntity,
        clientEntity,
        {
          userId,
          deviceId,
          direction,
          conflictType: conflict.type,
        }
      );
      
      // Apply resolution
      await this.applyResolution(entityType, clientEntity.id, resolution);
      
      return {
        entityId: clientEntity.id,
        entityType,
        conflict: true,
        conflictType: conflict.type,
        resolution: resolution.strategy,
        applied: true,
      };
    } else {
      // No conflict, apply directly
      await this.applyEntity(entityType, clientEntity);
      
      return {
        entityId: clientEntity.id,
        entityType,
        conflict: false,
        applied: true,
      };
    }
  }

  /**
   * Detect conflicts between server and client versions
   */
  detectConflict(serverEntity, clientEntity) {
    if (!serverEntity) {
      return null; // No conflict for new entities
    }

    // Check version conflict
    if (serverEntity.version && clientEntity.version) {
      if (serverEntity.version !== clientEntity.version) {
        return {
          type: 'version-conflict',
          serverVersion: serverEntity.version,
          clientVersion: clientEntity.version,
        };
      }
    }

    // Check timestamp conflict
    const serverTime = new Date(serverEntity.updatedAt || serverEntity.timestamp);
    const clientTime = new Date(clientEntity.updatedAt || clientEntity.timestamp);
    const clientLastSync = new Date(clientEntity.lastSyncTimestamp || 0);

    if (serverTime > clientLastSync) {
      return {
        type: 'timestamp-conflict',
        serverTime: serverTime.toISOString(),
        clientTime: clientTime.toISOString(),
        clientLastSync: clientLastSync.toISOString(),
      };
    }

    // Check field-level conflicts
    const fieldConflicts = this.detectFieldConflicts(serverEntity, clientEntity);
    if (fieldConflicts.length > 0) {
      return {
        type: 'field-conflict',
        conflicts: fieldConflicts,
      };
    }

    return null;
  }

  /**
   * Detect field-level conflicts
   */
  detectFieldConflicts(serverEntity, clientEntity) {
    const conflicts = [];
    const serverFields = Object.keys(serverEntity);
    const clientFields = Object.keys(clientEntity);
    
    const allFields = new Set([...serverFields, ...clientFields]);
    
    for (const field of allFields) {
      if (field === 'id' || field === 'createdAt') continue;
      
      const serverValue = serverEntity[field];
      const clientValue = clientEntity[field];
      
      if (!_.isEqual(serverValue, clientValue)) {
        conflicts.push({
          field,
          serverValue,
          clientValue,
        });
      }
    }
    
    return conflicts;
  }

  /**
   * Resolve conflict using appropriate strategy
   */
  async resolveConflict(entityType, serverEntity, clientEntity, metadata) {
    // Get conflict resolution strategy for entity type
    const strategy = this.getConflictStrategy(entityType, metadata.conflictType);
    const resolver = this.conflictResolvers.get(strategy);
    
    if (!resolver) {
      throw new Error(`No conflict resolver found for strategy: ${strategy}`);
    }
    
    const resolvedEntity = resolver(serverEntity, clientEntity, metadata);
    
    return {
      strategy,
      resolvedEntity,
      metadata,
    };
  }

  /**
   * Get conflict resolution strategy for entity type
   */
  getConflictStrategy(entityType, conflictType) {
    // Default strategies by entity type
    const strategies = {
      'farm': 'last-write-wins',
      'crop': 'merge',
      'livestock': 'field-level',
      'activity': 'client-wins',
      'harvest': 'server-wins',
    };
    
    return strategies[entityType] || 'last-write-wins';
  }

  /**
   * Merge objects intelligently
   */
  mergeObjects(serverData, clientData) {
    const merged = _.cloneDeep(serverData);
    
    // Merge non-conflicting fields
    for (const [key, value] of Object.entries(clientData)) {
      if (key === 'id' || key === 'createdAt') continue;
      
      if (!merged.hasOwnProperty(key) || merged[key] === null || merged[key] === undefined) {
        merged[key] = value;
      }
    }
    
    // Use latest timestamp
    if (clientData.updatedAt && serverData.updatedAt) {
      merged.updatedAt = new Date(clientData.updatedAt) > new Date(serverData.updatedAt) 
        ? clientData.updatedAt 
        : serverData.updatedAt;
    }
    
    return merged;
  }

  /**
   * Resolve field-level conflicts
   */
  resolveFieldLevelConflicts(serverData, clientData, metadata) {
    const resolved = _.cloneDeep(serverData);
    
    // Field-specific resolution rules
    const fieldRules = {
      'name': 'client-wins',
      'description': 'merge',
      'status': 'server-wins',
      'coordinates': 'client-wins',
      'size': 'last-write-wins',
    };
    
    for (const [field, value] of Object.entries(clientData)) {
      if (field === 'id' || field === 'createdAt') continue;
      
      const rule = fieldRules[field] || 'last-write-wins';
      
      switch (rule) {
        case 'client-wins':
          resolved[field] = value;
          break;
        case 'server-wins':
          // Keep server value
          break;
        case 'merge':
          if (typeof value === 'string' && typeof resolved[field] === 'string') {
            resolved[field] = `${resolved[field]} | ${value}`;
          } else {
            resolved[field] = value;
          }
          break;
        case 'last-write-wins':
        default:
          const serverTime = new Date(serverData.updatedAt || 0);
          const clientTime = new Date(clientData.updatedAt || 0);
          resolved[field] = clientTime > serverTime ? value : resolved[field];
          break;
      }
    }
    
    return resolved;
  }

  /**
   * Get server changes since timestamp
   */
  async getServerChanges(userId, entityType, lastSyncTimestamp) {
    // This would integrate with the actual data services
    // For now, return mock structure
    return {
      data: [],
      deletions: [],
    };
  }

  /**
   * Get server entity by ID
   */
  async getServerEntity(entityType, entityId) {
    // This would integrate with the actual data services
    // For now, return null
    return null;
  }

  /**
   * Apply resolved entity to server
   */
  async applyResolution(entityType, entityId, resolution) {
    // Store the resolved entity
    await this.applyEntity(entityType, resolution.resolvedEntity);
    
    // Log the conflict resolution
    logger.info(`Conflict resolved for ${entityType}:${entityId} using ${resolution.strategy}`);
  }

  /**
   * Apply entity to server
   */
  async applyEntity(entityType, entity) {
    // This would integrate with the actual data services
    // For now, just log
    logger.info(`Applied ${entityType} entity: ${entity.id}`);
  }

  /**
   * Store sync result for audit
   */
  async storeSyncResult(syncId, result) {
    const key = `sync:result:${syncId}`;
    await this.redis.setex(key, 86400, JSON.stringify(result)); // 24 hours
  }

  /**
   * Get sync result by ID
   */
  async getSyncResult(syncId) {
    const key = `sync:result:${syncId}`;
    const result = await this.redis.get(key);
    return result ? JSON.parse(result) : null;
  }
}

module.exports = SyncEngine;

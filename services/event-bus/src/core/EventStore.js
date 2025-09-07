const { v4: uuidv4 } = require('uuid');
const logger = require('../utils/logger');

/**
 * Event Store implementation for Event Sourcing
 * Stores all domain events for audit and replay capabilities
 */
class EventStore {
  constructor(redisClient) {
    this.redis = redisClient;
    this.eventStoreKey = 'kaziapp:event-store';
    this.aggregateIndexKey = 'kaziapp:aggregate-index';
    this.snapshotKey = 'kaziapp:snapshots';
  }

  /**
   * Initialize the event store
   */
  async initialize() {
    try {
      // Ensure event store structures exist
      await this.ensureStoreExists();
      logger.info('Event store initialized successfully');
    } catch (error) {
      logger.error('Failed to initialize event store:', error);
      throw error;
    }
  }

  /**
   * Append events to the event store
   */
  async appendEvents(aggregateId, aggregateType, events, expectedVersion = -1) {
    try {
      const aggregateKey = `${this.eventStoreKey}:${aggregateType}:${aggregateId}`;
      
      // Check expected version for optimistic concurrency control
      if (expectedVersion >= 0) {
        const currentVersion = await this.getAggregateVersion(aggregateId, aggregateType);
        if (currentVersion !== expectedVersion) {
          throw new Error(`Concurrency conflict. Expected version ${expectedVersion}, but current version is ${currentVersion}`);
        }
      }

      const pipeline = this.redis.multi();
      const timestamp = new Date().toISOString();
      let version = expectedVersion >= 0 ? expectedVersion : await this.getAggregateVersion(aggregateId, aggregateType);

      for (const event of events) {
        version++;
        
        const eventRecord = {
          eventId: event.eventId || uuidv4(),
          aggregateId,
          aggregateType,
          eventType: event.eventType,
          eventData: JSON.stringify(event.eventData),
          metadata: JSON.stringify({
            ...event.metadata,
            version,
            timestamp,
            correlationId: event.metadata?.correlationId || uuidv4(),
          }),
          version,
          timestamp,
        };

        // Add event to aggregate stream
        pipeline.xAdd(aggregateKey, '*', eventRecord);
        
        // Add to global event store
        pipeline.xAdd(this.eventStoreKey, '*', {
          ...eventRecord,
          aggregateKey,
        });

        // Update aggregate index
        pipeline.hSet(`${this.aggregateIndexKey}:${aggregateType}:${aggregateId}`, {
          lastEventId: eventRecord.eventId,
          version,
          lastUpdated: timestamp,
        });
      }

      const results = await pipeline.exec();
      
      logger.info(`Appended ${events.length} events for aggregate ${aggregateType}:${aggregateId}`);
      
      return {
        aggregateId,
        aggregateType,
        version,
        eventsAppended: events.length,
        streamIds: results.slice(0, events.length).map(r => r[1]),
      };
    } catch (error) {
      logger.error(`Failed to append events for ${aggregateType}:${aggregateId}:`, error);
      throw error;
    }
  }

  /**
   * Get events for an aggregate
   */
  async getEvents(aggregateId, aggregateType, fromVersion = 0, toVersion = -1) {
    try {
      const aggregateKey = `${this.eventStoreKey}:${aggregateType}:${aggregateId}`;
      
      // Read events from stream
      const events = await this.redis.xRange(aggregateKey, '-', '+');
      
      const filteredEvents = events
        .map(event => ({
          streamId: event.id,
          eventId: event.message.eventId,
          aggregateId: event.message.aggregateId,
          aggregateType: event.message.aggregateType,
          eventType: event.message.eventType,
          eventData: JSON.parse(event.message.eventData),
          metadata: JSON.parse(event.message.metadata),
          version: parseInt(event.message.version),
          timestamp: event.message.timestamp,
        }))
        .filter(event => {
          return event.version >= fromVersion && 
                 (toVersion === -1 || event.version <= toVersion);
        })
        .sort((a, b) => a.version - b.version);

      return filteredEvents;
    } catch (error) {
      logger.error(`Failed to get events for ${aggregateType}:${aggregateId}:`, error);
      throw error;
    }
  }

  /**
   * Get all events from a specific timestamp
   */
  async getEventsFromTimestamp(timestamp, limit = 100) {
    try {
      const events = await this.redis.xRange(this.eventStoreKey, '-', '+', {
        COUNT: limit,
      });

      return events
        .map(event => ({
          streamId: event.id,
          eventId: event.message.eventId,
          aggregateId: event.message.aggregateId,
          aggregateType: event.message.aggregateType,
          eventType: event.message.eventType,
          eventData: JSON.parse(event.message.eventData),
          metadata: JSON.parse(event.message.metadata),
          version: parseInt(event.message.version),
          timestamp: event.message.timestamp,
        }))
        .filter(event => new Date(event.timestamp) >= new Date(timestamp))
        .sort((a, b) => new Date(a.timestamp) - new Date(b.timestamp));
    } catch (error) {
      logger.error('Failed to get events from timestamp:', error);
      throw error;
    }
  }

  /**
   * Get events by event type
   */
  async getEventsByType(eventType, limit = 100) {
    try {
      const events = await this.redis.xRange(this.eventStoreKey, '-', '+', {
        COUNT: limit,
      });

      return events
        .map(event => ({
          streamId: event.id,
          eventId: event.message.eventId,
          aggregateId: event.message.aggregateId,
          aggregateType: event.message.aggregateType,
          eventType: event.message.eventType,
          eventData: JSON.parse(event.message.eventData),
          metadata: JSON.parse(event.message.metadata),
          version: parseInt(event.message.version),
          timestamp: event.message.timestamp,
        }))
        .filter(event => event.eventType === eventType)
        .sort((a, b) => new Date(a.timestamp) - new Date(b.timestamp));
    } catch (error) {
      logger.error(`Failed to get events by type ${eventType}:`, error);
      throw error;
    }
  }

  /**
   * Save aggregate snapshot
   */
  async saveSnapshot(aggregateId, aggregateType, snapshot, version) {
    try {
      const snapshotKey = `${this.snapshotKey}:${aggregateType}:${aggregateId}`;
      
      const snapshotRecord = {
        aggregateId,
        aggregateType,
        version,
        snapshot: JSON.stringify(snapshot),
        timestamp: new Date().toISOString(),
      };

      await this.redis.hSet(snapshotKey, snapshotRecord);
      
      logger.info(`Saved snapshot for ${aggregateType}:${aggregateId} at version ${version}`);
      
      return snapshotRecord;
    } catch (error) {
      logger.error(`Failed to save snapshot for ${aggregateType}:${aggregateId}:`, error);
      throw error;
    }
  }

  /**
   * Get aggregate snapshot
   */
  async getSnapshot(aggregateId, aggregateType) {
    try {
      const snapshotKey = `${this.snapshotKey}:${aggregateType}:${aggregateId}`;
      const snapshot = await this.redis.hGetAll(snapshotKey);
      
      if (Object.keys(snapshot).length === 0) {
        return null;
      }

      return {
        aggregateId: snapshot.aggregateId,
        aggregateType: snapshot.aggregateType,
        version: parseInt(snapshot.version),
        snapshot: JSON.parse(snapshot.snapshot),
        timestamp: snapshot.timestamp,
      };
    } catch (error) {
      logger.error(`Failed to get snapshot for ${aggregateType}:${aggregateId}:`, error);
      return null;
    }
  }

  /**
   * Get current version of an aggregate
   */
  async getAggregateVersion(aggregateId, aggregateType) {
    try {
      const indexKey = `${this.aggregateIndexKey}:${aggregateType}:${aggregateId}`;
      const version = await this.redis.hGet(indexKey, 'version');
      return version ? parseInt(version) : 0;
    } catch (error) {
      logger.error(`Failed to get version for ${aggregateType}:${aggregateId}:`, error);
      return 0;
    }
  }

  /**
   * Check if aggregate exists
   */
  async aggregateExists(aggregateId, aggregateType) {
    try {
      const indexKey = `${this.aggregateIndexKey}:${aggregateType}:${aggregateId}`;
      const exists = await this.redis.exists(indexKey);
      return exists === 1;
    } catch (error) {
      logger.error(`Failed to check existence of ${aggregateType}:${aggregateId}:`, error);
      return false;
    }
  }

  /**
   * Get aggregate statistics
   */
  async getAggregateStats(aggregateType) {
    try {
      const pattern = `${this.aggregateIndexKey}:${aggregateType}:*`;
      const keys = await this.redis.keys(pattern);
      
      const stats = {
        aggregateType,
        totalAggregates: keys.length,
        aggregates: [],
      };

      for (const key of keys.slice(0, 100)) { // Limit to first 100
        const aggregateData = await this.redis.hGetAll(key);
        if (Object.keys(aggregateData).length > 0) {
          const aggregateId = key.split(':').pop();
          stats.aggregates.push({
            aggregateId,
            version: parseInt(aggregateData.version),
            lastUpdated: aggregateData.lastUpdated,
          });
        }
      }

      return stats;
    } catch (error) {
      logger.error(`Failed to get stats for ${aggregateType}:`, error);
      return null;
    }
  }

  /**
   * Replay events for an aggregate
   */
  async replayEvents(aggregateId, aggregateType, eventHandler) {
    try {
      const events = await this.getEvents(aggregateId, aggregateType);
      
      let aggregate = null;
      
      for (const event of events) {
        aggregate = await eventHandler(aggregate, event);
      }
      
      return aggregate;
    } catch (error) {
      logger.error(`Failed to replay events for ${aggregateType}:${aggregateId}:`, error);
      throw error;
    }
  }

  /**
   * Ensure store structures exist
   */
  async ensureStoreExists() {
    try {
      // Create main event store stream if it doesn't exist
      try {
        await this.redis.xInfoStream(this.eventStoreKey);
      } catch (error) {
        if (error.message.includes('no such key')) {
          await this.redis.xAdd(this.eventStoreKey, '*', { init: 'true' });
          logger.info('Created main event store stream');
        }
      }
    } catch (error) {
      logger.error('Failed to ensure store exists:', error);
      throw error;
    }
  }

  /**
   * Get event store statistics
   */
  async getStats() {
    try {
      const streamInfo = await this.redis.xInfoStream(this.eventStoreKey);
      const indexKeys = await this.redis.keys(`${this.aggregateIndexKey}:*`);
      const snapshotKeys = await this.redis.keys(`${this.snapshotKey}:*`);

      return {
        totalEvents: streamInfo.length,
        totalAggregates: indexKeys.length,
        totalSnapshots: snapshotKeys.length,
        firstEvent: streamInfo['first-entry'],
        lastEvent: streamInfo['last-entry'],
      };
    } catch (error) {
      logger.error('Failed to get event store stats:', error);
      return null;
    }
  }
}

module.exports = EventStore;

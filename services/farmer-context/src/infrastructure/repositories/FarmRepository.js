const Farm = require('../../domain/aggregates/Farm');
const logger = require('../../utils/logger');

/**
 * Farm Repository implementing Event Sourcing pattern
 * Persists and retrieves Farm aggregates using event store
 */
class FarmRepository {
  constructor(eventStore, eventBus) {
    this.eventStore = eventStore;
    this.eventBus = eventBus;
  }

  /**
   * Save farm aggregate (persist uncommitted events)
   */
  async save(farm) {
    try {
      if (!farm.hasUncommittedEvents()) {
        return farm;
      }

      const uncommittedEvents = farm.getUncommittedEvents();
      
      // Append events to event store
      const result = await this.eventStore.appendEvents(
        farm.id,
        'Farm',
        uncommittedEvents.map(event => ({
          eventId: event.eventId,
          eventType: event.eventType,
          eventData: event.eventData,
          metadata: event.metadata,
        })),
        farm.version - uncommittedEvents.length // Expected version before new events
      );

      // Mark events as committed
      farm.markEventsAsCommitted();

      // Publish integration events to event bus
      for (const event of uncommittedEvents) {
        if (event.isIntegrationEvent()) {
          await this.eventBus.publish(
            'farmer-events',
            event.eventType,
            event.getIntegrationEventData(),
            {
              correlationId: event.metadata.correlationId,
              causationId: event.metadata.causationId,
              source: 'farmer-context',
              aggregateId: event.aggregateId,
              aggregateType: event.aggregateType,
            }
          );
        }
      }

      logger.info(`Farm ${farm.id} saved with ${uncommittedEvents.length} events`);
      return farm;

    } catch (error) {
      logger.error(`Error saving farm ${farm.id}:`, error);
      throw error;
    }
  }

  /**
   * Get farm by ID (rebuild from events)
   */
  async getById(farmId) {
    try {
      // Try to get snapshot first
      const snapshot = await this.eventStore.getSnapshot(farmId, 'Farm');
      
      let farm;
      let fromVersion = 0;

      if (snapshot) {
        // Restore from snapshot
        farm = new Farm(farmId);
        farm.loadFromSnapshot(snapshot);
        fromVersion = snapshot.version + 1;
        
        logger.debug(`Loaded farm ${farmId} from snapshot at version ${snapshot.version}`);
      } else {
        // Create new farm instance
        farm = new Farm(farmId);
      }

      // Get events since snapshot (or all events if no snapshot)
      const events = await this.eventStore.getEvents(farmId, 'Farm', fromVersion);
      
      if (events.length === 0 && !snapshot) {
        return null; // Farm doesn't exist
      }

      // Apply events to rebuild current state
      farm.loadFromHistory(events);

      logger.debug(`Loaded farm ${farmId} with ${events.length} events from version ${fromVersion}`);
      return farm;

    } catch (error) {
      logger.error(`Error loading farm ${farmId}:`, error);
      throw error;
    }
  }

  /**
   * Find farms by farmer ID
   */
  async findByFarmerId(farmerId) {
    try {
      // This would typically use a read model or index
      // For now, we'll use a simple approach
      const farms = [];
      
      // In a real implementation, you'd have an index of farm IDs by farmer
      // For demo purposes, we'll return empty array
      // This should be implemented using read models in CQRS
      
      logger.debug(`Found ${farms.length} farms for farmer ${farmerId}`);
      return farms;

    } catch (error) {
      logger.error(`Error finding farms for farmer ${farmerId}:`, error);
      throw error;
    }
  }

  /**
   * Check if farm exists
   */
  async exists(farmId) {
    try {
      return await this.eventStore.aggregateExists(farmId, 'Farm');
    } catch (error) {
      logger.error(`Error checking if farm ${farmId} exists:`, error);
      return false;
    }
  }

  /**
   * Get farm version
   */
  async getVersion(farmId) {
    try {
      return await this.eventStore.getAggregateVersion(farmId, 'Farm');
    } catch (error) {
      logger.error(`Error getting version for farm ${farmId}:`, error);
      return 0;
    }
  }

  /**
   * Create snapshot for farm (for performance optimization)
   */
  async createSnapshot(farmId) {
    try {
      const farm = await this.getById(farmId);
      if (!farm) {
        throw new Error(`Farm ${farmId} not found`);
      }

      const snapshot = farm.createSnapshot();
      await this.eventStore.saveSnapshot(farmId, 'Farm', snapshot.state, farm.version);
      
      logger.info(`Created snapshot for farm ${farmId} at version ${farm.version}`);
      return snapshot;

    } catch (error) {
      logger.error(`Error creating snapshot for farm ${farmId}:`, error);
      throw error;
    }
  }

  /**
   * Replay events for farm (useful for debugging or migration)
   */
  async replayEvents(farmId, eventHandler) {
    try {
      return await this.eventStore.replayEvents(farmId, 'Farm', eventHandler);
    } catch (error) {
      logger.error(`Error replaying events for farm ${farmId}:`, error);
      throw error;
    }
  }

  /**
   * Get farm statistics
   */
  async getStats() {
    try {
      return await this.eventStore.getAggregateStats('Farm');
    } catch (error) {
      logger.error('Error getting farm stats:', error);
      return null;
    }
  }
}

module.exports = FarmRepository;

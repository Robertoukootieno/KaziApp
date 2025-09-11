const logger = require('../utils/logger');

/**
 * Event Bus Client for publishing and subscribing to events
 */
class EventBusClient {
  constructor(redisClient) {
    this.redis = redisClient;
    this.subscribers = new Map();
    this.isInitialized = false;
  }

  async initialize() {
    try {
      // Create a separate Redis client for subscriptions
      this.subClient = this.redis.duplicate();
      await this.subClient.connect();
      
      this.isInitialized = true;
      logger.info('EventBusClient initialized successfully');
    } catch (error) {
      logger.error('Failed to initialize EventBusClient:', error);
      throw error;
    }
  }

  /**
   * Publish an event to a stream
   */
  async publish(streamName, event) {
    try {
      if (!this.isInitialized) {
        throw new Error('EventBusClient not initialized');
      }

      const eventData = {
        id: `${Date.now()}-${Math.random().toString(36).substr(2, 9)}`,
        timestamp: new Date().toISOString(),
        ...event,
      };

      // Add to Redis Stream
      await this.redis.xAdd(streamName, '*', eventData);
      
      logger.debug(`Published event to ${streamName}:`, eventData);
      
      return eventData.id;
    } catch (error) {
      logger.error(`Error publishing event to ${streamName}:`, error);
      throw error;
    }
  }

  /**
   * Subscribe to events from a stream
   */
  async subscribe(streamName, handler) {
    try {
      if (!this.isInitialized) {
        throw new Error('EventBusClient not initialized');
      }

      // Store handler
      if (!this.subscribers.has(streamName)) {
        this.subscribers.set(streamName, []);
      }
      this.subscribers.get(streamName).push(handler);

      // Create consumer group if it doesn't exist
      const groupName = `booking-service-${process.env.NODE_ENV || 'dev'}`;
      const consumerName = `booking-consumer-${process.pid}`;

      try {
        await this.redis.xGroupCreate(streamName, groupName, '0', { MKSTREAM: true });
      } catch (error) {
        // Group might already exist, ignore error
        if (!error.message.includes('BUSYGROUP')) {
          throw error;
        }
      }

      // Start consuming
      this.consumeStream(streamName, groupName, consumerName);
      
      logger.info(`Subscribed to ${streamName} with group ${groupName}`);
    } catch (error) {
      logger.error(`Error subscribing to ${streamName}:`, error);
      throw error;
    }
  }

  /**
   * Consume events from a stream
   */
  async consumeStream(streamName, groupName, consumerName) {
    try {
      while (this.isInitialized) {
        try {
          // Read from stream
          const results = await this.subClient.xReadGroup(
            groupName,
            consumerName,
            [{ key: streamName, id: '>' }],
            { COUNT: 10, BLOCK: 5000 }
          );

          if (results && results.length > 0) {
            for (const stream of results) {
              for (const message of stream.messages) {
                await this.processMessage(streamName, message);
                
                // Acknowledge message
                await this.subClient.xAck(streamName, groupName, message.id);
              }
            }
          }
        } catch (error) {
          if (error.message.includes('NOGROUP')) {
            // Consumer group was deleted, recreate it
            await this.redis.xGroupCreate(streamName, groupName, '0', { MKSTREAM: true });
            continue;
          }
          
          logger.error(`Error consuming from ${streamName}:`, error);
          await new Promise(resolve => setTimeout(resolve, 5000)); // Wait 5 seconds before retry
        }
      }
    } catch (error) {
      logger.error(`Fatal error in stream consumer for ${streamName}:`, error);
    }
  }

  /**
   * Process a message from the stream
   */
  async processMessage(streamName, message) {
    try {
      const handlers = this.subscribers.get(streamName) || [];
      
      if (handlers.length === 0) {
        logger.warn(`No handlers for stream ${streamName}`);
        return;
      }

      // Convert Redis message format to event object
      const event = {};
      for (let i = 0; i < message.message.length; i += 2) {
        const key = message.message[i];
        const value = message.message[i + 1];
        
        // Try to parse JSON values
        try {
          event[key] = JSON.parse(value);
        } catch {
          event[key] = value;
        }
      }

      // Call all handlers
      const handlerPromises = handlers.map(handler => 
        Promise.resolve(handler(event)).catch(error => {
          logger.error(`Error in event handler for ${streamName}:`, error);
        })
      );

      await Promise.allSettled(handlerPromises);
      
      logger.debug(`Processed message from ${streamName}:`, event);
    } catch (error) {
      logger.error(`Error processing message from ${streamName}:`, error);
    }
  }

  /**
   * Unsubscribe from a stream
   */
  async unsubscribe(streamName, handler) {
    try {
      const handlers = this.subscribers.get(streamName);
      if (handlers) {
        const index = handlers.indexOf(handler);
        if (index > -1) {
          handlers.splice(index, 1);
        }
        
        if (handlers.length === 0) {
          this.subscribers.delete(streamName);
        }
      }
      
      logger.info(`Unsubscribed from ${streamName}`);
    } catch (error) {
      logger.error(`Error unsubscribing from ${streamName}:`, error);
    }
  }

  /**
   * Close the event bus client
   */
  async close() {
    try {
      this.isInitialized = false;
      
      if (this.subClient) {
        await this.subClient.quit();
      }
      
      this.subscribers.clear();
      
      logger.info('EventBusClient closed');
    } catch (error) {
      logger.error('Error closing EventBusClient:', error);
    }
  }

  /**
   * Get stream info
   */
  async getStreamInfo(streamName) {
    try {
      const info = await this.redis.xInfoStream(streamName);
      return info;
    } catch (error) {
      logger.error(`Error getting stream info for ${streamName}:`, error);
      return null;
    }
  }

  /**
   * Get pending messages for a consumer group
   */
  async getPendingMessages(streamName, groupName) {
    try {
      const pending = await this.redis.xPending(streamName, groupName);
      return pending;
    } catch (error) {
      logger.error(`Error getting pending messages for ${streamName}:`, error);
      return null;
    }
  }
}

module.exports = EventBusClient;

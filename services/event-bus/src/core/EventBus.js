const { v4: uuidv4 } = require('uuid');
const logger = require('../utils/logger');

/**
 * Event Bus implementation using Redis Streams
 * Provides publish/subscribe functionality for domain events
 */
class EventBus {
  constructor(redisClient) {
    this.redis = redisClient;
    this.consumers = new Map();
    this.streams = new Map();
    this.isRunning = false;
    
    // Default streams for each bounded context
    this.defaultStreams = [
      'farmer-events',
      'service-provider-events',
      'marketplace-events',
      'identity-events',
      'payment-events',
      'communication-events',
    ];
  }

  /**
   * Initialize the event bus
   */
  async initialize() {
    try {
      // Create default streams if they don't exist
      for (const streamName of this.defaultStreams) {
        await this.ensureStreamExists(streamName);
      }
      
      this.isRunning = true;
      logger.info('Event bus initialized successfully');
    } catch (error) {
      logger.error('Failed to initialize event bus:', error);
      throw error;
    }
  }

  /**
   * Publish an event to a stream
   */
  async publish(streamName, eventType, eventData, metadata = {}) {
    try {
      const eventId = uuidv4();
      const timestamp = new Date().toISOString();
      
      const event = {
        id: eventId,
        type: eventType,
        timestamp,
        data: JSON.stringify(eventData),
        metadata: JSON.stringify({
          ...metadata,
          version: '1.0',
          source: metadata.source || 'unknown',
          correlationId: metadata.correlationId || eventId,
        }),
      };

      // Add event to Redis Stream
      const result = await this.redis.xAdd(streamName, '*', event);
      
      logger.info(`Event published to ${streamName}:`, {
        eventId,
        eventType,
        streamId: result,
      });

      return {
        eventId,
        streamId: result,
        streamName,
        timestamp,
      };
    } catch (error) {
      logger.error(`Failed to publish event to ${streamName}:`, error);
      throw error;
    }
  }

  /**
   * Subscribe to events from a stream
   */
  async subscribe(streamName, consumerGroup, consumerName, handler, options = {}) {
    try {
      // Ensure stream exists
      await this.ensureStreamExists(streamName);
      
      // Create consumer group if it doesn't exist
      try {
        await this.redis.xGroupCreate(streamName, consumerGroup, '0', {
          MKSTREAM: true,
        });
      } catch (error) {
        // Group might already exist, ignore BUSYGROUP error
        if (!error.message.includes('BUSYGROUP')) {
          throw error;
        }
      }

      const consumerId = `${consumerGroup}:${consumerName}`;
      
      // Store consumer info
      this.consumers.set(consumerId, {
        streamName,
        consumerGroup,
        consumerName,
        handler,
        options,
        isActive: true,
      });

      // Start consuming messages
      this.startConsumer(consumerId);
      
      logger.info(`Subscribed to ${streamName} with consumer ${consumerId}`);
      
      return consumerId;
    } catch (error) {
      logger.error(`Failed to subscribe to ${streamName}:`, error);
      throw error;
    }
  }

  /**
   * Start consuming messages for a consumer
   */
  async startConsumer(consumerId) {
    const consumer = this.consumers.get(consumerId);
    if (!consumer || !consumer.isActive) {
      return;
    }

    const { streamName, consumerGroup, consumerName, handler, options } = consumer;
    const batchSize = options.batchSize || 10;
    const blockTime = options.blockTime || 1000; // 1 second

    try {
      while (consumer.isActive && this.isRunning) {
        // Read pending messages first
        const pendingMessages = await this.redis.xReadGroup(
          consumerGroup,
          consumerName,
          [{ key: streamName, id: '0' }],
          { COUNT: batchSize }
        );

        if (pendingMessages && pendingMessages.length > 0) {
          await this.processMessages(pendingMessages[0].messages, handler, consumer);
        }

        // Read new messages
        const newMessages = await this.redis.xReadGroup(
          consumerGroup,
          consumerName,
          [{ key: streamName, id: '>' }],
          { COUNT: batchSize, BLOCK: blockTime }
        );

        if (newMessages && newMessages.length > 0) {
          await this.processMessages(newMessages[0].messages, handler, consumer);
        }
      }
    } catch (error) {
      logger.error(`Consumer ${consumerId} error:`, error);
      
      // Restart consumer after delay
      setTimeout(() => {
        if (consumer.isActive) {
          this.startConsumer(consumerId);
        }
      }, 5000);
    }
  }

  /**
   * Process messages from stream
   */
  async processMessages(messages, handler, consumer) {
    for (const message of messages) {
      try {
        const event = {
          id: message.message.id,
          type: message.message.type,
          timestamp: message.message.timestamp,
          data: JSON.parse(message.message.data),
          metadata: JSON.parse(message.message.metadata),
          streamId: message.id,
        };

        // Call the handler
        await handler(event);

        // Acknowledge the message
        await this.redis.xAck(
          consumer.streamName,
          consumer.consumerGroup,
          message.id
        );

        logger.debug(`Processed event ${event.id} from ${consumer.streamName}`);
      } catch (error) {
        logger.error(`Failed to process message ${message.id}:`, error);
        
        // Optionally move to dead letter queue
        await this.handleFailedMessage(message, consumer, error);
      }
    }
  }

  /**
   * Handle failed message processing
   */
  async handleFailedMessage(message, consumer, error) {
    try {
      const deadLetterStream = `${consumer.streamName}-dlq`;
      
      await this.redis.xAdd(deadLetterStream, '*', {
        originalStreamId: message.id,
        originalStream: consumer.streamName,
        consumerGroup: consumer.consumerGroup,
        consumerName: consumer.consumerName,
        error: error.message,
        timestamp: new Date().toISOString(),
        ...message.message,
      });

      // Acknowledge the original message to prevent reprocessing
      await this.redis.xAck(
        consumer.streamName,
        consumer.consumerGroup,
        message.id
      );

      logger.warn(`Message ${message.id} moved to dead letter queue`);
    } catch (dlqError) {
      logger.error('Failed to handle failed message:', dlqError);
    }
  }

  /**
   * Unsubscribe a consumer
   */
  async unsubscribe(consumerId) {
    const consumer = this.consumers.get(consumerId);
    if (consumer) {
      consumer.isActive = false;
      this.consumers.delete(consumerId);
      logger.info(`Unsubscribed consumer ${consumerId}`);
    }
  }

  /**
   * Get stream information
   */
  async getStreamInfo(streamName) {
    try {
      const info = await this.redis.xInfoStream(streamName);
      return {
        length: info.length,
        radixTreeKeys: info['radix-tree-keys'],
        radixTreeNodes: info['radix-tree-nodes'],
        groups: info.groups,
        lastGeneratedId: info['last-generated-id'],
        firstEntry: info['first-entry'],
        lastEntry: info['last-entry'],
      };
    } catch (error) {
      logger.error(`Failed to get stream info for ${streamName}:`, error);
      return null;
    }
  }

  /**
   * Get consumer group information
   */
  async getConsumerGroupInfo(streamName) {
    try {
      const groups = await this.redis.xInfoGroups(streamName);
      return groups.map(group => ({
        name: group.name,
        consumers: group.consumers,
        pending: group.pending,
        lastDeliveredId: group['last-delivered-id'],
      }));
    } catch (error) {
      logger.error(`Failed to get consumer group info for ${streamName}:`, error);
      return [];
    }
  }

  /**
   * Ensure stream exists
   */
  async ensureStreamExists(streamName) {
    try {
      // Try to get stream info
      await this.redis.xInfoStream(streamName);
    } catch (error) {
      if (error.message.includes('no such key')) {
        // Stream doesn't exist, create it with a dummy message
        await this.redis.xAdd(streamName, '*', { init: 'true' });
        logger.info(`Created stream: ${streamName}`);
      } else {
        throw error;
      }
    }
  }

  /**
   * Health check
   */
  async healthCheck() {
    try {
      const streamCount = this.defaultStreams.length;
      const consumerCount = this.consumers.size;
      const activeConsumers = Array.from(this.consumers.values())
        .filter(c => c.isActive).length;

      return {
        status: 'healthy',
        isRunning: this.isRunning,
        streamCount,
        consumerCount,
        activeConsumers,
        streams: this.defaultStreams,
      };
    } catch (error) {
      return {
        status: 'unhealthy',
        error: error.message,
      };
    }
  }

  /**
   * Shutdown the event bus
   */
  async shutdown() {
    this.isRunning = false;
    
    // Stop all consumers
    for (const [consumerId, consumer] of this.consumers) {
      consumer.isActive = false;
    }
    
    this.consumers.clear();
    logger.info('Event bus shutdown complete');
  }
}

module.exports = EventBus;

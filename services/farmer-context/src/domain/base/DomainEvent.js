const { v4: uuidv4 } = require('uuid');

/**
 * Base class for all domain events
 * Provides common structure and functionality for domain events
 */
class DomainEvent {
  constructor(eventType, eventData, metadata = {}) {
    this.eventId = uuidv4();
    this.eventType = eventType;
    this.eventData = eventData;
    this.metadata = {
      timestamp: new Date().toISOString(),
      correlationId: metadata.correlationId || uuidv4(),
      causationId: metadata.causationId || null,
      source: metadata.source || 'farmer-context',
      version: metadata.version || '1.0',
      ...metadata,
    };
    
    // These will be set by the aggregate root
    this.aggregateId = null;
    this.aggregateType = null;
    this.version = 0;
    
    // Validate the event
    this.validate();
  }

  /**
   * Validate event data (to be overridden by subclasses)
   */
  validate() {
    if (!this.eventType) {
      throw new Error('Event type is required');
    }
    
    if (!this.eventData) {
      throw new Error('Event data is required');
    }
  }

  /**
   * Get event as plain object for serialization
   */
  toPlainObject() {
    return {
      eventId: this.eventId,
      eventType: this.eventType,
      eventData: this.eventData,
      metadata: this.metadata,
      aggregateId: this.aggregateId,
      aggregateType: this.aggregateType,
      version: this.version,
    };
  }

  /**
   * Create event from plain object
   */
  static fromPlainObject(obj) {
    const event = new this(obj.eventType, obj.eventData, obj.metadata);
    event.eventId = obj.eventId;
    event.aggregateId = obj.aggregateId;
    event.aggregateType = obj.aggregateType;
    event.version = obj.version;
    return event;
  }

  /**
   * Get event summary for logging (to be overridden by subclasses)
   */
  getSummary() {
    return `${this.eventType} event for aggregate ${this.aggregateType}:${this.aggregateId}`;
  }

  /**
   * Check if this is an integration event (should be published to other contexts)
   */
  isIntegrationEvent() {
    return this.metadata.isIntegrationEvent === true;
  }

  /**
   * Mark as integration event
   */
  markAsIntegrationEvent() {
    this.metadata.isIntegrationEvent = true;
    return this;
  }

  /**
   * Get integration event data (to be overridden by subclasses)
   */
  getIntegrationEventData() {
    return this.eventData;
  }

  /**
   * Add correlation context
   */
  withCorrelation(correlationId, causationId = null) {
    this.metadata.correlationId = correlationId;
    if (causationId) {
      this.metadata.causationId = causationId;
    }
    return this;
  }

  /**
   * Add source context
   */
  withSource(source) {
    this.metadata.source = source;
    return this;
  }

  /**
   * Add custom metadata
   */
  withMetadata(metadata) {
    this.metadata = { ...this.metadata, ...metadata };
    return this;
  }

  /**
   * Check if event occurred before given timestamp
   */
  occurredBefore(timestamp) {
    return new Date(this.metadata.timestamp) < new Date(timestamp);
  }

  /**
   * Check if event occurred after given timestamp
   */
  occurredAfter(timestamp) {
    return new Date(this.metadata.timestamp) > new Date(timestamp);
  }

  /**
   * Get event age in milliseconds
   */
  getAge() {
    return Date.now() - new Date(this.metadata.timestamp).getTime();
  }

  /**
   * Check if event is stale (older than given milliseconds)
   */
  isStale(maxAgeMs = 300000) { // 5 minutes default
    return this.getAge() > maxAgeMs;
  }

  /**
   * Get event hash for deduplication
   */
  getHash() {
    const crypto = require('crypto');
    const data = JSON.stringify({
      eventType: this.eventType,
      eventData: this.eventData,
      aggregateId: this.aggregateId,
      version: this.version,
    });
    return crypto.createHash('sha256').update(data).digest('hex');
  }

  /**
   * Clone the event with new metadata
   */
  clone(newMetadata = {}) {
    const cloned = new this.constructor(this.eventType, this.eventData, {
      ...this.metadata,
      ...newMetadata,
    });
    cloned.eventId = this.eventId;
    cloned.aggregateId = this.aggregateId;
    cloned.aggregateType = this.aggregateType;
    cloned.version = this.version;
    return cloned;
  }
}

module.exports = DomainEvent;

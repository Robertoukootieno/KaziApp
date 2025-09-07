const { v4: uuidv4 } = require('uuid');

/**
 * Base class for all commands in the application layer
 * Commands represent user intentions to change system state
 */
class Command {
  constructor(commandType, data, metadata = {}) {
    this.commandId = uuidv4();
    this.commandType = commandType;
    this.data = data;
    this.metadata = {
      timestamp: new Date().toISOString(),
      correlationId: metadata.correlationId || uuidv4(),
      causationId: metadata.causationId || null,
      source: metadata.source || 'farmer-context',
      userId: metadata.userId || null,
      userType: metadata.userType || null,
      ...metadata,
    };
    
    // Validate the command
    this.validate();
  }

  /**
   * Validate command data (to be overridden by subclasses)
   */
  validate() {
    if (!this.commandType) {
      throw new Error('Command type is required');
    }
    
    if (!this.data) {
      throw new Error('Command data is required');
    }
  }

  /**
   * Get command as plain object for serialization
   */
  toPlainObject() {
    return {
      commandId: this.commandId,
      commandType: this.commandType,
      data: this.data,
      metadata: this.metadata,
    };
  }

  /**
   * Create command from plain object
   */
  static fromPlainObject(obj) {
    const command = new this(obj.commandType, obj.data, obj.metadata);
    command.commandId = obj.commandId;
    return command;
  }

  /**
   * Get command summary for logging (to be overridden by subclasses)
   */
  getSummary() {
    return `${this.commandType} command`;
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
   * Add user context
   */
  withUser(userId, userType) {
    this.metadata.userId = userId;
    this.metadata.userType = userType;
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
   * Check if command is expired
   */
  isExpired(maxAgeMs = 300000) { // 5 minutes default
    const age = Date.now() - new Date(this.metadata.timestamp).getTime();
    return age > maxAgeMs;
  }

  /**
   * Get command age in milliseconds
   */
  getAge() {
    return Date.now() - new Date(this.metadata.timestamp).getTime();
  }

  /**
   * Get command hash for deduplication
   */
  getHash() {
    const crypto = require('crypto');
    const data = JSON.stringify({
      commandType: this.commandType,
      data: this.data,
    });
    return crypto.createHash('sha256').update(data).digest('hex');
  }

  /**
   * Clone the command with new metadata
   */
  clone(newMetadata = {}) {
    const cloned = new this.constructor(this.commandType, this.data, {
      ...this.metadata,
      ...newMetadata,
    });
    cloned.commandId = this.commandId;
    return cloned;
  }
}

module.exports = Command;

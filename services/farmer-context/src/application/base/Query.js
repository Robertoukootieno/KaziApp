const { v4: uuidv4 } = require('uuid');

/**
 * Base class for all queries in the application layer
 * Queries represent requests for data without changing system state
 */
class Query {
  constructor(queryType, data, metadata = {}) {
    this.queryId = uuidv4();
    this.queryType = queryType;
    this.data = data;
    this.metadata = {
      timestamp: new Date().toISOString(),
      correlationId: metadata.correlationId || uuidv4(),
      source: metadata.source || 'farmer-context',
      userId: metadata.userId || null,
      userType: metadata.userType || null,
      ...metadata,
    };
    
    // Validate the query
    this.validate();
  }

  /**
   * Validate query data (to be overridden by subclasses)
   */
  validate() {
    if (!this.queryType) {
      throw new Error('Query type is required');
    }
    
    if (!this.data) {
      throw new Error('Query data is required');
    }
  }

  /**
   * Get query as plain object for serialization
   */
  toPlainObject() {
    return {
      queryId: this.queryId,
      queryType: this.queryType,
      data: this.data,
      metadata: this.metadata,
    };
  }

  /**
   * Create query from plain object
   */
  static fromPlainObject(obj) {
    const query = new this(obj.queryType, obj.data, obj.metadata);
    query.queryId = obj.queryId;
    return query;
  }

  /**
   * Get query summary for logging (to be overridden by subclasses)
   */
  getSummary() {
    return `${this.queryType} query`;
  }

  /**
   * Add correlation context
   */
  withCorrelation(correlationId) {
    this.metadata.correlationId = correlationId;
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
   * Check if query is expired
   */
  isExpired(maxAgeMs = 60000) { // 1 minute default for queries
    const age = Date.now() - new Date(this.metadata.timestamp).getTime();
    return age > maxAgeMs;
  }

  /**
   * Get query age in milliseconds
   */
  getAge() {
    return Date.now() - new Date(this.metadata.timestamp).getTime();
  }

  /**
   * Get query hash for caching
   */
  getHash() {
    const crypto = require('crypto');
    const data = JSON.stringify({
      queryType: this.queryType,
      data: this.data,
    });
    return crypto.createHash('sha256').update(data).digest('hex');
  }

  /**
   * Clone the query with new metadata
   */
  clone(newMetadata = {}) {
    const cloned = new this.constructor(this.queryType, this.data, {
      ...this.metadata,
      ...newMetadata,
    });
    cloned.queryId = this.queryId;
    return cloned;
  }
}

module.exports = Query;

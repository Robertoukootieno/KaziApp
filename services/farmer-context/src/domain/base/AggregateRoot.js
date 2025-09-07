/**
 * Base class for all aggregate roots in the domain
 * Provides event sourcing capabilities and domain event handling
 */
class AggregateRoot {
  constructor(id) {
    this.id = id;
    this.version = 0;
    this.uncommittedEvents = [];
  }

  /**
   * Apply a domain event to the aggregate
   */
  applyEvent(event) {
    // Set aggregate info on the event
    event.aggregateId = this.id;
    event.aggregateType = this.constructor.name;
    event.version = this.version + 1;
    
    // Apply the event to update aggregate state
    this.handleEvent(event);
    
    // Increment version
    this.version = event.version;
    
    // Add to uncommitted events for persistence
    this.uncommittedEvents.push(event);
  }

  /**
   * Handle domain event by calling appropriate handler method
   */
  handleEvent(event) {
    const handlerName = `on${event.eventType}`;
    
    if (typeof this[handlerName] === 'function') {
      this[handlerName](event);
    } else {
      console.warn(`No handler found for event type: ${event.eventType}`);
    }
  }

  /**
   * Get uncommitted events and clear them
   */
  getUncommittedEvents() {
    const events = [...this.uncommittedEvents];
    this.uncommittedEvents = [];
    return events;
  }

  /**
   * Mark events as committed
   */
  markEventsAsCommitted() {
    this.uncommittedEvents = [];
  }

  /**
   * Load aggregate from historical events
   */
  loadFromHistory(events) {
    for (const event of events) {
      this.handleEvent(event);
      this.version = event.version;
    }
    
    // Clear uncommitted events since these are historical
    this.uncommittedEvents = [];
  }

  /**
   * Create a snapshot of the current aggregate state
   */
  createSnapshot() {
    // Create a deep copy of the aggregate state
    const snapshot = {
      id: this.id,
      version: this.version,
      aggregateType: this.constructor.name,
      state: this.getSnapshotData(),
      timestamp: new Date().toISOString(),
    };
    
    return snapshot;
  }

  /**
   * Restore aggregate from snapshot
   */
  loadFromSnapshot(snapshot) {
    this.id = snapshot.id;
    this.version = snapshot.version;
    this.restoreFromSnapshotData(snapshot.state);
    this.uncommittedEvents = [];
  }

  /**
   * Get data for snapshot (to be overridden by subclasses)
   */
  getSnapshotData() {
    // Default implementation - subclasses should override
    const data = { ...this };
    delete data.uncommittedEvents;
    return data;
  }

  /**
   * Restore from snapshot data (to be overridden by subclasses)
   */
  restoreFromSnapshotData(data) {
    // Default implementation - subclasses should override
    Object.assign(this, data);
  }

  /**
   * Check if aggregate has uncommitted changes
   */
  hasUncommittedEvents() {
    return this.uncommittedEvents.length > 0;
  }

  /**
   * Get aggregate metadata
   */
  getMetadata() {
    return {
      id: this.id,
      aggregateType: this.constructor.name,
      version: this.version,
      hasUncommittedEvents: this.hasUncommittedEvents(),
      uncommittedEventCount: this.uncommittedEvents.length,
    };
  }

  /**
   * Validate aggregate invariants (to be overridden by subclasses)
   */
  validateInvariants() {
    // Default implementation - subclasses should override with business rules
    return true;
  }

  /**
   * Check if aggregate is in valid state
   */
  isValid() {
    try {
      return this.validateInvariants();
    } catch (error) {
      return false;
    }
  }

  /**
   * Get validation errors
   */
  getValidationErrors() {
    try {
      this.validateInvariants();
      return [];
    } catch (error) {
      return [error.message];
    }
  }
}

module.exports = AggregateRoot;

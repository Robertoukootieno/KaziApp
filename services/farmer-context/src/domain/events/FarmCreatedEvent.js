const DomainEvent = require('../base/DomainEvent');

/**
 * Domain event fired when a new farm is created
 */
class FarmCreatedEvent extends DomainEvent {
  constructor(eventData, metadata = {}) {
    super('FarmCreated', eventData, metadata);
  }

  /**
   * Validate event data
   */
  validate() {
    const required = ['farmId', 'farmerId', 'name', 'location', 'size', 'sizeUnit', 'farmType'];
    
    for (const field of required) {
      if (!this.eventData[field]) {
        throw new Error(`${field} is required for FarmCreatedEvent`);
      }
    }

    // Validate location structure
    if (!this.eventData.location.county) {
      throw new Error('Location must include county for FarmCreatedEvent');
    }

    // Validate size
    if (this.eventData.size <= 0) {
      throw new Error('Farm size must be greater than 0');
    }

    // Validate size unit
    if (!['acres', 'hectares'].includes(this.eventData.sizeUnit)) {
      throw new Error('Size unit must be acres or hectares');
    }

    // Validate farm type
    if (!['crop', 'livestock', 'mixed'].includes(this.eventData.farmType)) {
      throw new Error('Farm type must be crop, livestock, or mixed');
    }
  }

  /**
   * Get event summary for logging
   */
  getSummary() {
    return `Farm "${this.eventData.name}" created for farmer ${this.eventData.farmerId} in ${this.eventData.location.county}`;
  }

  /**
   * Get integration event data for publishing to other contexts
   */
  getIntegrationEventData() {
    return {
      farmId: this.eventData.farmId,
      farmerId: this.eventData.farmerId,
      farmName: this.eventData.name,
      county: this.eventData.location.county,
      farmType: this.eventData.farmType,
      size: this.eventData.size,
      sizeUnit: this.eventData.sizeUnit,
      createdAt: this.eventData.createdAt,
    };
  }
}

module.exports = FarmCreatedEvent;

const DomainEvent = require('../base/DomainEvent');

/**
 * Domain event fired when a new service provider registers
 */
class ServiceProviderRegisteredEvent extends DomainEvent {
  constructor(eventData, metadata = {}) {
    super('ServiceProviderRegistered', eventData, metadata);
  }

  /**
   * Validate event data
   */
  validate() {
    const required = ['providerId', 'userId', 'providerType', 'businessName', 'specializations', 'serviceAreas'];
    
    for (const field of required) {
      if (!this.eventData[field]) {
        throw new Error(`${field} is required for ServiceProviderRegisteredEvent`);
      }
    }

    // Validate provider type
    if (!['veterinarian', 'agronomist', 'equipment_rental', 'input_supplier'].includes(this.eventData.providerType)) {
      throw new Error('Invalid provider type');
    }

    // Validate specializations
    if (!Array.isArray(this.eventData.specializations) || this.eventData.specializations.length === 0) {
      throw new Error('At least one specialization is required');
    }

    // Validate service areas
    if (!Array.isArray(this.eventData.serviceAreas) || this.eventData.serviceAreas.length === 0) {
      throw new Error('At least one service area is required');
    }
  }

  /**
   * Get event summary for logging
   */
  getSummary() {
    return `Service provider "${this.eventData.businessName}" registered as ${this.eventData.providerType}`;
  }

  /**
   * Get integration event data for publishing to other contexts
   */
  getIntegrationEventData() {
    return {
      providerId: this.eventData.providerId,
      userId: this.eventData.userId,
      providerType: this.eventData.providerType,
      businessName: this.eventData.businessName,
      licenseNumber: this.eventData.licenseNumber,
      specializations: this.eventData.specializations,
      serviceAreas: this.eventData.serviceAreas,
      registeredAt: this.eventData.registeredAt,
    };
  }
}

module.exports = ServiceProviderRegisteredEvent;

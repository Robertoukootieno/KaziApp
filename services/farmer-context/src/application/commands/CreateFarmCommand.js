const Command = require('../base/Command');

/**
 * Command to create a new farm
 */
class CreateFarmCommand extends Command {
  constructor(data, metadata = {}) {
    super('CreateFarm', data, metadata);
  }

  /**
   * Validate command data
   */
  validate() {
    super.validate();
    
    const required = ['farmerId', 'name', 'location', 'size', 'sizeUnit', 'farmType'];
    
    for (const field of required) {
      if (!this.data[field]) {
        throw new Error(`${field} is required for CreateFarmCommand`);
      }
    }

    // Validate location structure
    if (!this.data.location.county) {
      throw new Error('Location must include county');
    }

    // Validate size
    if (this.data.size <= 0) {
      throw new Error('Farm size must be greater than 0');
    }

    // Validate size unit
    if (!['acres', 'hectares'].includes(this.data.sizeUnit)) {
      throw new Error('Size unit must be acres or hectares');
    }

    // Validate farm type
    if (!['crop', 'livestock', 'mixed'].includes(this.data.farmType)) {
      throw new Error('Farm type must be crop, livestock, or mixed');
    }

    // Validate farmer ID format (UUID)
    const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    if (!uuidRegex.test(this.data.farmerId)) {
      throw new Error('Invalid farmer ID format');
    }
  }

  /**
   * Get command summary for logging
   */
  getSummary() {
    return `Create farm "${this.data.name}" for farmer ${this.data.farmerId}`;
  }
}

module.exports = CreateFarmCommand;

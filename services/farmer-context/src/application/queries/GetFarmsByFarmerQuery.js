const Query = require('../base/Query');

/**
 * Query to get all farms for a specific farmer
 */
class GetFarmsByFarmerQuery extends Query {
  constructor(data, metadata = {}) {
    super('GetFarmsByFarmer', data, metadata);
  }

  /**
   * Validate query data
   */
  validate() {
    super.validate();
    
    if (!this.data.farmerId) {
      throw new Error('farmerId is required for GetFarmsByFarmerQuery');
    }

    // Validate farmer ID format (UUID)
    const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    if (!uuidRegex.test(this.data.farmerId)) {
      throw new Error('Invalid farmer ID format');
    }
  }

  /**
   * Get query summary for logging
   */
  getSummary() {
    return `Get farms for farmer ${this.data.farmerId}`;
  }
}

module.exports = GetFarmsByFarmerQuery;

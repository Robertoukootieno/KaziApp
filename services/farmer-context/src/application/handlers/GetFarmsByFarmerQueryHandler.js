const QueryHandler = require('../base/QueryHandler');
const GetFarmsByFarmerQuery = require('../queries/GetFarmsByFarmerQuery');

/**
 * Query handler for getting farms by farmer
 * Implements the query side of CQRS pattern using read models
 */
class GetFarmsByFarmerQueryHandler extends QueryHandler {
  constructor(farmReadModelRepository, logger) {
    super();
    this.farmReadModelRepository = farmReadModelRepository;
    this.logger = logger;
  }

  /**
   * Handle the GetFarmsByFarmerQuery
   */
  async handle(query) {
    try {
      // Validate query type
      if (!(query instanceof GetFarmsByFarmerQuery)) {
        throw new Error('Invalid query type for GetFarmsByFarmerQueryHandler');
      }

      this.logger.info(`Handling GetFarmsByFarmerQuery: ${query.getSummary()}`);

      const { farmerId } = query.data;

      // Get farms from read model (optimized for queries)
      const farms = await this.farmReadModelRepository.findByFarmerId(farmerId);

      // Transform to view model
      const farmViews = farms.map(farm => this.transformToViewModel(farm));

      // Calculate summary statistics
      const summary = this.calculateSummary(farms);

      this.logger.info(`Found ${farms.length} farms for farmer ${farmerId}`);

      return {
        success: true,
        data: {
          farms: farmViews,
          summary,
          totalCount: farms.length,
        },
        metadata: {
          queryId: query.queryId,
          farmerId,
          timestamp: new Date().toISOString(),
        },
      };

    } catch (error) {
      this.logger.error(`Error handling GetFarmsByFarmerQuery:`, error);
      
      return {
        success: false,
        error: error.message,
        queryId: query.queryId,
      };
    }
  }

  /**
   * Transform farm read model to view model
   */
  transformToViewModel(farm) {
    return {
      id: farm.id,
      name: farm.name,
      location: {
        county: farm.county,
        subCounty: farm.subCounty,
        ward: farm.ward,
        coordinates: farm.coordinates,
      },
      size: farm.size,
      sizeUnit: farm.sizeUnit,
      farmType: farm.farmType,
      status: farm.status,
      crops: {
        total: farm.totalCrops,
        active: farm.activeCrops,
        harvested: farm.harvestedCrops,
      },
      livestock: {
        total: farm.totalLivestock,
        types: farm.livestockTypes,
      },
      productivity: {
        score: farm.productivityScore,
        trend: farm.productivityTrend,
        lastHarvest: farm.lastHarvestDate,
      },
      activities: {
        total: farm.totalActivities,
        recent: farm.recentActivities,
      },
      financial: {
        totalInvestment: farm.totalInvestment,
        estimatedValue: farm.estimatedValue,
        profitability: farm.profitabilityScore,
      },
      createdAt: farm.createdAt,
      updatedAt: farm.updatedAt,
    };
  }

  /**
   * Calculate summary statistics for farms
   */
  calculateSummary(farms) {
    if (farms.length === 0) {
      return {
        totalFarms: 0,
        totalSize: 0,
        averageSize: 0,
        farmTypes: {},
        totalCrops: 0,
        totalLivestock: 0,
        averageProductivity: 0,
      };
    }

    const totalSize = farms.reduce((sum, farm) => sum + farm.size, 0);
    const totalCrops = farms.reduce((sum, farm) => sum + farm.totalCrops, 0);
    const totalLivestock = farms.reduce((sum, farm) => sum + farm.totalLivestock, 0);
    const totalProductivity = farms.reduce((sum, farm) => sum + (farm.productivityScore || 0), 0);

    // Count farm types
    const farmTypes = farms.reduce((types, farm) => {
      types[farm.farmType] = (types[farm.farmType] || 0) + 1;
      return types;
    }, {});

    return {
      totalFarms: farms.length,
      totalSize,
      averageSize: totalSize / farms.length,
      farmTypes,
      totalCrops,
      totalLivestock,
      averageProductivity: totalProductivity / farms.length,
      mostProductiveFarm: farms.reduce((best, farm) => 
        (farm.productivityScore || 0) > (best.productivityScore || 0) ? farm : best
      ),
      newestFarm: farms.reduce((newest, farm) => 
        new Date(farm.createdAt) > new Date(newest.createdAt) ? farm : newest
      ),
    };
  }

  /**
   * Get supported query types
   */
  getSupportedQueries() {
    return [GetFarmsByFarmerQuery];
  }
}

module.exports = GetFarmsByFarmerQueryHandler;

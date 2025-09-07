const logger = require('../utils/logger');
const axios = require('axios');

/**
 * Event handlers for Farmer Context events
 * Handles cross-context integration when farmer-related events occur
 */
class FarmerEventHandlers {
  constructor(eventBus, config) {
    this.eventBus = eventBus;
    this.config = config;
    this.serviceUrls = {
      identityContext: config.IDENTITY_CONTEXT_URL || 'http://localhost:3100',
      marketplaceContext: config.MARKETPLACE_CONTEXT_URL || 'http://localhost:3500',
      serviceProviderContext: config.SERVICE_PROVIDER_CONTEXT_URL || 'http://localhost:3400',
      notificationService: config.NOTIFICATION_SERVICE_URL || 'http://localhost:3600',
    };
  }

  /**
   * Handle FarmCreated event
   * - Update farmer profile with farm information
   * - Create marketplace seller profile if first farm
   * - Send welcome notification
   */
  async handleFarmCreated(event) {
    try {
      logger.info(`Handling FarmCreated event: ${event.eventId}`);
      
      const { farmId, farmerId, farmName, county, farmType, size, sizeUnit } = event.eventData;

      // Update farmer profile with farm information
      await this.updateFarmerProfile(farmerId, {
        totalFarms: await this.getFarmerFarmCount(farmerId) + 1,
        primaryCounty: county,
        farmingExperience: 'active',
        lastFarmCreated: new Date().toISOString(),
      });

      // Check if this is farmer's first farm
      const isFirstFarm = await this.isFirstFarm(farmerId);
      
      if (isFirstFarm) {
        // Create marketplace seller profile
        await this.createMarketplaceSeller(farmerId, {
          sellerType: 'farmer',
          businessName: `${farmName} Farm`,
          location: { county },
          specializations: [farmType],
        });

        // Send welcome notification
        await this.sendWelcomeNotification(farmerId, farmName);
      }

      // Publish integration event for analytics
      await this.eventBus.publish('analytics-events', 'FarmAnalyticsUpdate', {
        farmerId,
        farmId,
        county,
        farmType,
        size,
        sizeUnit,
        action: 'farm_created',
      }, {
        correlationId: event.metadata.correlationId,
        source: 'farmer-event-handler',
      });

      logger.info(`Successfully handled FarmCreated event: ${event.eventId}`);

    } catch (error) {
      logger.error(`Error handling FarmCreated event ${event.eventId}:`, error);
      throw error;
    }
  }

  /**
   * Handle CropPlanted event
   * - Update farm productivity metrics
   * - Create potential marketplace listings
   * - Suggest relevant services
   */
  async handleCropPlanted(event) {
    try {
      logger.info(`Handling CropPlanted event: ${event.eventId}`);
      
      const { farmId, cropId, cropType, variety, area, expectedHarvestDate } = event.eventData;

      // Update farm productivity metrics
      await this.updateFarmMetrics(farmId, {
        totalCropsPlanted: await this.getFarmCropCount(farmId) + 1,
        totalAreaUnderCultivation: await this.getFarmTotalArea(farmId) + area,
        lastPlantingDate: new Date().toISOString(),
      });

      // Create potential marketplace listing for future harvest
      if (expectedHarvestDate) {
        await this.createPotentialListing(farmId, {
          cropType,
          variety,
          estimatedQuantity: this.estimateYield(cropType, area),
          expectedAvailabilityDate: expectedHarvestDate,
          status: 'planned',
        });
      }

      // Suggest relevant veterinary/agronomist services
      await this.suggestRelevantServices(farmId, cropType, {
        serviceTypes: ['crop_consultation', 'pest_management', 'soil_testing'],
        urgency: 'low',
        schedulingWindow: '30_days',
      });

      // Publish analytics event
      await this.eventBus.publish('analytics-events', 'CropAnalyticsUpdate', {
        farmId,
        cropId,
        cropType,
        variety,
        area,
        expectedHarvestDate,
        action: 'crop_planted',
      }, {
        correlationId: event.metadata.correlationId,
        source: 'farmer-event-handler',
      });

      logger.info(`Successfully handled CropPlanted event: ${event.eventId}`);

    } catch (error) {
      logger.error(`Error handling CropPlanted event ${event.eventId}:`, error);
      throw error;
    }
  }

  /**
   * Handle HarvestRecorded event
   * - Create marketplace listings for harvested produce
   * - Update farm productivity metrics
   * - Trigger payment calculations
   */
  async handleHarvestRecorded(event) {
    try {
      logger.info(`Handling HarvestRecorded event: ${event.eventId}`);
      
      const { farmId, cropId, harvestId, quantity, unit, harvestDate, quality } = event.eventData;

      // Get crop details
      const cropDetails = await this.getCropDetails(farmId, cropId);
      
      // Create marketplace listing for harvested produce
      await this.createMarketplaceListing(farmId, {
        productName: `Fresh ${cropDetails.cropType} - ${cropDetails.variety}`,
        category: 'produce',
        subcategory: cropDetails.cropType,
        quantity,
        unit,
        quality: quality || 'A',
        harvestDate,
        location: await this.getFarmLocation(farmId),
        availability: 'immediate',
        priceRange: await this.getSuggestedPriceRange(cropDetails.cropType, quality),
      });

      // Update farm productivity metrics
      await this.updateFarmMetrics(farmId, {
        totalHarvests: await this.getFarmHarvestCount(farmId) + 1,
        totalProduction: await this.getFarmTotalProduction(farmId) + quantity,
        lastHarvestDate: harvestDate,
        productivityScore: await this.calculateProductivityScore(farmId),
      });

      // Calculate potential earnings
      const estimatedValue = await this.calculateHarvestValue(cropDetails.cropType, quantity, quality);
      
      // Publish financial event
      await this.eventBus.publish('financial-events', 'HarvestValueCalculated', {
        farmId,
        harvestId,
        cropType: cropDetails.cropType,
        quantity,
        unit,
        estimatedValue,
        currency: 'KES',
      }, {
        correlationId: event.metadata.correlationId,
        source: 'farmer-event-handler',
      });

      logger.info(`Successfully handled HarvestRecorded event: ${event.eventId}`);

    } catch (error) {
      logger.error(`Error handling HarvestRecorded event ${event.eventId}:`, error);
      throw error;
    }
  }

  /**
   * Handle LivestockAdded event
   * - Update farm livestock metrics
   * - Suggest veterinary services
   * - Create potential marketplace listings
   */
  async handleLivestockAdded(event) {
    try {
      logger.info(`Handling LivestockAdded event: ${event.eventId}`);
      
      const { farmId, livestockId, animalType, breed, count, acquisitionDate } = event.eventData;

      // Update farm livestock metrics
      await this.updateFarmMetrics(farmId, {
        totalLivestock: await this.getFarmLivestockCount(farmId) + count,
        livestockTypes: await this.getFarmLivestockTypes(farmId),
        lastLivestockAddition: acquisitionDate,
      });

      // Suggest veterinary services
      await this.suggestRelevantServices(farmId, animalType, {
        serviceTypes: ['veterinary_checkup', 'vaccination', 'breeding_consultation'],
        urgency: 'medium',
        schedulingWindow: '14_days',
        animalType,
        animalCount: count,
      });

      // Create potential marketplace listings for livestock products
      const potentialProducts = this.getLivestockProducts(animalType);
      for (const product of potentialProducts) {
        await this.createPotentialListing(farmId, {
          productType: product.type,
          category: 'livestock_products',
          estimatedQuantity: product.estimatedQuantity * count,
          unit: product.unit,
          productionCycle: product.cycle,
          status: 'planned',
        });
      }

      // Publish analytics event
      await this.eventBus.publish('analytics-events', 'LivestockAnalyticsUpdate', {
        farmId,
        livestockId,
        animalType,
        breed,
        count,
        acquisitionDate,
        action: 'livestock_added',
      }, {
        correlationId: event.metadata.correlationId,
        source: 'farmer-event-handler',
      });

      logger.info(`Successfully handled LivestockAdded event: ${event.eventId}`);

    } catch (error) {
      logger.error(`Error handling LivestockAdded event ${event.eventId}:`, error);
      throw error;
    }
  }

  // Helper methods
  async updateFarmerProfile(farmerId, updates) {
    try {
      await axios.put(`${this.serviceUrls.identityContext}/farmers/${farmerId}/profile`, updates);
    } catch (error) {
      logger.error(`Error updating farmer profile ${farmerId}:`, error);
    }
  }

  async createMarketplaceSeller(farmerId, sellerData) {
    try {
      await axios.post(`${this.serviceUrls.marketplaceContext}/sellers`, {
        userId: farmerId,
        ...sellerData,
      });
    } catch (error) {
      logger.error(`Error creating marketplace seller for farmer ${farmerId}:`, error);
    }
  }

  async createMarketplaceListing(farmId, listingData) {
    try {
      await axios.post(`${this.serviceUrls.marketplaceContext}/products`, {
        farmId,
        ...listingData,
      });
    } catch (error) {
      logger.error(`Error creating marketplace listing for farm ${farmId}:`, error);
    }
  }

  async suggestRelevantServices(farmId, context, serviceOptions) {
    try {
      await axios.post(`${this.serviceUrls.serviceProviderContext}/suggestions`, {
        farmId,
        context,
        ...serviceOptions,
      });
    } catch (error) {
      logger.error(`Error suggesting services for farm ${farmId}:`, error);
    }
  }

  async sendWelcomeNotification(farmerId, farmName) {
    try {
      await axios.post(`${this.serviceUrls.notificationService}/send`, {
        userId: farmerId,
        type: 'welcome',
        title: 'Welcome to KaziApp!',
        message: `Congratulations on creating your farm "${farmName}"! You can now start managing your agricultural activities and connect with buyers and service providers.`,
        priority: 'normal',
      });
    } catch (error) {
      logger.error(`Error sending welcome notification to farmer ${farmerId}:`, error);
    }
  }

  // Mock helper methods (would integrate with actual services)
  async getFarmerFarmCount(farmerId) { return 0; }
  async isFirstFarm(farmerId) { return true; }
  async getFarmCropCount(farmId) { return 0; }
  async getFarmTotalArea(farmId) { return 0; }
  async getFarmHarvestCount(farmId) { return 0; }
  async getFarmTotalProduction(farmId) { return 0; }
  async getFarmLivestockCount(farmId) { return 0; }
  async getFarmLivestockTypes(farmId) { return []; }
  async getCropDetails(farmId, cropId) { return { cropType: 'maize', variety: 'hybrid' }; }
  async getFarmLocation(farmId) { return { county: 'Nairobi', coordinates: null }; }
  async calculateProductivityScore(farmId) { return 75; }
  async calculateHarvestValue(cropType, quantity, quality) { return quantity * 50; }
  async getSuggestedPriceRange(cropType, quality) { return { min: 40, max: 60 }; }
  
  estimateYield(cropType, area) {
    const yieldRates = { maize: 25, beans: 15, tomatoes: 40, cabbage: 30 };
    return (yieldRates[cropType] || 20) * area;
  }

  getLivestockProducts(animalType) {
    const products = {
      cattle: [
        { type: 'milk', estimatedQuantity: 15, unit: 'liters', cycle: 'daily' },
        { type: 'beef', estimatedQuantity: 300, unit: 'kg', cycle: 'yearly' },
      ],
      chicken: [
        { type: 'eggs', estimatedQuantity: 0.8, unit: 'pieces', cycle: 'daily' },
        { type: 'meat', estimatedQuantity: 2, unit: 'kg', cycle: 'quarterly' },
      ],
      goats: [
        { type: 'milk', estimatedQuantity: 2, unit: 'liters', cycle: 'daily' },
        { type: 'meat', estimatedQuantity: 25, unit: 'kg', cycle: 'yearly' },
      ],
    };
    return products[animalType] || [];
  }

  async updateFarmMetrics(farmId, metrics) {
    // Would update farm metrics in database
    logger.debug(`Updating farm ${farmId} metrics:`, metrics);
  }

  async createPotentialListing(farmId, listingData) {
    // Would create potential listing for future products
    logger.debug(`Creating potential listing for farm ${farmId}:`, listingData);
  }
}

module.exports = FarmerEventHandlers;

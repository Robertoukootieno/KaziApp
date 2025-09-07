const { v4: uuidv4 } = require('uuid');
const AggregateRoot = require('../base/AggregateRoot');
const FarmCreatedEvent = require('../events/FarmCreatedEvent');
const CropPlantedEvent = require('../events/CropPlantedEvent');
const HarvestRecordedEvent = require('../events/HarvestRecordedEvent');
const LivestockAddedEvent = require('../events/LivestockAddedEvent');
const FarmActivityRecordedEvent = require('../events/FarmActivityRecordedEvent');

/**
 * Farm Aggregate - Core domain entity for farm management
 * Encapsulates all business logic related to farm operations
 */
class Farm extends AggregateRoot {
  constructor(id) {
    super(id);
    this.farmerId = null;
    this.name = null;
    this.location = null;
    this.size = 0;
    this.sizeUnit = 'acres';
    this.farmType = null; // 'crop', 'livestock', 'mixed'
    this.status = 'active';
    this.crops = new Map(); // cropId -> CropInfo
    this.livestock = new Map(); // livestockId -> LivestockInfo
    this.activities = [];
    this.createdAt = null;
    this.updatedAt = null;
  }

  /**
   * Create a new farm
   */
  static create(farmerId, name, location, size, sizeUnit, farmType, metadata = {}) {
    const farmId = uuidv4();
    const farm = new Farm(farmId);
    
    // Validate business rules
    farm.validateFarmCreation(farmerId, name, location, size, sizeUnit, farmType);
    
    // Apply domain event
    const event = new FarmCreatedEvent({
      farmId,
      farmerId,
      name,
      location,
      size,
      sizeUnit,
      farmType,
      createdAt: new Date().toISOString(),
    }, metadata);
    
    farm.applyEvent(event);
    return farm;
  }

  /**
   * Plant a crop on the farm
   */
  plantCrop(cropType, variety, area, plantingDate, expectedHarvestDate, metadata = {}) {
    // Validate business rules
    this.validateCropPlanting(cropType, area);
    
    const cropId = uuidv4();
    const event = new CropPlantedEvent({
      farmId: this.id,
      cropId,
      cropType,
      variety,
      area,
      plantingDate,
      expectedHarvestDate,
      status: 'planted',
    }, metadata);
    
    this.applyEvent(event);
    return cropId;
  }

  /**
   * Record harvest for a crop
   */
  recordHarvest(cropId, quantity, unit, harvestDate, quality, metadata = {}) {
    // Validate business rules
    this.validateHarvest(cropId, quantity);
    
    const harvestId = uuidv4();
    const event = new HarvestRecordedEvent({
      farmId: this.id,
      cropId,
      harvestId,
      quantity,
      unit,
      harvestDate,
      quality,
    }, metadata);
    
    this.applyEvent(event);
    return harvestId;
  }

  /**
   * Add livestock to the farm
   */
  addLivestock(animalType, breed, count, acquisitionDate, metadata = {}) {
    // Validate business rules
    this.validateLivestockAddition(animalType, count);
    
    const livestockId = uuidv4();
    const event = new LivestockAddedEvent({
      farmId: this.id,
      livestockId,
      animalType,
      breed,
      count,
      acquisitionDate,
      status: 'healthy',
    }, metadata);
    
    this.applyEvent(event);
    return livestockId;
  }

  /**
   * Record farm activity
   */
  recordActivity(activityType, description, date, cost, metadata = {}) {
    const activityId = uuidv4();
    const event = new FarmActivityRecordedEvent({
      farmId: this.id,
      activityId,
      activityType,
      description,
      date,
      cost,
    }, metadata);
    
    this.applyEvent(event);
    return activityId;
  }

  /**
   * Calculate total farm productivity
   */
  calculateProductivity() {
    let totalProduction = 0;
    let totalArea = 0;
    
    for (const [cropId, crop] of this.crops) {
      if (crop.harvests && crop.harvests.length > 0) {
        const totalHarvest = crop.harvests.reduce((sum, h) => sum + h.quantity, 0);
        totalProduction += totalHarvest;
        totalArea += crop.area;
      }
    }
    
    return totalArea > 0 ? totalProduction / totalArea : 0;
  }

  /**
   * Get farm summary
   */
  getSummary() {
    return {
      id: this.id,
      farmerId: this.farmerId,
      name: this.name,
      location: this.location,
      size: this.size,
      sizeUnit: this.sizeUnit,
      farmType: this.farmType,
      status: this.status,
      totalCrops: this.crops.size,
      totalLivestock: Array.from(this.livestock.values())
        .reduce((sum, l) => sum + l.count, 0),
      totalActivities: this.activities.length,
      productivity: this.calculateProductivity(),
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
    };
  }

  // Event Handlers
  onFarmCreated(event) {
    this.farmerId = event.eventData.farmerId;
    this.name = event.eventData.name;
    this.location = event.eventData.location;
    this.size = event.eventData.size;
    this.sizeUnit = event.eventData.sizeUnit;
    this.farmType = event.eventData.farmType;
    this.status = 'active';
    this.createdAt = event.eventData.createdAt;
    this.updatedAt = event.eventData.createdAt;
  }

  onCropPlanted(event) {
    const cropData = event.eventData;
    this.crops.set(cropData.cropId, {
      id: cropData.cropId,
      cropType: cropData.cropType,
      variety: cropData.variety,
      area: cropData.area,
      plantingDate: cropData.plantingDate,
      expectedHarvestDate: cropData.expectedHarvestDate,
      status: cropData.status,
      harvests: [],
    });
    this.updatedAt = new Date().toISOString();
  }

  onHarvestRecorded(event) {
    const harvestData = event.eventData;
    const crop = this.crops.get(harvestData.cropId);
    if (crop) {
      crop.harvests.push({
        id: harvestData.harvestId,
        quantity: harvestData.quantity,
        unit: harvestData.unit,
        harvestDate: harvestData.harvestDate,
        quality: harvestData.quality,
      });
      crop.status = 'harvested';
    }
    this.updatedAt = new Date().toISOString();
  }

  onLivestockAdded(event) {
    const livestockData = event.eventData;
    this.livestock.set(livestockData.livestockId, {
      id: livestockData.livestockId,
      animalType: livestockData.animalType,
      breed: livestockData.breed,
      count: livestockData.count,
      acquisitionDate: livestockData.acquisitionDate,
      status: livestockData.status,
    });
    this.updatedAt = new Date().toISOString();
  }

  onFarmActivityRecorded(event) {
    const activityData = event.eventData;
    this.activities.push({
      id: activityData.activityId,
      type: activityData.activityType,
      description: activityData.description,
      date: activityData.date,
      cost: activityData.cost,
    });
    this.updatedAt = new Date().toISOString();
  }

  // Business Rule Validations
  validateFarmCreation(farmerId, name, location, size, sizeUnit, farmType) {
    if (!farmerId) throw new Error('Farmer ID is required');
    if (!name || name.trim().length < 2) throw new Error('Farm name must be at least 2 characters');
    if (!location || !location.county) throw new Error('Farm location with county is required');
    if (size <= 0) throw new Error('Farm size must be greater than 0');
    if (!['acres', 'hectares'].includes(sizeUnit)) throw new Error('Size unit must be acres or hectares');
    if (!['crop', 'livestock', 'mixed'].includes(farmType)) throw new Error('Invalid farm type');
  }

  validateCropPlanting(cropType, area) {
    if (!cropType) throw new Error('Crop type is required');
    if (area <= 0) throw new Error('Planting area must be greater than 0');
    if (area > this.size) throw new Error('Planting area cannot exceed farm size');
    
    // Check if farm supports crops
    if (this.farmType === 'livestock') {
      throw new Error('Cannot plant crops on livestock-only farm');
    }
  }

  validateHarvest(cropId, quantity) {
    if (!this.crops.has(cropId)) throw new Error('Crop not found on this farm');
    if (quantity <= 0) throw new Error('Harvest quantity must be greater than 0');
    
    const crop = this.crops.get(cropId);
    if (crop.status === 'harvested') {
      throw new Error('Crop has already been harvested');
    }
  }

  validateLivestockAddition(animalType, count) {
    if (!animalType) throw new Error('Animal type is required');
    if (count <= 0) throw new Error('Livestock count must be greater than 0');
    
    // Check if farm supports livestock
    if (this.farmType === 'crop') {
      throw new Error('Cannot add livestock to crop-only farm');
    }
  }
}

module.exports = Farm;

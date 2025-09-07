const CommandHandler = require('../base/CommandHandler');
const Farm = require('../../domain/aggregates/Farm');
const CreateFarmCommand = require('../commands/CreateFarmCommand');

/**
 * Command handler for creating farms
 * Implements the command side of CQRS pattern
 */
class CreateFarmCommandHandler extends CommandHandler {
  constructor(farmRepository, eventBus, logger) {
    super();
    this.farmRepository = farmRepository;
    this.eventBus = eventBus;
    this.logger = logger;
  }

  /**
   * Handle the CreateFarmCommand
   */
  async handle(command) {
    try {
      // Validate command type
      if (!(command instanceof CreateFarmCommand)) {
        throw new Error('Invalid command type for CreateFarmCommandHandler');
      }

      this.logger.info(`Handling CreateFarmCommand: ${command.getSummary()}`);

      // Extract command data
      const {
        farmerId,
        name,
        location,
        size,
        sizeUnit,
        farmType,
      } = command.data;

      // Business rule: Check if farmer already has a farm with the same name
      const existingFarms = await this.farmRepository.findByFarmerId(farmerId);
      const duplicateName = existingFarms.find(farm => 
        farm.name.toLowerCase() === name.toLowerCase()
      );
      
      if (duplicateName) {
        throw new Error(`Farmer already has a farm named "${name}"`);
      }

      // Business rule: Validate location (could integrate with external service)
      await this.validateLocation(location);

      // Create the farm aggregate
      const farm = Farm.create(
        farmerId,
        name,
        location,
        size,
        sizeUnit,
        farmType,
        {
          correlationId: command.metadata.correlationId,
          causationId: command.commandId,
          userId: command.metadata.userId,
          source: 'CreateFarmCommandHandler',
        }
      );

      // Save the farm (this will persist events)
      await this.farmRepository.save(farm);

      // Publish integration events
      const events = farm.getUncommittedEvents();
      for (const event of events) {
        if (event.eventType === 'FarmCreated') {
          // Mark as integration event for cross-context communication
          event.markAsIntegrationEvent();
          
          await this.eventBus.publish(
            'farmer-events',
            event.eventType,
            event.getIntegrationEventData(),
            {
              correlationId: event.metadata.correlationId,
              causationId: event.metadata.causationId,
              source: 'farmer-context',
              aggregateId: event.aggregateId,
              aggregateType: event.aggregateType,
            }
          );
        }
      }

      this.logger.info(`Farm created successfully: ${farm.id}`);

      return {
        success: true,
        farmId: farm.id,
        version: farm.version,
        message: 'Farm created successfully',
      };

    } catch (error) {
      this.logger.error(`Error handling CreateFarmCommand:`, error);
      
      return {
        success: false,
        error: error.message,
        commandId: command.commandId,
      };
    }
  }

  /**
   * Validate farm location
   */
  async validateLocation(location) {
    // Business rule: Validate county exists in Kenya
    const validCounties = [
      'Nairobi', 'Mombasa', 'Kwale', 'Kilifi', 'Tana River', 'Lamu', 'Taita Taveta',
      'Garissa', 'Wajir', 'Mandera', 'Marsabit', 'Isiolo', 'Meru', 'Tharaka Nithi',
      'Embu', 'Kitui', 'Machakos', 'Makueni', 'Nyandarua', 'Nyeri', 'Kirinyaga',
      'Murang\'a', 'Kiambu', 'Turkana', 'West Pokot', 'Samburu', 'Trans Nzoia',
      'Uasin Gishu', 'Elgeyo Marakwet', 'Nandi', 'Baringo', 'Laikipia', 'Nakuru',
      'Narok', 'Kajiado', 'Kericho', 'Bomet', 'Kakamega', 'Vihiga', 'Bungoma',
      'Busia', 'Siaya', 'Kisumu', 'Homa Bay', 'Migori', 'Kisii', 'Nyamira'
    ];

    if (!validCounties.includes(location.county)) {
      throw new Error(`Invalid county: ${location.county}. Must be a valid Kenyan county.`);
    }

    // Additional validation could include:
    // - Coordinate validation
    // - Sub-county validation
    // - Ward validation
    // - Integration with external mapping services
  }

  /**
   * Get supported command types
   */
  getSupportedCommands() {
    return [CreateFarmCommand];
  }
}

module.exports = CreateFarmCommandHandler;

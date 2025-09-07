const { v4: uuidv4 } = require('uuid');
const logger = require('../utils/logger');

/**
 * Saga Orchestrator - Manages distributed transactions across bounded contexts
 * Implements the Saga pattern for maintaining data consistency
 */
class SagaOrchestrator {
  constructor(eventBus, redisClient) {
    this.eventBus = eventBus;
    this.redis = redisClient;
    this.sagas = new Map();
    this.sagaDefinitions = new Map();
    this.isRunning = false;
  }

  /**
   * Initialize the saga orchestrator
   */
  async initialize() {
    try {
      // Register built-in saga definitions
      this.registerBuiltInSagas();
      
      // Subscribe to saga events
      await this.subscribeToSagaEvents();
      
      this.isRunning = true;
      logger.info('Saga orchestrator initialized successfully');
    } catch (error) {
      logger.error('Failed to initialize saga orchestrator:', error);
      throw error;
    }
  }

  /**
   * Register a saga definition
   */
  registerSaga(sagaType, sagaDefinition) {
    this.sagaDefinitions.set(sagaType, sagaDefinition);
    logger.info(`Registered saga definition: ${sagaType}`);
  }

  /**
   * Start a new saga
   */
  async startSaga(sagaType, sagaData, metadata = {}) {
    try {
      const sagaDefinition = this.sagaDefinitions.get(sagaType);
      if (!sagaDefinition) {
        throw new Error(`Saga definition not found: ${sagaType}`);
      }

      const sagaId = uuidv4();
      const saga = {
        id: sagaId,
        type: sagaType,
        status: 'started',
        currentStep: 0,
        data: sagaData,
        metadata: {
          ...metadata,
          correlationId: metadata.correlationId || uuidv4(),
          startedAt: new Date().toISOString(),
        },
        steps: sagaDefinition.steps,
        completedSteps: [],
        failedSteps: [],
        compensationSteps: [],
      };

      // Store saga state
      await this.storeSagaState(saga);
      
      // Add to active sagas
      this.sagas.set(sagaId, saga);

      // Execute first step
      await this.executeNextStep(saga);

      logger.info(`Started saga ${sagaType} with ID: ${sagaId}`);
      return sagaId;

    } catch (error) {
      logger.error(`Error starting saga ${sagaType}:`, error);
      throw error;
    }
  }

  /**
   * Handle saga event
   */
  async handleSagaEvent(event) {
    try {
      const sagaId = event.metadata.sagaId;
      if (!sagaId) {
        return; // Not a saga event
      }

      const saga = await this.getSaga(sagaId);
      if (!saga) {
        logger.warn(`Saga not found: ${sagaId}`);
        return;
      }

      // Process the event based on saga state
      await this.processSagaEvent(saga, event);

    } catch (error) {
      logger.error('Error handling saga event:', error);
    }
  }

  /**
   * Process saga event
   */
  async processSagaEvent(saga, event) {
    const currentStep = saga.steps[saga.currentStep];
    
    if (!currentStep) {
      logger.warn(`No current step for saga ${saga.id}`);
      return;
    }

    // Check if this event completes the current step
    if (this.isStepCompletionEvent(currentStep, event)) {
      await this.completeStep(saga, event);
    } else if (this.isStepFailureEvent(currentStep, event)) {
      await this.failStep(saga, event);
    }
  }

  /**
   * Complete a saga step
   */
  async completeStep(saga, event) {
    const currentStep = saga.steps[saga.currentStep];
    
    // Mark step as completed
    saga.completedSteps.push({
      stepIndex: saga.currentStep,
      stepName: currentStep.name,
      completedAt: new Date().toISOString(),
      event: event.eventType,
    });

    // Move to next step
    saga.currentStep++;

    // Check if saga is complete
    if (saga.currentStep >= saga.steps.length) {
      await this.completeSaga(saga);
    } else {
      // Execute next step
      await this.executeNextStep(saga);
    }

    // Update saga state
    await this.storeSagaState(saga);
  }

  /**
   * Fail a saga step
   */
  async failStep(saga, event) {
    const currentStep = saga.steps[saga.currentStep];
    
    // Mark step as failed
    saga.failedSteps.push({
      stepIndex: saga.currentStep,
      stepName: currentStep.name,
      failedAt: new Date().toISOString(),
      event: event.eventType,
      error: event.eventData.error,
    });

    // Start compensation
    await this.startCompensation(saga);
  }

  /**
   * Execute next step in saga
   */
  async executeNextStep(saga) {
    const step = saga.steps[saga.currentStep];
    if (!step) {
      return;
    }

    try {
      // Prepare command data
      const commandData = this.prepareCommandData(saga, step);
      
      // Send command to appropriate service
      await this.sendCommand(step.service, step.command, commandData, {
        sagaId: saga.id,
        correlationId: saga.metadata.correlationId,
        stepIndex: saga.currentStep,
      });

      logger.info(`Executed step ${saga.currentStep} (${step.name}) for saga ${saga.id}`);

    } catch (error) {
      logger.error(`Error executing step ${saga.currentStep} for saga ${saga.id}:`, error);
      await this.failStep(saga, {
        eventType: 'StepExecutionFailed',
        eventData: { error: error.message },
      });
    }
  }

  /**
   * Start compensation (rollback)
   */
  async startCompensation(saga) {
    saga.status = 'compensating';
    
    // Execute compensation steps in reverse order
    for (let i = saga.completedSteps.length - 1; i >= 0; i--) {
      const completedStep = saga.completedSteps[i];
      const stepDefinition = saga.steps[completedStep.stepIndex];
      
      if (stepDefinition.compensation) {
        await this.executeCompensationStep(saga, stepDefinition, completedStep);
      }
    }

    await this.failSaga(saga);
  }

  /**
   * Execute compensation step
   */
  async executeCompensationStep(saga, stepDefinition, completedStep) {
    try {
      const compensationData = this.prepareCompensationData(saga, stepDefinition, completedStep);
      
      await this.sendCommand(
        stepDefinition.compensation.service,
        stepDefinition.compensation.command,
        compensationData,
        {
          sagaId: saga.id,
          correlationId: saga.metadata.correlationId,
          compensationFor: completedStep.stepIndex,
        }
      );

      saga.compensationSteps.push({
        originalStep: completedStep.stepIndex,
        compensatedAt: new Date().toISOString(),
      });

      logger.info(`Executed compensation for step ${completedStep.stepIndex} in saga ${saga.id}`);

    } catch (error) {
      logger.error(`Error executing compensation for step ${completedStep.stepIndex}:`, error);
    }
  }

  /**
   * Complete saga successfully
   */
  async completeSaga(saga) {
    saga.status = 'completed';
    saga.metadata.completedAt = new Date().toISOString();
    
    await this.storeSagaState(saga);
    this.sagas.delete(saga.id);
    
    logger.info(`Saga ${saga.id} completed successfully`);
  }

  /**
   * Fail saga
   */
  async failSaga(saga) {
    saga.status = 'failed';
    saga.metadata.failedAt = new Date().toISOString();
    
    await this.storeSagaState(saga);
    this.sagas.delete(saga.id);
    
    logger.error(`Saga ${saga.id} failed`);
  }

  /**
   * Send command to service
   */
  async sendCommand(service, command, data, metadata) {
    await this.eventBus.publish(
      `${service}-commands`,
      command,
      data,
      metadata
    );
  }

  /**
   * Prepare command data for step
   */
  prepareCommandData(saga, step) {
    // Use step's data preparation function if available
    if (step.prepareData) {
      return step.prepareData(saga.data, saga);
    }
    
    // Default: use saga data
    return saga.data;
  }

  /**
   * Prepare compensation data
   */
  prepareCompensationData(saga, stepDefinition, completedStep) {
    if (stepDefinition.compensation.prepareData) {
      return stepDefinition.compensation.prepareData(saga.data, completedStep);
    }
    
    return saga.data;
  }

  /**
   * Check if event completes current step
   */
  isStepCompletionEvent(step, event) {
    return step.completionEvents && step.completionEvents.includes(event.eventType);
  }

  /**
   * Check if event indicates step failure
   */
  isStepFailureEvent(step, event) {
    return step.failureEvents && step.failureEvents.includes(event.eventType);
  }

  /**
   * Store saga state in Redis
   */
  async storeSagaState(saga) {
    const key = `saga:${saga.id}`;
    await this.redis.setex(key, 86400, JSON.stringify(saga)); // 24 hours TTL
  }

  /**
   * Get saga from storage
   */
  async getSaga(sagaId) {
    // Check memory first
    if (this.sagas.has(sagaId)) {
      return this.sagas.get(sagaId);
    }
    
    // Check Redis
    const key = `saga:${sagaId}`;
    const sagaData = await this.redis.get(key);
    
    if (sagaData) {
      const saga = JSON.parse(sagaData);
      this.sagas.set(sagaId, saga);
      return saga;
    }
    
    return null;
  }

  /**
   * Subscribe to saga events
   */
  async subscribeToSagaEvents() {
    // Subscribe to all domain events that might affect sagas
    const streams = [
      'farmer-events',
      'service-provider-events',
      'marketplace-events',
      'payment-events',
      'identity-events',
    ];

    for (const stream of streams) {
      await this.eventBus.subscribe(
        stream,
        'saga-orchestrator',
        'saga-handler',
        (event) => this.handleSagaEvent(event)
      );
    }
  }

  /**
   * Register built-in saga definitions
   */
  registerBuiltInSagas() {
    // Order Processing Saga
    this.registerSaga('order-processing', {
      name: 'Order Processing Saga',
      description: 'Handles order placement, payment, and fulfillment',
      steps: [
        {
          name: 'Reserve Stock',
          service: 'marketplace-context',
          command: 'ReserveStock',
          completionEvents: ['StockReserved'],
          failureEvents: ['StockReservationFailed'],
          compensation: {
            service: 'marketplace-context',
            command: 'ReleaseStock',
          },
        },
        {
          name: 'Process Payment',
          service: 'payment-context',
          command: 'ProcessPayment',
          completionEvents: ['PaymentProcessed'],
          failureEvents: ['PaymentFailed'],
          compensation: {
            service: 'payment-context',
            command: 'RefundPayment',
          },
        },
        {
          name: 'Confirm Order',
          service: 'marketplace-context',
          command: 'ConfirmOrder',
          completionEvents: ['OrderConfirmed'],
          failureEvents: ['OrderConfirmationFailed'],
        },
      ],
    });

    // Service Appointment Saga
    this.registerSaga('service-appointment', {
      name: 'Service Appointment Saga',
      description: 'Handles service appointment booking and payment',
      steps: [
        {
          name: 'Reserve Appointment Slot',
          service: 'service-provider-context',
          command: 'ReserveAppointmentSlot',
          completionEvents: ['AppointmentSlotReserved'],
          failureEvents: ['AppointmentSlotReservationFailed'],
          compensation: {
            service: 'service-provider-context',
            command: 'ReleaseAppointmentSlot',
          },
        },
        {
          name: 'Process Service Payment',
          service: 'payment-context',
          command: 'ProcessPayment',
          completionEvents: ['PaymentProcessed'],
          failureEvents: ['PaymentFailed'],
          compensation: {
            service: 'payment-context',
            command: 'RefundPayment',
          },
        },
        {
          name: 'Confirm Appointment',
          service: 'service-provider-context',
          command: 'ConfirmAppointment',
          completionEvents: ['AppointmentConfirmed'],
          failureEvents: ['AppointmentConfirmationFailed'],
        },
      ],
    });
  }

  /**
   * Get saga statistics
   */
  async getStats() {
    const activeSagas = this.sagas.size;
    const sagaTypes = Array.from(this.sagaDefinitions.keys());
    
    return {
      activeSagas,
      registeredSagaTypes: sagaTypes.length,
      sagaTypes,
      isRunning: this.isRunning,
    };
  }

  /**
   * Shutdown the orchestrator
   */
  async shutdown() {
    this.isRunning = false;
    this.sagas.clear();
    logger.info('Saga orchestrator shutdown complete');
  }
}

module.exports = SagaOrchestrator;

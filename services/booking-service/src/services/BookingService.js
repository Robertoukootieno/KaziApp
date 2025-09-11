const { v4: uuidv4 } = require('uuid');
const logger = require('../utils/logger');
const Booking = require('../models/Booking');

/**
 * Core Booking Service - Handles job/service lifecycle
 * Implements sequences A1, A2, A3 from the requirements
 */
class BookingService {
  constructor(redisClient, eventBusClient, socketIO) {
    this.redis = redisClient;
    this.eventBus = eventBusClient;
    this.io = socketIO;
    this.isInitialized = false;
  }

  async initialize() {
    try {
      // Subscribe to relevant events
      await this.eventBus.subscribe('payment-events', this.handlePaymentEvents.bind(this));
      await this.eventBus.subscribe('provider-events', this.handleProviderEvents.bind(this));
      await this.eventBus.subscribe('matching-events', this.handleMatchingEvents.bind(this));
      
      this.isInitialized = true;
      logger.info('BookingService initialized successfully');
    } catch (error) {
      logger.error('Failed to initialize BookingService:', error);
      throw error;
    }
  }

  /**
   * A1 - Farmer Requests a Service
   * Creates new booking request and triggers matchmaking
   */
  async createBooking(bookingData, farmerId) {
    try {
      const bookingId = `BK_${Date.now()}_${uuidv4().substring(0, 8)}`;
      
      // Create booking record
      const booking = new Booking({
        bookingId,
        farmerId,
        farmerName: bookingData.farmerName,
        farmerPhone: bookingData.farmerPhone,
        farmerEmail: bookingData.farmerEmail,
        title: bookingData.title,
        description: bookingData.description,
        category: bookingData.category,
        requestedDate: new Date(bookingData.requestedDate),
        requestedTime: bookingData.requestedTime,
        estimatedDuration: bookingData.estimatedDuration,
        location: bookingData.location,
        items: bookingData.items || [],
        totalAmount: bookingData.totalAmount,
        notes: bookingData.notes,
        status: 'pending',
        paymentStatus: 'pending',
      });

      await booking.save();
      logger.info(`Booking created: ${bookingId} by farmer ${farmerId}`);

      // Publish JobCreated event for matchmaking
      await this.eventBus.publish('booking-events', {
        type: 'JobCreated',
        bookingId,
        farmerId,
        category: bookingData.category,
        location: bookingData.location,
        requestedDate: bookingData.requestedDate,
        totalAmount: bookingData.totalAmount,
        timestamp: new Date().toISOString(),
        metadata: {
          skills: bookingData.requiredSkills || [],
          urgency: bookingData.urgency || 'normal',
        },
      });

      // Notify farmer via socket
      this.io.to(`farmer_${farmerId}`).emit('booking-created', {
        bookingId,
        status: 'pending',
        message: 'Your service request has been created and we are finding providers for you.',
      });

      return {
        success: true,
        bookingId,
        booking: booking.toJSON(),
      };

    } catch (error) {
      logger.error('Error creating booking:', error);
      throw error;
    }
  }

  /**
   * Handle provider acceptance of booking
   */
  async acceptBooking(bookingId, providerId, providerData) {
    try {
      const booking = await Booking.findOne({ bookingId });
      
      if (!booking) {
        throw new Error('Booking not found');
      }

      if (booking.status !== 'matched') {
        throw new Error(`Cannot accept booking in status: ${booking.status}`);
      }

      // Update booking with provider acceptance
      booking.status = 'accepted';
      booking.providerId = providerId;
      booking.providerName = providerData.name;
      booking.providerPhone = providerData.phone;
      booking.providerEmail = providerData.email;
      booking.acceptedAt = new Date();

      await booking.save();

      logger.info(`Booking ${bookingId} accepted by provider ${providerId}`);

      // Create escrow hold via payment service
      await this.eventBus.publish('payment-events', {
        type: 'CreateEscrowHold',
        bookingId,
        farmerId: booking.farmerId,
        providerId,
        amount: booking.totalAmount,
        currency: booking.currency,
        description: `Escrow for booking ${bookingId}`,
        timestamp: new Date().toISOString(),
      });

      // Notify farmer
      this.io.to(`farmer_${booking.farmerId}`).emit('booking-accepted', {
        bookingId,
        provider: {
          id: providerId,
          name: providerData.name,
          phone: providerData.phone,
        },
        message: 'Your service request has been accepted! Payment processing...',
      });

      // Notify provider
      this.io.to(`provider_${providerId}`).emit('booking-accepted', {
        bookingId,
        message: 'You have successfully accepted the booking. Payment is being processed.',
      });

      return {
        success: true,
        booking: booking.toJSON(),
      };

    } catch (error) {
      logger.error('Error accepting booking:', error);
      throw error;
    }
  }

  /**
   * A2 - Provider Cancels Job
   */
  async cancelBookingByProvider(bookingId, providerId, reason) {
    try {
      const booking = await Booking.findOne({ bookingId, providerId });
      
      if (!booking) {
        throw new Error('Booking not found or not assigned to this provider');
      }

      if (!booking.canBeCancelled()) {
        throw new Error(`Cannot cancel booking in status: ${booking.status}`);
      }

      // Update booking status
      booking.status = 'cancelled_by_provider';
      booking.cancelledAt = new Date();
      booking.cancellationReason = reason;
      booking.cancelledBy = providerId;

      await booking.save();

      logger.info(`Booking ${bookingId} cancelled by provider ${providerId}: ${reason}`);

      // Publish JobCanceled event
      await this.eventBus.publish('booking-events', {
        type: 'JobCanceled',
        bookingId,
        cancelledBy: 'provider',
        providerId,
        reason,
        timestamp: new Date().toISOString(),
      });

      // Refund farmer's escrow if payment was made
      if (booking.escrowId) {
        await this.eventBus.publish('payment-events', {
          type: 'RefundEscrow',
          bookingId,
          escrowId: booking.escrowId,
          reason: 'Provider cancelled booking',
          timestamp: new Date().toISOString(),
        });
      }

      // Notify farmer with alternative provider suggestions
      this.io.to(`farmer_${booking.farmerId}`).emit('booking-cancelled', {
        bookingId,
        cancelledBy: 'provider',
        reason,
        message: 'The provider has cancelled your booking. We are finding alternative providers for you.',
      });

      // Trigger new matchmaking for alternative providers
      await this.eventBus.publish('matching-events', {
        type: 'FindAlternativeProviders',
        bookingId,
        originalProviderId: providerId,
        category: booking.category,
        location: booking.location,
        timestamp: new Date().toISOString(),
      });

      return {
        success: true,
        booking: booking.toJSON(),
      };

    } catch (error) {
      logger.error('Error cancelling booking by provider:', error);
      throw error;
    }
  }

  /**
   * A3 - Farmer Cancels Before Acceptance
   */
  async cancelBookingByFarmer(bookingId, farmerId, reason) {
    try {
      const booking = await Booking.findOne({ bookingId, farmerId });
      
      if (!booking) {
        throw new Error('Booking not found');
      }

      // Check if cancellation is allowed
      const allowedStatuses = ['pending', 'matched'];
      if (!allowedStatuses.includes(booking.status)) {
        throw new Error(`Cannot cancel booking in status: ${booking.status}`);
      }

      // Update booking status
      booking.status = 'cancelled_by_farmer';
      booking.cancelledAt = new Date();
      booking.cancellationReason = reason;
      booking.cancelledBy = farmerId;

      await booking.save();

      logger.info(`Booking ${bookingId} cancelled by farmer ${farmerId}: ${reason}`);

      // Release escrow if any
      if (booking.escrowId) {
        await this.eventBus.publish('payment-events', {
          type: 'ReleaseEscrow',
          bookingId,
          escrowId: booking.escrowId,
          reason: 'Farmer cancelled booking',
          timestamp: new Date().toISOString(),
        });
      }

      // Notify providers that offer is withdrawn
      await this.eventBus.publish('matching-events', {
        type: 'BookingWithdrawn',
        bookingId,
        farmerId,
        reason,
        timestamp: new Date().toISOString(),
      });

      // Notify farmer
      this.io.to(`farmer_${farmerId}`).emit('booking-cancelled', {
        bookingId,
        cancelledBy: 'farmer',
        reason,
        message: 'Your booking has been cancelled successfully.',
      });

      return {
        success: true,
        booking: booking.toJSON(),
      };

    } catch (error) {
      logger.error('Error cancelling booking by farmer:', error);
      throw error;
    }
  }

  /**
   * Mark job as completed by provider
   */
  async completeBooking(bookingId, providerId, completionData) {
    try {
      const booking = await Booking.findOne({ bookingId, providerId });
      
      if (!booking) {
        throw new Error('Booking not found or not assigned to this provider');
      }

      if (booking.status !== 'in_progress') {
        throw new Error(`Cannot complete booking in status: ${booking.status}`);
      }

      // Update booking status
      booking.status = 'completed';
      booking.completedAt = new Date();
      booking.providerNotes = completionData.notes;

      // Add completion attachments if any
      if (completionData.attachments) {
        booking.attachments.push(...completionData.attachments);
      }

      await booking.save();

      logger.info(`Booking ${bookingId} completed by provider ${providerId}`);

      // Publish JobCompleted event
      await this.eventBus.publish('booking-events', {
        type: 'JobCompleted',
        bookingId,
        providerId,
        farmerId: booking.farmerId,
        completedAt: booking.completedAt,
        timestamp: new Date().toISOString(),
      });

      // Trigger payment settlement
      await this.eventBus.publish('payment-events', {
        type: 'SettleEscrow',
        bookingId,
        escrowId: booking.escrowId,
        providerId,
        amount: booking.totalAmount,
        timestamp: new Date().toISOString(),
      });

      // Notify farmer
      this.io.to(`farmer_${booking.farmerId}`).emit('booking-completed', {
        bookingId,
        provider: {
          id: providerId,
          name: booking.providerName,
        },
        message: 'Your service has been completed! Please review and rate the provider.',
      });

      return {
        success: true,
        booking: booking.toJSON(),
      };

    } catch (error) {
      logger.error('Error completing booking:', error);
      throw error;
    }
  }

  /**
   * Handle payment events
   */
  async handlePaymentEvents(event) {
    try {
      const { type, bookingId } = event;

      switch (type) {
        case 'EscrowCreated':
          await this.handleEscrowCreated(event);
          break;
        case 'PaymentCompleted':
          await this.handlePaymentCompleted(event);
          break;
        case 'PaymentFailed':
          await this.handlePaymentFailed(event);
          break;
        case 'EscrowReleased':
          await this.handleEscrowReleased(event);
          break;
        default:
          logger.debug(`Unhandled payment event: ${type}`);
      }
    } catch (error) {
      logger.error('Error handling payment event:', error);
    }
  }

  /**
   * Handle provider events
   */
  async handleProviderEvents(event) {
    try {
      const { type } = event;

      switch (type) {
        case 'ProviderAccepted':
          await this.handleProviderAccepted(event);
          break;
        case 'ProviderRejected':
          await this.handleProviderRejected(event);
          break;
        default:
          logger.debug(`Unhandled provider event: ${type}`);
      }
    } catch (error) {
      logger.error('Error handling provider event:', error);
    }
  }

  /**
   * Handle matching events
   */
  async handleMatchingEvents(event) {
    try {
      const { type } = event;

      switch (type) {
        case 'ProvidersFound':
          await this.handleProvidersFound(event);
          break;
        case 'NoProvidersFound':
          await this.handleNoProvidersFound(event);
          break;
        default:
          logger.debug(`Unhandled matching event: ${type}`);
      }
    } catch (error) {
      logger.error('Error handling matching event:', error);
    }
  }

  async handleEscrowCreated(event) {
    const { bookingId, escrowId } = event;

    const booking = await Booking.findOne({ bookingId });
    if (booking) {
      booking.escrowId = escrowId;
      booking.status = 'confirmed';
      booking.confirmedAt = new Date();
      await booking.save();

      // Notify both parties
      this.io.to(`farmer_${booking.farmerId}`).emit('booking-confirmed', {
        bookingId,
        message: 'Payment secured! Your booking is confirmed.',
      });

      this.io.to(`provider_${booking.providerId}`).emit('booking-confirmed', {
        bookingId,
        message: 'Payment secured! You can now start the service.',
      });
    }
  }

  async handlePaymentCompleted(event) {
    const { bookingId } = event;

    const booking = await Booking.findOne({ bookingId });
    if (booking) {
      booking.paymentStatus = 'completed';
      await booking.save();
    }
  }

  async handlePaymentFailed(event) {
    const { bookingId, reason } = event;

    const booking = await Booking.findOne({ bookingId });
    if (booking) {
      booking.paymentStatus = 'failed';
      booking.status = 'cancelled_by_farmer';
      booking.cancellationReason = `Payment failed: ${reason}`;
      await booking.save();

      // Notify both parties
      this.io.to(`farmer_${booking.farmerId}`).emit('booking-cancelled', {
        bookingId,
        reason: 'Payment failed',
        message: 'Your booking was cancelled due to payment failure.',
      });

      if (booking.providerId) {
        this.io.to(`provider_${booking.providerId}`).emit('booking-cancelled', {
          bookingId,
          reason: 'Payment failed',
          message: 'Booking cancelled due to payment failure.',
        });
      }
    }
  }

  async handleProvidersFound(event) {
    const { bookingId, providers } = event;

    const booking = await Booking.findOne({ bookingId });
    if (booking && booking.status === 'pending') {
      booking.status = 'matched';
      booking.matchedAt = new Date();
      await booking.save();

      // Notify farmer
      this.io.to(`farmer_${booking.farmerId}`).emit('providers-found', {
        bookingId,
        providersCount: providers.length,
        message: `Found ${providers.length} available providers for your request.`,
      });
    }
  }

  async handleNoProvidersFound(event) {
    const { bookingId } = event;

    const booking = await Booking.findOne({ bookingId });
    if (booking) {
      booking.matchingAttempts += 1;
      booking.lastMatchingAttempt = new Date();
      await booking.save();

      // Notify farmer
      this.io.to(`farmer_${booking.farmerId}`).emit('no-providers-found', {
        bookingId,
        attempts: booking.matchingAttempts,
        message: 'No providers found yet. We will keep searching for you.',
      });
    }
  }

  /**
   * Get booking by ID
   */
  async getBooking(bookingId) {
    try {
      const booking = await Booking.findOne({ bookingId });
      return booking ? booking.toJSON() : null;
    } catch (error) {
      logger.error('Error getting booking:', error);
      throw error;
    }
  }

  /**
   * Get bookings for farmer
   */
  async getFarmerBookings(farmerId, options = {}) {
    try {
      const bookings = await Booking.findByFarmer(farmerId, options);
      return bookings.map(booking => booking.toJSON());
    } catch (error) {
      logger.error('Error getting farmer bookings:', error);
      throw error;
    }
  }

  /**
   * Get bookings for provider
   */
  async getProviderBookings(providerId, options = {}) {
    try {
      const bookings = await Booking.findByProvider(providerId, options);
      return bookings.map(booking => booking.toJSON());
    } catch (error) {
      logger.error('Error getting provider bookings:', error);
      throw error;
    }
  }

  /**
   * Start job (provider marks as in progress)
   */
  async startBooking(bookingId, providerId) {
    try {
      const booking = await Booking.findOne({ bookingId, providerId });

      if (!booking) {
        throw new Error('Booking not found');
      }

      if (booking.status !== 'confirmed') {
        throw new Error(`Cannot start booking in status: ${booking.status}`);
      }

      booking.status = 'in_progress';
      booking.startedAt = new Date();
      await booking.save();

      // Notify farmer
      this.io.to(`farmer_${booking.farmerId}`).emit('booking-started', {
        bookingId,
        message: 'Your service provider has started working on your request.',
      });

      return {
        success: true,
        booking: booking.toJSON(),
      };

    } catch (error) {
      logger.error('Error starting booking:', error);
      throw error;
    }
  }
}

module.exports = BookingService;

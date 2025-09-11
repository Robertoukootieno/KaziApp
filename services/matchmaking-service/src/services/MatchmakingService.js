const { getDistance } = require('geolib');
const logger = require('../utils/logger');
const Provider = require('../models/Provider');

/**
 * Matchmaking Service - Implements sequences E1, E2 from requirements
 * Finds and matches service providers with farmer requests
 */
class MatchmakingService {
  constructor(redisClient, eventBusClient) {
    this.redis = redisClient;
    this.eventBus = eventBusClient;
    this.isInitialized = false;
    
    // Matching configuration
    this.config = {
      maxDistance: 50000, // 50km in meters
      maxProviders: 3,    // Maximum providers to notify
      responseTimeout: 300000, // 5 minutes for provider response
      retryAttempts: 3,
      retryDelay: 600000, // 10 minutes between retries
    };
  }

  async initialize() {
    try {
      // Subscribe to booking events
      await this.eventBus.subscribe('booking-events', this.handleBookingEvents.bind(this));
      
      this.isInitialized = true;
      logger.info('MatchmakingService initialized successfully');
    } catch (error) {
      logger.error('Failed to initialize MatchmakingService:', error);
      throw error;
    }
  }

  /**
   * Handle booking events
   */
  async handleBookingEvents(event) {
    try {
      const { type } = event;

      switch (type) {
        case 'JobCreated':
          await this.findProviders(event);
          break;
        case 'FindAlternativeProviders':
          await this.findAlternativeProviders(event);
          break;
        case 'BookingWithdrawn':
          await this.handleBookingWithdrawn(event);
          break;
        default:
          logger.debug(`Unhandled booking event: ${type}`);
      }
    } catch (error) {
      logger.error('Error handling booking event:', error);
    }
  }

  /**
   * E1 - Multi-provider Offer
   * Find qualified providers and send simultaneous notifications
   */
  async findProviders(jobEvent) {
    try {
      const { bookingId, category, location, requestedDate, metadata } = jobEvent;
      
      logger.info(`Finding providers for booking ${bookingId}, category: ${category}`);

      // Find available providers based on criteria
      const providers = await this.searchProviders({
        category,
        location,
        requestedDate,
        skills: metadata.skills || [],
        maxDistance: this.config.maxDistance,
        limit: this.config.maxProviders,
      });

      if (providers.length === 0) {
        // No providers found
        await this.eventBus.publish('matching-events', {
          type: 'NoProvidersFound',
          bookingId,
          category,
          location,
          timestamp: new Date().toISOString(),
        });
        return;
      }

      logger.info(`Found ${providers.length} providers for booking ${bookingId}`);

      // Store matching session
      const matchingSession = {
        bookingId,
        providers: providers.map(p => ({
          id: p.providerId,
          name: p.name,
          phone: p.phone,
          distance: p.distance,
          rating: p.rating,
          notifiedAt: new Date().toISOString(),
        })),
        status: 'pending',
        createdAt: new Date().toISOString(),
        expiresAt: new Date(Date.now() + this.config.responseTimeout).toISOString(),
      };

      await this.redis.setEx(
        `matching:${bookingId}`,
        this.config.responseTimeout / 1000,
        JSON.stringify(matchingSession)
      );

      // Notify all providers simultaneously
      const notificationPromises = providers.map(provider => 
        this.notifyProvider(provider, jobEvent)
      );

      await Promise.allSettled(notificationPromises);

      // Publish providers found event
      await this.eventBus.publish('matching-events', {
        type: 'ProvidersFound',
        bookingId,
        providers: providers.map(p => ({
          id: p.providerId,
          name: p.name,
          distance: p.distance,
          rating: p.rating,
        })),
        timestamp: new Date().toISOString(),
      });

      // Set timeout to handle no responses
      setTimeout(() => {
        this.handleMatchingTimeout(bookingId);
      }, this.config.responseTimeout);

    } catch (error) {
      logger.error('Error finding providers:', error);
      
      // Publish error event
      await this.eventBus.publish('matching-events', {
        type: 'MatchingError',
        bookingId: jobEvent.bookingId,
        error: error.message,
        timestamp: new Date().toISOString(),
      });
    }
  }

  /**
   * Search for available providers based on criteria
   */
  async searchProviders(criteria) {
    try {
      const {
        category,
        location,
        requestedDate,
        skills,
        maxDistance,
        limit,
      } = criteria;

      // Build query
      const query = {
        isActive: true,
        isAvailable: true,
        categories: category,
      };

      // Add skills filter if specified
      if (skills && skills.length > 0) {
        query.skills = { $in: skills };
      }

      // Find providers
      let providers = await Provider.find(query)
        .select('providerId name phone email location rating totalJobs completionRate skills categories availability')
        .lean();

      // Filter by distance
      if (location && location.coordinates) {
        providers = providers.filter(provider => {
          if (!provider.location || !provider.location.coordinates) {
            return false;
          }

          const distance = getDistance(
            {
              latitude: location.coordinates[1],
              longitude: location.coordinates[0],
            },
            {
              latitude: provider.location.coordinates[1],
              longitude: provider.location.coordinates[0],
            }
          );

          provider.distance = distance;
          return distance <= maxDistance;
        });
      }

      // Filter by availability on requested date
      if (requestedDate) {
        const requestDate = new Date(requestedDate);
        const dayOfWeek = requestDate.getDay(); // 0 = Sunday, 1 = Monday, etc.
        
        providers = providers.filter(provider => {
          if (!provider.availability || !provider.availability.schedule) {
            return true; // Assume available if no schedule specified
          }

          const daySchedule = provider.availability.schedule[dayOfWeek];
          return daySchedule && daySchedule.isAvailable;
        });
      }

      // Sort by rating and distance (weighted)
      providers.sort((a, b) => {
        const aScore = (a.rating || 0) * 0.7 + (1 - (a.distance || 0) / maxDistance) * 0.3;
        const bScore = (b.rating || 0) * 0.7 + (1 - (b.distance || 0) / maxDistance) * 0.3;
        return bScore - aScore;
      });

      // Limit results
      return providers.slice(0, limit);

    } catch (error) {
      logger.error('Error searching providers:', error);
      return [];
    }
  }

  /**
   * Notify provider about new job opportunity
   */
  async notifyProvider(provider, jobEvent) {
    try {
      const { bookingId, farmerId, category, location, totalAmount } = jobEvent;

      // Send push notification
      await this.eventBus.publish('notification-events', {
        type: 'NewJobOpportunity',
        recipientId: provider.providerId,
        recipientType: 'provider',
        title: 'New Job Opportunity',
        message: `New ${category} service request near you - KES ${totalAmount}`,
        data: {
          bookingId,
          farmerId,
          category,
          location: location.address,
          amount: totalAmount,
          distance: provider.distance,
          expiresAt: new Date(Date.now() + this.config.responseTimeout).toISOString(),
        },
        channels: ['push', 'sms'],
        priority: 'high',
        timestamp: new Date().toISOString(),
      });

      logger.info(`Notified provider ${provider.providerId} about booking ${bookingId}`);

    } catch (error) {
      logger.error(`Error notifying provider ${provider.providerId}:`, error);
    }
  }

  /**
   * Handle provider acceptance
   */
  async handleProviderAcceptance(bookingId, providerId, providerData) {
    try {
      // Get matching session
      const sessionData = await this.redis.get(`matching:${bookingId}`);
      if (!sessionData) {
        throw new Error('Matching session not found or expired');
      }

      const session = JSON.parse(sessionData);
      
      // Check if this provider was in the original list
      const provider = session.providers.find(p => p.id === providerId);
      if (!provider) {
        throw new Error('Provider not eligible for this booking');
      }

      // Check if booking is still available
      if (session.status !== 'pending') {
        throw new Error('Booking no longer available');
      }

      // Mark session as accepted
      session.status = 'accepted';
      session.acceptedBy = providerId;
      session.acceptedAt = new Date().toISOString();

      await this.redis.setEx(
        `matching:${bookingId}`,
        3600, // Keep for 1 hour for reference
        JSON.stringify(session)
      );

      // Notify other providers that job was taken
      const otherProviders = session.providers.filter(p => p.id !== providerId);
      const notificationPromises = otherProviders.map(p => 
        this.notifyProviderJobTaken(p.id, bookingId)
      );

      await Promise.allSettled(notificationPromises);

      // Publish provider accepted event
      await this.eventBus.publish('provider-events', {
        type: 'ProviderAccepted',
        bookingId,
        providerId,
        providerData,
        timestamp: new Date().toISOString(),
      });

      logger.info(`Provider ${providerId} accepted booking ${bookingId}`);

      return {
        success: true,
        message: 'Booking accepted successfully',
      };

    } catch (error) {
      logger.error('Error handling provider acceptance:', error);
      throw error;
    }
  }

  /**
   * E2 - Provider Rejects
   */
  async handleProviderRejection(bookingId, providerId, reason) {
    try {
      // Get matching session
      const sessionData = await this.redis.get(`matching:${bookingId}`);
      if (!sessionData) {
        logger.warn(`Matching session not found for booking ${bookingId}`);
        return;
      }

      const session = JSON.parse(sessionData);
      
      // Mark provider as rejected
      const provider = session.providers.find(p => p.id === providerId);
      if (provider) {
        provider.status = 'rejected';
        provider.rejectedAt = new Date().toISOString();
        provider.rejectionReason = reason;

        await this.redis.setEx(
          `matching:${bookingId}`,
          Math.max(300, (new Date(session.expiresAt) - new Date()) / 1000),
          JSON.stringify(session)
        );
      }

      // Publish provider rejected event
      await this.eventBus.publish('provider-events', {
        type: 'ProviderRejected',
        bookingId,
        providerId,
        reason,
        timestamp: new Date().toISOString(),
      });

      // Check if all providers have rejected
      const activeProviders = session.providers.filter(p => !p.status || p.status === 'pending');
      if (activeProviders.length === 0) {
        // All providers rejected, trigger retry or mark as unmatched
        await this.handleAllProvidersRejected(bookingId, session);
      }

      logger.info(`Provider ${providerId} rejected booking ${bookingId}: ${reason}`);

    } catch (error) {
      logger.error('Error handling provider rejection:', error);
    }
  }

  /**
   * Handle timeout when no providers respond
   */
  async handleMatchingTimeout(bookingId) {
    try {
      const sessionData = await this.redis.get(`matching:${bookingId}`);
      if (!sessionData) {
        return; // Session already handled or expired
      }

      const session = JSON.parse(sessionData);
      
      if (session.status === 'pending') {
        // No provider accepted within timeout
        session.status = 'timeout';
        session.timeoutAt = new Date().toISOString();

        await this.redis.setEx(
          `matching:${bookingId}`,
          3600, // Keep for reference
          JSON.stringify(session)
        );

        // Publish timeout event
        await this.eventBus.publish('matching-events', {
          type: 'MatchingTimeout',
          bookingId,
          providersNotified: session.providers.length,
          timestamp: new Date().toISOString(),
        });

        logger.warn(`Matching timeout for booking ${bookingId}`);
      }

    } catch (error) {
      logger.error('Error handling matching timeout:', error);
    }
  }
}

module.exports = MatchmakingService;

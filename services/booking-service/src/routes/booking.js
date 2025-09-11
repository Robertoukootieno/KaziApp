const express = require('express');
const { body, param, query, validationResult } = require('express-validator');
const logger = require('../utils/logger');

const router = express.Router();

// Validation middleware
const handleValidationErrors = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({
      success: false,
      error: 'Validation failed',
      details: errors.array(),
    });
  }
  next();
};

/**
 * POST /api/bookings
 * Create a new booking request (A1 - Farmer Requests a Service)
 */
router.post('/',
  [
    body('title').notEmpty().withMessage('Title is required'),
    body('description').notEmpty().withMessage('Description is required'),
    body('category').isIn(['veterinary', 'crop_advisory', 'equipment_rental', 'labor', 'transport', 'other'])
      .withMessage('Invalid category'),
    body('requestedDate').isISO8601().withMessage('Invalid requested date'),
    body('estimatedDuration').isInt({ min: 15 }).withMessage('Estimated duration must be at least 15 minutes'),
    body('location.coordinates').isArray({ min: 2, max: 2 }).withMessage('Location coordinates required'),
    body('location.address').notEmpty().withMessage('Location address is required'),
    body('totalAmount').isFloat({ min: 0 }).withMessage('Total amount must be a positive number'),
    body('farmerName').notEmpty().withMessage('Farmer name is required'),
    body('farmerPhone').notEmpty().withMessage('Farmer phone is required'),
  ],
  handleValidationErrors,
  async (req, res) => {
    try {
      const bookingService = req.app.locals.bookingService;
      const farmerId = req.user.id; // From auth middleware

      const bookingData = {
        ...req.body,
        farmerName: req.body.farmerName || req.user.name,
        farmerPhone: req.body.farmerPhone || req.user.phone,
        farmerEmail: req.body.farmerEmail || req.user.email,
      };

      const result = await bookingService.createBooking(bookingData, farmerId);

      res.status(201).json({
        success: true,
        message: 'Booking created successfully',
        data: result,
      });

    } catch (error) {
      logger.error('Error creating booking:', error);
      res.status(500).json({
        success: false,
        error: 'Failed to create booking',
        message: error.message,
      });
    }
  }
);

/**
 * GET /api/bookings
 * Get bookings for the authenticated user
 */
router.get('/',
  [
    query('status').optional().isIn(['pending', 'matched', 'accepted', 'confirmed', 'in_progress', 'completed', 'cancelled_by_farmer', 'cancelled_by_provider', 'disputed', 'resolved']),
    query('page').optional().isInt({ min: 1 }),
    query('limit').optional().isInt({ min: 1, max: 100 }),
  ],
  handleValidationErrors,
  async (req, res) => {
    try {
      const bookingService = req.app.locals.bookingService;
      const userId = req.user.id;
      const userType = req.user.type || 'farmer';

      const options = {
        status: req.query.status,
        page: parseInt(req.query.page) || 1,
        limit: parseInt(req.query.limit) || 20,
      };

      let bookings;
      if (userType === 'farmer') {
        bookings = await bookingService.getFarmerBookings(userId, options);
      } else if (userType === 'provider') {
        bookings = await bookingService.getProviderBookings(userId, options);
      } else {
        return res.status(400).json({
          success: false,
          error: 'Invalid user type',
        });
      }

      res.json({
        success: true,
        data: {
          bookings,
          pagination: {
            page: options.page,
            limit: options.limit,
            total: bookings.length,
          },
        },
      });

    } catch (error) {
      logger.error('Error getting bookings:', error);
      res.status(500).json({
        success: false,
        error: 'Failed to get bookings',
        message: error.message,
      });
    }
  }
);

/**
 * GET /api/bookings/:bookingId
 * Get a specific booking
 */
router.get('/:bookingId',
  [
    param('bookingId').notEmpty().withMessage('Booking ID is required'),
  ],
  handleValidationErrors,
  async (req, res) => {
    try {
      const bookingService = req.app.locals.bookingService;
      const { bookingId } = req.params;

      const booking = await bookingService.getBooking(bookingId);

      if (!booking) {
        return res.status(404).json({
          success: false,
          error: 'Booking not found',
        });
      }

      // Check if user has access to this booking
      const userId = req.user.id;
      if (booking.farmerId !== userId && booking.providerId !== userId) {
        return res.status(403).json({
          success: false,
          error: 'Access denied',
        });
      }

      res.json({
        success: true,
        data: booking,
      });

    } catch (error) {
      logger.error('Error getting booking:', error);
      res.status(500).json({
        success: false,
        error: 'Failed to get booking',
        message: error.message,
      });
    }
  }
);

/**
 * PUT /api/bookings/:bookingId/accept
 * Provider accepts a booking
 */
router.put('/:bookingId/accept',
  [
    param('bookingId').notEmpty().withMessage('Booking ID is required'),
  ],
  handleValidationErrors,
  async (req, res) => {
    try {
      const bookingService = req.app.locals.bookingService;
      const { bookingId } = req.params;
      const providerId = req.user.id;

      // Ensure user is a provider
      if (req.user.type !== 'provider') {
        return res.status(403).json({
          success: false,
          error: 'Only providers can accept bookings',
        });
      }

      const providerData = {
        name: req.user.name,
        phone: req.user.phone,
        email: req.user.email,
      };

      const result = await bookingService.acceptBooking(bookingId, providerId, providerData);

      res.json({
        success: true,
        message: 'Booking accepted successfully',
        data: result,
      });

    } catch (error) {
      logger.error('Error accepting booking:', error);
      res.status(400).json({
        success: false,
        error: 'Failed to accept booking',
        message: error.message,
      });
    }
  }
);

/**
 * PUT /api/bookings/:bookingId/cancel
 * Cancel a booking (A2 - Provider Cancels, A3 - Farmer Cancels)
 */
router.put('/:bookingId/cancel',
  [
    param('bookingId').notEmpty().withMessage('Booking ID is required'),
    body('reason').notEmpty().withMessage('Cancellation reason is required'),
  ],
  handleValidationErrors,
  async (req, res) => {
    try {
      const bookingService = req.app.locals.bookingService;
      const { bookingId } = req.params;
      const { reason } = req.body;
      const userId = req.user.id;
      const userType = req.user.type;

      let result;
      if (userType === 'farmer') {
        result = await bookingService.cancelBookingByFarmer(bookingId, userId, reason);
      } else if (userType === 'provider') {
        result = await bookingService.cancelBookingByProvider(bookingId, userId, reason);
      } else {
        return res.status(400).json({
          success: false,
          error: 'Invalid user type',
        });
      }

      res.json({
        success: true,
        message: 'Booking cancelled successfully',
        data: result,
      });

    } catch (error) {
      logger.error('Error cancelling booking:', error);
      res.status(400).json({
        success: false,
        error: 'Failed to cancel booking',
        message: error.message,
      });
    }
  }
);

/**
 * PUT /api/bookings/:bookingId/start
 * Provider starts working on the booking
 */
router.put('/:bookingId/start',
  [
    param('bookingId').notEmpty().withMessage('Booking ID is required'),
  ],
  handleValidationErrors,
  async (req, res) => {
    try {
      const bookingService = req.app.locals.bookingService;
      const { bookingId } = req.params;
      const providerId = req.user.id;

      // Ensure user is a provider
      if (req.user.type !== 'provider') {
        return res.status(403).json({
          success: false,
          error: 'Only providers can start bookings',
        });
      }

      const result = await bookingService.startBooking(bookingId, providerId);

      res.json({
        success: true,
        message: 'Booking started successfully',
        data: result,
      });

    } catch (error) {
      logger.error('Error starting booking:', error);
      res.status(400).json({
        success: false,
        error: 'Failed to start booking',
        message: error.message,
      });
    }
  }
);

/**
 * PUT /api/bookings/:bookingId/complete
 * Provider marks booking as completed
 */
router.put('/:bookingId/complete',
  [
    param('bookingId').notEmpty().withMessage('Booking ID is required'),
    body('notes').optional().isString(),
  ],
  handleValidationErrors,
  async (req, res) => {
    try {
      const bookingService = req.app.locals.bookingService;
      const { bookingId } = req.params;
      const providerId = req.user.id;

      // Ensure user is a provider
      if (req.user.type !== 'provider') {
        return res.status(403).json({
          success: false,
          error: 'Only providers can complete bookings',
        });
      }

      const completionData = {
        notes: req.body.notes,
        attachments: req.body.attachments || [],
      };

      const result = await bookingService.completeBooking(bookingId, providerId, completionData);

      res.json({
        success: true,
        message: 'Booking completed successfully',
        data: result,
      });

    } catch (error) {
      logger.error('Error completing booking:', error);
      res.status(400).json({
        success: false,
        error: 'Failed to complete booking',
        message: error.message,
      });
    }
  }
);

module.exports = router;

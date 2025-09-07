const Joi = require('joi');
const logger = require('../utils/logger');

/**
 * Request validation middleware with comprehensive schema validation
 */
class RequestValidator {
  constructor() {
    this.schemas = this.initializeSchemas();
  }

  /**
   * Initialize validation schemas for different endpoints
   */
  initializeSchemas() {
    return {
      // Authentication schemas
      '/api/auth/register': {
        body: Joi.object({
          firstName: Joi.string().min(2).max(50).required(),
          lastName: Joi.string().min(2).max(50).required(),
          phoneNumber: Joi.string().pattern(/^\+254[0-9]{9}$/).required(),
          email: Joi.string().email().optional(),
          password: Joi.string().min(8).max(128).required(),
          userType: Joi.string().valid('farmer', 'veterinarian', 'buyer', 'vendor', 'admin').required(),
          county: Joi.string().min(2).max(50).required(),
          subCounty: Joi.string().min(2).max(50).optional(),
          ward: Joi.string().min(2).max(50).optional(),
          licenseNumber: Joi.string().when('userType', {
            is: 'veterinarian',
            then: Joi.required(),
            otherwise: Joi.optional(),
          }),
          preferredLanguage: Joi.string().valid('en', 'sw', 'ki').default('sw'),
        }),
      },

      '/api/auth/login': {
        body: Joi.object({
          phoneNumber: Joi.string().pattern(/^\+254[0-9]{9}$/).required(),
          password: Joi.string().min(1).required(),
        }),
      },

      '/api/auth/verify-phone': {
        body: Joi.object({
          phoneNumber: Joi.string().pattern(/^\+254[0-9]{9}$/).required(),
          code: Joi.string().length(6).pattern(/^[0-9]+$/).required(),
        }),
      },

      // User management schemas
      '/api/users/profile': {
        body: Joi.object({
          firstName: Joi.string().min(2).max(50).optional(),
          lastName: Joi.string().min(2).max(50).optional(),
          email: Joi.string().email().optional(),
          county: Joi.string().min(2).max(50).optional(),
          subCounty: Joi.string().min(2).max(50).optional(),
          ward: Joi.string().min(2).max(50).optional(),
          preferredLanguage: Joi.string().valid('en', 'sw', 'ki').optional(),
          profilePicture: Joi.string().uri().optional(),
        }),
      },

      // Payment schemas
      '/api/payments/mpesa/stk-push': {
        body: Joi.object({
          phoneNumber: Joi.string().pattern(/^\+254[0-9]{9}$/).required(),
          amount: Joi.number().min(1).max(70000).required(),
          description: Joi.string().min(1).max(100).required(),
          reference: Joi.string().min(1).max(50).optional(),
        }),
      },

      // Marketplace schemas
      '/api/marketplace/products': {
        body: Joi.object({
          name: Joi.string().min(2).max(100).required(),
          description: Joi.string().min(10).max(1000).required(),
          category: Joi.string().valid('crops', 'livestock', 'equipment', 'services').required(),
          price: Joi.number().min(0).required(),
          unit: Joi.string().min(1).max(20).required(),
          quantity: Joi.number().min(0).required(),
          location: Joi.object({
            county: Joi.string().required(),
            subCounty: Joi.string().optional(),
            coordinates: Joi.object({
              lat: Joi.number().min(-90).max(90).required(),
              lng: Joi.number().min(-180).max(180).required(),
            }).optional(),
          }).required(),
          images: Joi.array().items(Joi.string().uri()).max(5).optional(),
        }),
      },

      // Farm management schemas
      '/api/farm-management/farms': {
        body: Joi.object({
          name: Joi.string().min(2).max(100).required(),
          size: Joi.number().min(0.1).required(),
          sizeUnit: Joi.string().valid('acres', 'hectares').required(),
          location: Joi.object({
            county: Joi.string().required(),
            subCounty: Joi.string().optional(),
            coordinates: Joi.object({
              lat: Joi.number().min(-90).max(90).required(),
              lng: Joi.number().min(-180).max(180).required(),
            }).optional(),
          }).required(),
          farmType: Joi.string().valid('crop', 'livestock', 'mixed').required(),
          crops: Joi.array().items(Joi.string()).optional(),
          livestock: Joi.array().items(Joi.string()).optional(),
        }),
      },

      // AI Diagnostics schemas
      '/api/ai-diagnostics/analyze': {
        body: Joi.object({
          type: Joi.string().valid('crop', 'livestock').required(),
          images: Joi.array().items(Joi.string().uri()).min(1).max(3).required(),
          symptoms: Joi.array().items(Joi.string()).optional(),
          location: Joi.object({
            county: Joi.string().required(),
            coordinates: Joi.object({
              lat: Joi.number().min(-90).max(90).required(),
              lng: Joi.number().min(-180).max(180).required(),
            }).optional(),
          }).optional(),
        }),
      },

      // Communication schemas
      '/api/communication/messages': {
        body: Joi.object({
          recipientId: Joi.string().uuid().required(),
          message: Joi.string().min(1).max(1000).required(),
          type: Joi.string().valid('text', 'image', 'document').default('text'),
          attachments: Joi.array().items(Joi.string().uri()).max(3).optional(),
        }),
      },
    };
  }

  /**
   * Main validation middleware
   */
  middleware() {
    return (req, res, next) => {
      try {
        // Skip validation for certain paths
        if (this.shouldSkipValidation(req)) {
          return next();
        }

        // Get schema for the current endpoint
        const schema = this.getSchema(req);
        if (!schema) {
          return next(); // No schema defined, skip validation
        }

        // Validate request
        const validationResult = this.validateRequest(req, schema);
        if (validationResult.error) {
          return res.status(400).json({
            success: false,
            message: 'Validation error',
            errors: validationResult.error.details.map(detail => ({
              field: detail.path.join('.'),
              message: detail.message,
              value: detail.context?.value,
            })),
            timestamp: new Date().toISOString(),
          });
        }

        // Add validated data to request
        if (validationResult.body) {
          req.validatedBody = validationResult.body;
        }
        if (validationResult.query) {
          req.validatedQuery = validationResult.query;
        }
        if (validationResult.params) {
          req.validatedParams = validationResult.params;
        }

        next();
      } catch (error) {
        logger.error('Request validation error:', error);
        res.status(500).json({
          success: false,
          message: 'Internal validation error',
          timestamp: new Date().toISOString(),
        });
      }
    };
  }

  /**
   * Check if validation should be skipped for this request
   */
  shouldSkipValidation(req) {
    const skipPaths = [
      '/health',
      '/metrics',
      '/api-docs',
      '/favicon.ico',
    ];

    const skipMethods = ['OPTIONS'];

    return skipPaths.includes(req.path) || 
           skipMethods.includes(req.method) ||
           req.path.startsWith('/api-docs/');
  }

  /**
   * Get validation schema for the current request
   */
  getSchema(req) {
    const path = req.path;
    const method = req.method.toLowerCase();

    // Try exact path match first
    let schema = this.schemas[path];
    if (schema) {
      return schema;
    }

    // Try pattern matching for dynamic routes
    for (const [pattern, schemaConfig] of Object.entries(this.schemas)) {
      if (this.matchesPattern(path, pattern)) {
        return schemaConfig;
      }
    }

    return null;
  }

  /**
   * Check if path matches a pattern (simple wildcard support)
   */
  matchesPattern(path, pattern) {
    // Convert pattern to regex (simple implementation)
    const regexPattern = pattern
      .replace(/:[^/]+/g, '[^/]+') // Replace :param with regex
      .replace(/\*/g, '.*'); // Replace * with regex
    
    const regex = new RegExp(`^${regexPattern}$`);
    return regex.test(path);
  }

  /**
   * Validate request against schema
   */
  validateRequest(req, schema) {
    const result = {};

    // Validate body
    if (schema.body && req.body) {
      const { error, value } = schema.body.validate(req.body, {
        abortEarly: false,
        stripUnknown: true,
        convert: true,
      });
      
      if (error) {
        return { error };
      }
      result.body = value;
    }

    // Validate query parameters
    if (schema.query && req.query) {
      const { error, value } = schema.query.validate(req.query, {
        abortEarly: false,
        stripUnknown: true,
        convert: true,
      });
      
      if (error) {
        return { error };
      }
      result.query = value;
    }

    // Validate path parameters
    if (schema.params && req.params) {
      const { error, value } = schema.params.validate(req.params, {
        abortEarly: false,
        stripUnknown: true,
        convert: true,
      });
      
      if (error) {
        return { error };
      }
      result.params = value;
    }

    return result;
  }

  /**
   * Add new validation schema
   */
  addSchema(path, schema) {
    this.schemas[path] = schema;
  }

  /**
   * Remove validation schema
   */
  removeSchema(path) {
    delete this.schemas[path];
  }
}

const requestValidator = new RequestValidator();

module.exports = requestValidator.middleware();
module.exports.RequestValidator = RequestValidator;
module.exports.requestValidator = requestValidator;

const rateLimit = require('express-rate-limit');
const RedisStore = require('rate-limit-redis');
const redisClient = require('../config/redis');
const logger = require('../utils/logger');

/**
 * Advanced rate limiting middleware with different tiers
 */
class RateLimitManager {
  constructor() {
    this.store = new RedisStore({
      sendCommand: (...args) => redisClient.call(...args),
    });
  }

  /**
   * Create rate limiter with custom configuration
   */
  createLimiter(config) {
    return rateLimit({
      store: this.store,
      windowMs: config.windowMs,
      max: config.max,
      message: {
        error: config.message,
        retryAfter: Math.ceil(config.windowMs / 1000),
        timestamp: new Date().toISOString(),
        limit: config.max,
        window: config.windowMs,
      },
      standardHeaders: true,
      legacyHeaders: false,
      keyGenerator: (req) => {
        // Use different keys based on authentication status
        if (req.user) {
          return `user:${req.user.id}:${req.user.type}`;
        }
        if (req.apiKey) {
          return `apikey:${req.headers['x-api-key']}`;
        }
        return `ip:${req.ip}`;
      },
      skip: (req) => {
        // Skip rate limiting for health checks and internal requests
        return req.path === '/health' || 
               req.path === '/metrics' ||
               req.headers['x-internal-request'] === 'true';
      },
      onLimitReached: (req, res, options) => {
        const identifier = req.user?.id || req.ip;
        logger.warn(`Rate limit exceeded for ${identifier}`, {
          path: req.path,
          method: req.method,
          userAgent: req.headers['user-agent'],
          limit: options.max,
          window: options.windowMs,
        });
      },
    });
  }

  /**
   * Get rate limiter based on user type and endpoint
   */
  getMiddleware() {
    return (req, res, next) => {
      // Determine appropriate rate limit based on context
      const limiter = this.selectLimiter(req);
      limiter(req, res, next);
    };
  }

  /**
   * Select appropriate rate limiter based on request context
   */
  selectLimiter(req) {
    const path = req.path;
    const userType = req.user?.type;
    const hasApiKey = !!req.headers['x-api-key'];

    // Authentication endpoints - strict limits
    if (path.startsWith('/api/auth')) {
      return this.authLimiter;
    }

    // Admin endpoints - higher limits for authenticated admins
    if (path.startsWith('/api/admin')) {
      if (userType === 'admin') {
        return this.adminLimiter;
      }
      return this.strictLimiter;
    }

    // Payment endpoints - moderate limits with extra security
    if (path.startsWith('/api/payments')) {
      return this.paymentLimiter;
    }

    // AI/ML endpoints - resource intensive, lower limits
    if (path.startsWith('/api/ai-diagnostics')) {
      return this.aiLimiter;
    }

    // File upload endpoints
    if (path.includes('/upload')) {
      return this.uploadLimiter;
    }

    // API key requests get higher limits
    if (hasApiKey) {
      return this.apiKeyLimiter;
    }

    // Authenticated users get higher limits
    if (req.user) {
      return userType === 'admin' ? this.adminLimiter : this.userLimiter;
    }

    // Default for anonymous users
    return this.anonymousLimiter;
  }

  /**
   * Initialize all rate limiters
   */
  init() {
    // Authentication endpoints - very strict
    this.authLimiter = this.createLimiter({
      windowMs: 15 * 60 * 1000, // 15 minutes
      max: 10,
      message: 'Too many authentication attempts. Please try again later.',
    });

    // Admin endpoints - high limits for admins
    this.adminLimiter = this.createLimiter({
      windowMs: 15 * 60 * 1000, // 15 minutes
      max: 5000,
      message: 'Admin rate limit exceeded.',
    });

    // Payment endpoints - moderate limits with security focus
    this.paymentLimiter = this.createLimiter({
      windowMs: 15 * 60 * 1000, // 15 minutes
      max: 100,
      message: 'Payment API rate limit exceeded.',
    });

    // AI endpoints - resource intensive operations
    this.aiLimiter = this.createLimiter({
      windowMs: 15 * 60 * 1000, // 15 minutes
      max: 50,
      message: 'AI service rate limit exceeded.',
    });

    // File upload endpoints
    this.uploadLimiter = this.createLimiter({
      windowMs: 15 * 60 * 1000, // 15 minutes
      max: 20,
      message: 'File upload rate limit exceeded.',
    });

    // API key requests
    this.apiKeyLimiter = this.createLimiter({
      windowMs: 15 * 60 * 1000, // 15 minutes
      max: 2000,
      message: 'API key rate limit exceeded.',
    });

    // Authenticated users
    this.userLimiter = this.createLimiter({
      windowMs: 15 * 60 * 1000, // 15 minutes
      max: 1000,
      message: 'User rate limit exceeded.',
    });

    // Anonymous users
    this.anonymousLimiter = this.createLimiter({
      windowMs: 15 * 60 * 1000, // 15 minutes
      max: 100,
      message: 'Anonymous rate limit exceeded. Please authenticate for higher limits.',
    });

    // Strict limiter for sensitive operations
    this.strictLimiter = this.createLimiter({
      windowMs: 15 * 60 * 1000, // 15 minutes
      max: 5,
      message: 'Strict rate limit exceeded.',
    });
  }

  /**
   * Get current rate limit status for a key
   */
  async getRateLimitStatus(key) {
    try {
      const hits = await redisClient.get(`rl:${key}`);
      return {
        hits: parseInt(hits) || 0,
        remaining: Math.max(0, 1000 - (parseInt(hits) || 0)),
        resetTime: new Date(Date.now() + 15 * 60 * 1000),
      };
    } catch (error) {
      logger.error('Error getting rate limit status:', error);
      return null;
    }
  }

  /**
   * Reset rate limit for a specific key (admin function)
   */
  async resetRateLimit(key) {
    try {
      await redisClient.del(`rl:${key}`);
      logger.info(`Rate limit reset for key: ${key}`);
      return true;
    } catch (error) {
      logger.error('Error resetting rate limit:', error);
      return false;
    }
  }

  /**
   * Get rate limit statistics
   */
  async getStatistics() {
    try {
      const keys = await redisClient.keys('rl:*');
      const stats = {
        totalKeys: keys.length,
        userKeys: keys.filter(k => k.includes('user:')).length,
        ipKeys: keys.filter(k => k.includes('ip:')).length,
        apiKeyKeys: keys.filter(k => k.includes('apikey:')).length,
      };
      
      return stats;
    } catch (error) {
      logger.error('Error getting rate limit statistics:', error);
      return null;
    }
  }
}

// Initialize rate limit manager
const rateLimitManager = new RateLimitManager();
rateLimitManager.init();

module.exports = rateLimitManager.getMiddleware();
module.exports.RateLimitManager = RateLimitManager;
module.exports.rateLimitManager = rateLimitManager;

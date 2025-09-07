const crypto = require('crypto');
const logger = require('../utils/logger');
const redisClient = require('../config/redis');

/**
 * Enhanced security middleware for API Gateway
 */
class SecurityMiddleware {
  constructor() {
    this.suspiciousIPs = new Set();
    this.apiKeys = new Map();
    this.loadApiKeys();
  }

  /**
   * Load API keys from environment or database
   */
  async loadApiKeys() {
    try {
      // Load from Redis or database
      const keys = await redisClient.hgetall('api_keys');
      Object.entries(keys || {}).forEach(([key, data]) => {
        this.apiKeys.set(key, JSON.parse(data));
      });
      
      // Add default API keys from environment
      if (process.env.ADMIN_API_KEY) {
        this.apiKeys.set(process.env.ADMIN_API_KEY, {
          name: 'Admin Dashboard',
          permissions: ['admin:*'],
          rateLimit: 10000,
        });
      }
      
      if (process.env.MOBILE_API_KEY) {
        this.apiKeys.set(process.env.MOBILE_API_KEY, {
          name: 'Mobile Apps',
          permissions: ['user:*'],
          rateLimit: 1000,
        });
      }
    } catch (error) {
      logger.error('Failed to load API keys:', error);
    }
  }

  /**
   * Main security middleware
   */
  middleware() {
    return async (req, res, next) => {
      try {
        // Skip security checks for health endpoints
        if (req.path === '/health' || req.path === '/metrics') {
          return next();
        }

        // Check for suspicious activity
        if (await this.checkSuspiciousActivity(req)) {
          return res.status(429).json({
            error: 'Suspicious activity detected',
            timestamp: new Date().toISOString(),
          });
        }

        // Validate API key if present
        if (req.headers['x-api-key']) {
          const isValid = await this.validateApiKey(req);
          if (!isValid) {
            return res.status(401).json({
              error: 'Invalid API key',
              timestamp: new Date().toISOString(),
            });
          }
        }

        // Check request signature for sensitive operations
        if (this.requiresSignature(req)) {
          const isValidSignature = await this.validateSignature(req);
          if (!isValidSignature) {
            return res.status(401).json({
              error: 'Invalid request signature',
              timestamp: new Date().toISOString(),
            });
          }
        }

        // Add security headers
        this.addSecurityHeaders(res);

        next();
      } catch (error) {
        logger.error('Security middleware error:', error);
        res.status(500).json({
          error: 'Internal security error',
          timestamp: new Date().toISOString(),
        });
      }
    };
  }

  /**
   * Check for suspicious activity patterns
   */
  async checkSuspiciousActivity(req) {
    const clientIP = req.ip;
    const userAgent = req.headers['user-agent'];
    
    // Check if IP is in suspicious list
    if (this.suspiciousIPs.has(clientIP)) {
      return true;
    }

    // Check for common attack patterns
    const suspiciousPatterns = [
      /\.\.\//,  // Path traversal
      /<script/i,  // XSS attempts
      /union.*select/i,  // SQL injection
      /javascript:/i,  // JavaScript injection
    ];

    const requestString = JSON.stringify({
      url: req.url,
      body: req.body,
      query: req.query,
    });

    for (const pattern of suspiciousPatterns) {
      if (pattern.test(requestString)) {
        logger.warn(`Suspicious request detected from ${clientIP}:`, {
          pattern: pattern.toString(),
          url: req.url,
          userAgent,
        });
        
        // Add to suspicious IPs temporarily
        this.suspiciousIPs.add(clientIP);
        setTimeout(() => this.suspiciousIPs.delete(clientIP), 3600000); // 1 hour
        
        return true;
      }
    }

    // Check request frequency
    const requestKey = `req_freq:${clientIP}`;
    const requestCount = await redisClient.incr(requestKey);
    
    if (requestCount === 1) {
      await redisClient.expire(requestKey, 60); // 1 minute window
    }
    
    // More than 100 requests per minute is suspicious
    if (requestCount > 100) {
      logger.warn(`High request frequency from ${clientIP}: ${requestCount} requests/minute`);
      return true;
    }

    return false;
  }

  /**
   * Validate API key
   */
  async validateApiKey(req) {
    const apiKey = req.headers['x-api-key'];
    const keyData = this.apiKeys.get(apiKey);
    
    if (!keyData) {
      return false;
    }

    // Check rate limit for this API key
    const rateLimitKey = `api_key_limit:${apiKey}`;
    const currentUsage = await redisClient.incr(rateLimitKey);
    
    if (currentUsage === 1) {
      await redisClient.expire(rateLimitKey, 3600); // 1 hour window
    }
    
    if (currentUsage > keyData.rateLimit) {
      logger.warn(`API key rate limit exceeded:`, { apiKey, usage: currentUsage });
      return false;
    }

    // Add key info to request
    req.apiKey = keyData;
    
    return true;
  }

  /**
   * Check if request requires signature validation
   */
  requiresSignature(req) {
    const sensitiveEndpoints = [
      '/api/payments',
      '/api/admin',
      '/api/users/admin',
    ];
    
    return sensitiveEndpoints.some(endpoint => req.path.startsWith(endpoint));
  }

  /**
   * Validate request signature
   */
  async validateSignature(req) {
    const signature = req.headers['x-signature'];
    const timestamp = req.headers['x-timestamp'];
    
    if (!signature || !timestamp) {
      return false;
    }

    // Check timestamp (prevent replay attacks)
    const now = Date.now();
    const requestTime = parseInt(timestamp);
    
    if (Math.abs(now - requestTime) > 300000) { // 5 minutes tolerance
      logger.warn('Request timestamp too old or too far in future');
      return false;
    }

    // Validate signature
    const secret = process.env.WEBHOOK_SECRET || 'default-secret';
    const payload = req.rawBody || JSON.stringify(req.body);
    const expectedSignature = crypto
      .createHmac('sha256', secret)
      .update(timestamp + payload)
      .digest('hex');
    
    const providedSignature = signature.replace('sha256=', '');
    
    return crypto.timingSafeEqual(
      Buffer.from(expectedSignature, 'hex'),
      Buffer.from(providedSignature, 'hex')
    );
  }

  /**
   * Add security headers to response
   */
  addSecurityHeaders(res) {
    res.setHeader('X-Content-Type-Options', 'nosniff');
    res.setHeader('X-Frame-Options', 'DENY');
    res.setHeader('X-XSS-Protection', '1; mode=block');
    res.setHeader('Referrer-Policy', 'strict-origin-when-cross-origin');
    res.setHeader('Permissions-Policy', 'geolocation=(), microphone=(), camera=()');
  }

  /**
   * Add new API key
   */
  async addApiKey(key, data) {
    this.apiKeys.set(key, data);
    await redisClient.hset('api_keys', key, JSON.stringify(data));
  }

  /**
   * Remove API key
   */
  async removeApiKey(key) {
    this.apiKeys.delete(key);
    await redisClient.hdel('api_keys', key);
  }
}

const securityMiddleware = new SecurityMiddleware();

module.exports = securityMiddleware.middleware();
module.exports.SecurityMiddleware = SecurityMiddleware;

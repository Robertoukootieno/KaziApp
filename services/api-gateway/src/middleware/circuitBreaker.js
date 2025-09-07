const logger = require('../utils/logger');
const redisClient = require('../config/redis');

/**
 * Circuit breaker middleware to prevent cascading failures
 */
class CircuitBreaker {
  constructor(options = {}) {
    this.failureThreshold = options.failureThreshold || 5;
    this.recoveryTimeout = options.recoveryTimeout || 60000; // 1 minute
    this.monitoringPeriod = options.monitoringPeriod || 300000; // 5 minutes
    this.halfOpenMaxCalls = options.halfOpenMaxCalls || 3;
    
    this.circuits = new Map();
    this.initializeCircuits();
  }

  /**
   * Initialize circuit breakers for different services
   */
  initializeCircuits() {
    const services = [
      'user-service',
      'payment-service',
      'ai-diagnostics',
      'marketplace',
      'communication',
      'farm-management',
      'notification',
      'community',
    ];

    services.forEach(service => {
      this.circuits.set(service, {
        state: 'CLOSED', // CLOSED, OPEN, HALF_OPEN
        failures: 0,
        lastFailureTime: null,
        halfOpenCalls: 0,
        successCount: 0,
        totalCalls: 0,
      });
    });
  }

  /**
   * Main circuit breaker middleware
   */
  middleware() {
    return async (req, res, next) => {
      const service = this.getServiceFromPath(req.path);
      
      if (!service) {
        return next(); // No circuit breaker for this path
      }

      try {
        const circuit = await this.getCircuitState(service);
        
        // Check if circuit is open
        if (circuit.state === 'OPEN') {
          if (await this.shouldAttemptReset(service, circuit)) {
            await this.setCircuitState(service, 'HALF_OPEN');
            logger.info(`Circuit breaker for ${service} moved to HALF_OPEN state`);
          } else {
            return this.handleOpenCircuit(req, res, service);
          }
        }

        // Handle half-open state
        if (circuit.state === 'HALF_OPEN') {
          if (circuit.halfOpenCalls >= this.halfOpenMaxCalls) {
            return this.handleOpenCircuit(req, res, service);
          }
          await this.incrementHalfOpenCalls(service);
        }

        // Add circuit breaker context to request
        req.circuitBreaker = {
          service,
          recordSuccess: () => this.recordSuccess(service),
          recordFailure: () => this.recordFailure(service),
        };

        // Wrap response to capture success/failure
        this.wrapResponse(res, service);

        next();
      } catch (error) {
        logger.error(`Circuit breaker error for ${service}:`, error);
        next();
      }
    };
  }

  /**
   * Get service name from request path
   */
  getServiceFromPath(path) {
    const serviceMap = {
      '/api/users': 'user-service',
      '/api/auth': 'user-service',
      '/api/payments': 'payment-service',
      '/api/ai-diagnostics': 'ai-diagnostics',
      '/api/marketplace': 'marketplace',
      '/api/communication': 'communication',
      '/api/farm-management': 'farm-management',
      '/api/notifications': 'notification',
      '/api/community': 'community',
    };

    for (const [prefix, service] of Object.entries(serviceMap)) {
      if (path.startsWith(prefix)) {
        return service;
      }
    }

    return null;
  }

  /**
   * Get circuit state from Redis
   */
  async getCircuitState(service) {
    try {
      const key = `circuit:${service}`;
      const data = await redisClient.hgetall(key);
      
      if (Object.keys(data).length === 0) {
        // Initialize circuit state in Redis
        const initialState = this.circuits.get(service);
        await this.setCircuitState(service, initialState.state, initialState);
        return initialState;
      }

      return {
        state: data.state || 'CLOSED',
        failures: parseInt(data.failures) || 0,
        lastFailureTime: data.lastFailureTime ? new Date(data.lastFailureTime) : null,
        halfOpenCalls: parseInt(data.halfOpenCalls) || 0,
        successCount: parseInt(data.successCount) || 0,
        totalCalls: parseInt(data.totalCalls) || 0,
      };
    } catch (error) {
      logger.error(`Error getting circuit state for ${service}:`, error);
      return this.circuits.get(service) || { state: 'CLOSED', failures: 0 };
    }
  }

  /**
   * Set circuit state in Redis
   */
  async setCircuitState(service, state, data = {}) {
    try {
      const key = `circuit:${service}`;
      const stateData = {
        state,
        failures: data.failures || 0,
        lastFailureTime: data.lastFailureTime?.toISOString() || null,
        halfOpenCalls: data.halfOpenCalls || 0,
        successCount: data.successCount || 0,
        totalCalls: data.totalCalls || 0,
        updatedAt: new Date().toISOString(),
      };

      await redisClient.hmset(key, stateData);
      await redisClient.expire(key, 3600); // Expire after 1 hour of inactivity
      
      // Update local cache
      this.circuits.set(service, {
        ...stateData,
        lastFailureTime: data.lastFailureTime,
      });
    } catch (error) {
      logger.error(`Error setting circuit state for ${service}:`, error);
    }
  }

  /**
   * Check if circuit should attempt reset
   */
  async shouldAttemptReset(service, circuit) {
    if (!circuit.lastFailureTime) {
      return true;
    }

    const timeSinceLastFailure = Date.now() - circuit.lastFailureTime.getTime();
    return timeSinceLastFailure >= this.recoveryTimeout;
  }

  /**
   * Handle open circuit response
   */
  handleOpenCircuit(req, res, service) {
    logger.warn(`Circuit breaker OPEN for ${service}, rejecting request`);
    
    return res.status(503).json({
      success: false,
      error: 'Service temporarily unavailable',
      service,
      message: 'Circuit breaker is open. Service is experiencing issues.',
      retryAfter: Math.ceil(this.recoveryTimeout / 1000),
      timestamp: new Date().toISOString(),
    });
  }

  /**
   * Increment half-open calls counter
   */
  async incrementHalfOpenCalls(service) {
    try {
      const key = `circuit:${service}`;
      await redisClient.hincrby(key, 'halfOpenCalls', 1);
    } catch (error) {
      logger.error(`Error incrementing half-open calls for ${service}:`, error);
    }
  }

  /**
   * Record successful request
   */
  async recordSuccess(service) {
    try {
      const circuit = await this.getCircuitState(service);
      
      if (circuit.state === 'HALF_OPEN') {
        // Reset circuit to closed after successful half-open calls
        await this.setCircuitState(service, 'CLOSED', {
          failures: 0,
          lastFailureTime: null,
          halfOpenCalls: 0,
          successCount: circuit.successCount + 1,
          totalCalls: circuit.totalCalls + 1,
        });
        
        logger.info(`Circuit breaker for ${service} reset to CLOSED state`);
      } else {
        // Just increment success counter
        const key = `circuit:${service}`;
        await redisClient.hincrby(key, 'successCount', 1);
        await redisClient.hincrby(key, 'totalCalls', 1);
      }
    } catch (error) {
      logger.error(`Error recording success for ${service}:`, error);
    }
  }

  /**
   * Record failed request
   */
  async recordFailure(service) {
    try {
      const circuit = await this.getCircuitState(service);
      const newFailures = circuit.failures + 1;
      
      let newState = circuit.state;
      
      // Check if we should open the circuit
      if (newFailures >= this.failureThreshold && circuit.state !== 'OPEN') {
        newState = 'OPEN';
        logger.warn(`Circuit breaker for ${service} opened after ${newFailures} failures`);
      }
      
      await this.setCircuitState(service, newState, {
        failures: newFailures,
        lastFailureTime: new Date(),
        halfOpenCalls: 0,
        successCount: circuit.successCount,
        totalCalls: circuit.totalCalls + 1,
      });
    } catch (error) {
      logger.error(`Error recording failure for ${service}:`, error);
    }
  }

  /**
   * Wrap response to capture success/failure
   */
  wrapResponse(res, service) {
    const originalSend = res.send;
    const originalJson = res.json;
    
    const recordResult = () => {
      if (res.statusCode >= 500) {
        this.recordFailure(service);
      } else {
        this.recordSuccess(service);
      }
    };

    res.send = function(data) {
      recordResult();
      return originalSend.call(this, data);
    };

    res.json = function(data) {
      recordResult();
      return originalJson.call(this, data);
    };
  }

  /**
   * Get circuit breaker statistics
   */
  async getStatistics() {
    try {
      const stats = {};
      
      for (const service of this.circuits.keys()) {
        const circuit = await this.getCircuitState(service);
        stats[service] = {
          state: circuit.state,
          failures: circuit.failures,
          successCount: circuit.successCount,
          totalCalls: circuit.totalCalls,
          successRate: circuit.totalCalls > 0 ? 
            ((circuit.successCount / circuit.totalCalls) * 100).toFixed(2) + '%' : 'N/A',
          lastFailureTime: circuit.lastFailureTime,
        };
      }
      
      return stats;
    } catch (error) {
      logger.error('Error getting circuit breaker statistics:', error);
      return {};
    }
  }

  /**
   * Reset circuit breaker for a service (admin function)
   */
  async resetCircuit(service) {
    try {
      await this.setCircuitState(service, 'CLOSED', {
        failures: 0,
        lastFailureTime: null,
        halfOpenCalls: 0,
        successCount: 0,
        totalCalls: 0,
      });
      
      logger.info(`Circuit breaker for ${service} manually reset`);
      return true;
    } catch (error) {
      logger.error(`Error resetting circuit breaker for ${service}:`, error);
      return false;
    }
  }
}

const circuitBreaker = new CircuitBreaker();

module.exports = circuitBreaker.middleware();
module.exports.CircuitBreaker = CircuitBreaker;
module.exports.circuitBreaker = circuitBreaker;

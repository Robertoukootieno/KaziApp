const axios = require('axios');
const logger = require('./logger');
const redisClient = require('../config/redis');
const metrics = require('./metrics');

/**
 * Health check utility for monitoring service health
 */
class HealthChecker {
  constructor() {
    this.services = this.initializeServices();
    this.healthStatus = new Map();
    this.checkInterval = 30000; // 30 seconds
    this.timeout = 5000; // 5 seconds
    
    this.startHealthChecks();
  }

  /**
   * Initialize service configurations
   */
  initializeServices() {
    return {
      'user-service': {
        url: process.env.USER_SERVICE_URL || 'http://user-service:3000',
        healthPath: '/health',
        critical: true,
      },
      'payment-service': {
        url: process.env.PAYMENT_SERVICE_URL || 'http://payment-service:3000',
        healthPath: '/health',
        critical: true,
      },
      'ai-diagnostics': {
        url: process.env.AI_DIAGNOSTICS_SERVICE_URL || 'http://ai-diagnostics:3000',
        healthPath: '/health',
        critical: false,
      },
      'marketplace': {
        url: process.env.MARKETPLACE_SERVICE_URL || 'http://marketplace:3000',
        healthPath: '/health',
        critical: false,
      },
      'communication': {
        url: process.env.COMMUNICATION_SERVICE_URL || 'http://communication:3000',
        healthPath: '/health',
        critical: false,
      },
      'farm-management': {
        url: process.env.FARM_MANAGEMENT_SERVICE_URL || 'http://farm-management:3000',
        healthPath: '/health',
        critical: false,
      },
      'notification': {
        url: process.env.NOTIFICATION_SERVICE_URL || 'http://notification:3000',
        healthPath: '/health',
        critical: false,
      },
      'community': {
        url: process.env.COMMUNITY_SERVICE_URL || 'http://community:3000',
        healthPath: '/health',
        critical: false,
      },
      'redis': {
        check: () => this.checkRedis(),
        critical: true,
      },
      'database': {
        check: () => this.checkDatabase(),
        critical: true,
      },
    };
  }

  /**
   * Start periodic health checks
   */
  startHealthChecks() {
    // Initial health check
    this.performHealthChecks();
    
    // Schedule periodic checks
    setInterval(() => {
      this.performHealthChecks();
    }, this.checkInterval);
    
    logger.info('Health checks started');
  }

  /**
   * Perform health checks for all services
   */
  async performHealthChecks() {
    const promises = Object.entries(this.services).map(([serviceName, config]) => 
      this.checkService(serviceName, config)
    );
    
    await Promise.allSettled(promises);
    
    // Update overall health status
    this.updateOverallHealth();
  }

  /**
   * Check individual service health
   */
  async checkService(serviceName, config) {
    try {
      let isHealthy = false;
      let responseTime = 0;
      let details = {};
      
      const startTime = Date.now();
      
      if (config.check) {
        // Custom health check function
        const result = await config.check();
        isHealthy = result.healthy;
        details = result.details || {};
      } else {
        // HTTP health check
        const response = await axios.get(
          `${config.url}${config.healthPath}`,
          {
            timeout: this.timeout,
            headers: {
              'User-Agent': 'KaziApp-Gateway-HealthCheck',
              'X-Internal-Request': 'true',
            },
          }
        );
        
        isHealthy = response.status === 200;
        details = response.data || {};
      }
      
      responseTime = Date.now() - startTime;
      
      const healthData = {
        healthy: isHealthy,
        responseTime,
        lastCheck: new Date().toISOString(),
        details,
        critical: config.critical,
      };
      
      this.healthStatus.set(serviceName, healthData);
      
      // Update metrics
      metrics.updateServiceHealth(serviceName, isHealthy);
      
      if (!isHealthy && config.critical) {
        logger.error(`Critical service ${serviceName} is unhealthy:`, details);
      } else if (!isHealthy) {
        logger.warn(`Service ${serviceName} is unhealthy:`, details);
      }
      
    } catch (error) {
      const healthData = {
        healthy: false,
        responseTime: Date.now() - Date.now(),
        lastCheck: new Date().toISOString(),
        error: error.message,
        critical: config.critical,
      };
      
      this.healthStatus.set(serviceName, healthData);
      metrics.updateServiceHealth(serviceName, false);
      
      if (config.critical) {
        logger.error(`Critical service ${serviceName} health check failed:`, error.message);
      } else {
        logger.warn(`Service ${serviceName} health check failed:`, error.message);
      }
    }
  }

  /**
   * Check Redis health
   */
  async checkRedis() {
    try {
      const startTime = Date.now();
      await redisClient.ping();
      const responseTime = Date.now() - startTime;
      
      // Get Redis info
      const info = await redisClient.info();
      const memoryUsage = await redisClient.memory('usage');
      
      return {
        healthy: true,
        details: {
          responseTime,
          connected: true,
          memoryUsage,
          info: info.split('\r\n').slice(0, 5).join('\n'), // First few lines
        },
      };
    } catch (error) {
      return {
        healthy: false,
        details: {
          error: error.message,
          connected: false,
        },
      };
    }
  }

  /**
   * Check database health
   */
  async checkDatabase() {
    try {
      // This would typically check your database connection
      // For now, we'll simulate a database check
      const startTime = Date.now();
      
      // Simulate database query
      await new Promise(resolve => setTimeout(resolve, 10));
      
      const responseTime = Date.now() - startTime;
      
      return {
        healthy: true,
        details: {
          responseTime,
          connected: true,
          // Add actual database metrics here
        },
      };
    } catch (error) {
      return {
        healthy: false,
        details: {
          error: error.message,
          connected: false,
        },
      };
    }
  }

  /**
   * Update overall health status
   */
  updateOverallHealth() {
    const services = Array.from(this.healthStatus.values());
    const criticalServices = services.filter(s => s.critical);
    const unhealthyCritical = criticalServices.filter(s => !s.healthy);
    
    const overallHealth = {
      healthy: unhealthyCritical.length === 0,
      totalServices: services.length,
      healthyServices: services.filter(s => s.healthy).length,
      criticalServices: criticalServices.length,
      unhealthyCriticalServices: unhealthyCritical.length,
      lastUpdate: new Date().toISOString(),
    };
    
    this.healthStatus.set('_overall', overallHealth);
  }

  /**
   * Get health status for a specific service
   */
  getServiceHealth(serviceName) {
    return this.healthStatus.get(serviceName) || {
      healthy: false,
      error: 'Service not found',
    };
  }

  /**
   * Get overall health status
   */
  getOverallHealth() {
    return this.healthStatus.get('_overall') || {
      healthy: false,
      error: 'Health status not initialized',
    };
  }

  /**
   * Get all health statuses
   */
  getAllHealthStatuses() {
    const statuses = {};
    this.healthStatus.forEach((status, serviceName) => {
      statuses[serviceName] = status;
    });
    return statuses;
  }

  /**
   * Health check endpoint handler
   */
  getHealthHandler() {
    return (req, res) => {
      const overall = this.getOverallHealth();
      const detailed = req.query.detailed === 'true';
      
      const response = {
        status: overall.healthy ? 'healthy' : 'unhealthy',
        timestamp: new Date().toISOString(),
        service: 'KaziApp API Gateway',
        version: process.env.npm_package_version || '1.0.0',
        uptime: process.uptime(),
        ...overall,
      };
      
      if (detailed) {
        response.services = this.getAllHealthStatuses();
      }
      
      const statusCode = overall.healthy ? 200 : 503;
      res.status(statusCode).json(response);
    };
  }

  /**
   * Readiness check endpoint handler
   */
  getReadinessHandler() {
    return (req, res) => {
      const overall = this.getOverallHealth();
      const criticalServicesHealthy = overall.unhealthyCriticalServices === 0;
      
      const response = {
        ready: criticalServicesHealthy,
        timestamp: new Date().toISOString(),
        criticalServices: overall.criticalServices,
        unhealthyCriticalServices: overall.unhealthyCriticalServices,
      };
      
      const statusCode = criticalServicesHealthy ? 200 : 503;
      res.status(statusCode).json(response);
    };
  }

  /**
   * Liveness check endpoint handler
   */
  getLivenessHandler() {
    return (req, res) => {
      // Simple liveness check - just verify the process is running
      res.status(200).json({
        alive: true,
        timestamp: new Date().toISOString(),
        pid: process.pid,
        uptime: process.uptime(),
        memoryUsage: process.memoryUsage(),
      });
    };
  }

  /**
   * Force health check for a specific service
   */
  async forceHealthCheck(serviceName) {
    const config = this.services[serviceName];
    if (!config) {
      throw new Error(`Service ${serviceName} not found`);
    }
    
    await this.checkService(serviceName, config);
    return this.getServiceHealth(serviceName);
  }

  /**
   * Add custom service for health checking
   */
  addService(serviceName, config) {
    this.services[serviceName] = config;
    logger.info(`Added health check for service: ${serviceName}`);
  }

  /**
   * Remove service from health checking
   */
  removeService(serviceName) {
    delete this.services[serviceName];
    this.healthStatus.delete(serviceName);
    logger.info(`Removed health check for service: ${serviceName}`);
  }
}

const healthChecker = new HealthChecker();

module.exports = healthChecker;
module.exports.HealthChecker = HealthChecker;

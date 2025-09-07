const promClient = require('prom-client');
const logger = require('./logger');
const redisClient = require('../config/redis');

/**
 * Metrics collection and monitoring utility
 */
class MetricsCollector {
  constructor() {
    this.register = new promClient.Registry();
    this.initializeMetrics();
    this.setupDefaultMetrics();
  }

  /**
   * Initialize custom metrics
   */
  initializeMetrics() {
    // HTTP request metrics
    this.httpRequestDuration = new promClient.Histogram({
      name: 'http_request_duration_seconds',
      help: 'Duration of HTTP requests in seconds',
      labelNames: ['method', 'route', 'status_code', 'user_type'],
      buckets: [0.1, 0.3, 0.5, 0.7, 1, 3, 5, 7, 10],
    });

    this.httpRequestTotal = new promClient.Counter({
      name: 'http_requests_total',
      help: 'Total number of HTTP requests',
      labelNames: ['method', 'route', 'status_code', 'user_type'],
    });

    // Rate limiting metrics
    this.rateLimitHits = new promClient.Counter({
      name: 'rate_limit_hits_total',
      help: 'Total number of rate limit hits',
      labelNames: ['endpoint', 'user_type', 'limit_type'],
    });

    // Authentication metrics
    this.authAttempts = new promClient.Counter({
      name: 'auth_attempts_total',
      help: 'Total number of authentication attempts',
      labelNames: ['type', 'status', 'user_type'],
    });

    // Circuit breaker metrics
    this.circuitBreakerState = new promClient.Gauge({
      name: 'circuit_breaker_state',
      help: 'Circuit breaker state (0=closed, 1=half-open, 2=open)',
      labelNames: ['service'],
    });

    this.circuitBreakerFailures = new promClient.Counter({
      name: 'circuit_breaker_failures_total',
      help: 'Total number of circuit breaker failures',
      labelNames: ['service'],
    });

    // Service health metrics
    this.serviceHealth = new promClient.Gauge({
      name: 'service_health_status',
      help: 'Service health status (1=healthy, 0=unhealthy)',
      labelNames: ['service'],
    });

    // Business metrics
    this.activeUsers = new promClient.Gauge({
      name: 'active_users_total',
      help: 'Total number of active users',
      labelNames: ['user_type'],
    });

    this.apiKeyUsage = new promClient.Counter({
      name: 'api_key_usage_total',
      help: 'Total API key usage',
      labelNames: ['key_name', 'endpoint'],
    });

    // Error metrics
    this.errorRate = new promClient.Counter({
      name: 'errors_total',
      help: 'Total number of errors',
      labelNames: ['type', 'service', 'severity'],
    });

    // Register all metrics
    this.register.registerMetric(this.httpRequestDuration);
    this.register.registerMetric(this.httpRequestTotal);
    this.register.registerMetric(this.rateLimitHits);
    this.register.registerMetric(this.authAttempts);
    this.register.registerMetric(this.circuitBreakerState);
    this.register.registerMetric(this.circuitBreakerFailures);
    this.register.registerMetric(this.serviceHealth);
    this.register.registerMetric(this.activeUsers);
    this.register.registerMetric(this.apiKeyUsage);
    this.register.registerMetric(this.errorRate);
  }

  /**
   * Setup default Node.js metrics
   */
  setupDefaultMetrics() {
    promClient.collectDefaultMetrics({
      register: this.register,
      prefix: 'kaziapp_gateway_',
    });
  }

  /**
   * Middleware to collect HTTP metrics
   */
  collectMetrics() {
    return (req, res, next) => {
      const startTime = Date.now();
      
      // Capture response finish event
      res.on('finish', () => {
        const duration = (Date.now() - startTime) / 1000;
        const route = this.normalizeRoute(req.route?.path || req.path);
        const userType = req.user?.type || 'anonymous';
        
        // Record metrics
        this.httpRequestDuration
          .labels(req.method, route, res.statusCode.toString(), userType)
          .observe(duration);
        
        this.httpRequestTotal
          .labels(req.method, route, res.statusCode.toString(), userType)
          .inc();

        // Record API key usage
        if (req.headers['x-api-key']) {
          const keyName = req.apiKey?.name || 'unknown';
          this.apiKeyUsage
            .labels(keyName, route)
            .inc();
        }

        // Record errors
        if (res.statusCode >= 400) {
          const severity = res.statusCode >= 500 ? 'error' : 'warning';
          this.errorRate
            .labels('http_error', 'api-gateway', severity)
            .inc();
        }
      });

      next();
    };
  }

  /**
   * Normalize route for consistent metrics
   */
  normalizeRoute(path) {
    return path
      .replace(/\/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/gi, '/:id')
      .replace(/\/\d+/g, '/:id')
      .replace(/\/[^\/]+@[^\/]+/g, '/:email');
  }

  /**
   * Record authentication attempt
   */
  recordAuthAttempt(type, status, userType = 'unknown') {
    this.authAttempts
      .labels(type, status, userType)
      .inc();
  }

  /**
   * Record rate limit hit
   */
  recordRateLimitHit(endpoint, userType, limitType) {
    this.rateLimitHits
      .labels(endpoint, userType, limitType)
      .inc();
  }

  /**
   * Update circuit breaker state
   */
  updateCircuitBreakerState(service, state) {
    const stateValue = { 'CLOSED': 0, 'HALF_OPEN': 1, 'OPEN': 2 }[state] || 0;
    this.circuitBreakerState
      .labels(service)
      .set(stateValue);
  }

  /**
   * Record circuit breaker failure
   */
  recordCircuitBreakerFailure(service) {
    this.circuitBreakerFailures
      .labels(service)
      .inc();
  }

  /**
   * Update service health status
   */
  updateServiceHealth(service, isHealthy) {
    this.serviceHealth
      .labels(service)
      .set(isHealthy ? 1 : 0);
  }

  /**
   * Update active users count
   */
  async updateActiveUsers() {
    try {
      const userTypes = ['farmer', 'veterinarian', 'buyer', 'vendor', 'admin'];
      
      for (const userType of userTypes) {
        const count = await this.getActiveUserCount(userType);
        this.activeUsers
          .labels(userType)
          .set(count);
      }
    } catch (error) {
      logger.error('Error updating active users metrics:', error);
    }
  }

  /**
   * Get active user count from Redis
   */
  async getActiveUserCount(userType) {
    try {
      const keys = await redisClient.keys(`user_session:*`);
      let count = 0;
      
      for (const key of keys) {
        const sessionData = await redisClient.get(key);
        if (sessionData) {
          const session = JSON.parse(sessionData);
          if (session.userType === userType) {
            count++;
          }
        }
      }
      
      return count;
    } catch (error) {
      logger.error(`Error getting active user count for ${userType}:`, error);
      return 0;
    }
  }

  /**
   * Record custom error
   */
  recordError(type, service, severity = 'error') {
    this.errorRate
      .labels(type, service, severity)
      .inc();
  }

  /**
   * Get metrics endpoint handler
   */
  getMetricsHandler() {
    return async (req, res) => {
      try {
        // Update dynamic metrics before serving
        await this.updateActiveUsers();
        
        res.set('Content-Type', this.register.contentType);
        res.end(await this.register.metrics());
      } catch (error) {
        logger.error('Error serving metrics:', error);
        res.status(500).send('Error generating metrics');
      }
    };
  }

  /**
   * Get metrics summary for dashboard
   */
  async getMetricsSummary() {
    try {
      const metrics = await this.register.getMetricsAsJSON();
      
      const summary = {
        timestamp: new Date().toISOString(),
        totalRequests: this.getTotalRequests(metrics),
        errorRate: this.getErrorRate(metrics),
        averageResponseTime: this.getAverageResponseTime(metrics),
        activeUsers: this.getActiveUsersCount(metrics),
        circuitBreakerStatus: this.getCircuitBreakerStatus(metrics),
        serviceHealth: this.getServiceHealthStatus(metrics),
      };
      
      return summary;
    } catch (error) {
      logger.error('Error getting metrics summary:', error);
      return null;
    }
  }

  /**
   * Helper methods for metrics summary
   */
  getTotalRequests(metrics) {
    const requestMetric = metrics.find(m => m.name === 'http_requests_total');
    return requestMetric ? requestMetric.values.reduce((sum, v) => sum + v.value, 0) : 0;
  }

  getErrorRate(metrics) {
    const errorMetric = metrics.find(m => m.name === 'errors_total');
    const totalRequests = this.getTotalRequests(metrics);
    
    if (!errorMetric || totalRequests === 0) return 0;
    
    const totalErrors = errorMetric.values.reduce((sum, v) => sum + v.value, 0);
    return ((totalErrors / totalRequests) * 100).toFixed(2);
  }

  getAverageResponseTime(metrics) {
    const durationMetric = metrics.find(m => m.name === 'http_request_duration_seconds');
    if (!durationMetric) return 0;
    
    const buckets = durationMetric.values.filter(v => v.labels.le);
    if (buckets.length === 0) return 0;
    
    // Simple approximation of average from histogram buckets
    return buckets[Math.floor(buckets.length / 2)]?.labels.le || 0;
  }

  getActiveUsersCount(metrics) {
    const activeUsersMetric = metrics.find(m => m.name === 'active_users_total');
    return activeUsersMetric ? 
      activeUsersMetric.values.reduce((sum, v) => sum + v.value, 0) : 0;
  }

  getCircuitBreakerStatus(metrics) {
    const cbMetric = metrics.find(m => m.name === 'circuit_breaker_state');
    if (!cbMetric) return {};
    
    const status = {};
    cbMetric.values.forEach(v => {
      const state = ['CLOSED', 'HALF_OPEN', 'OPEN'][v.value] || 'UNKNOWN';
      status[v.labels.service] = state;
    });
    
    return status;
  }

  getServiceHealthStatus(metrics) {
    const healthMetric = metrics.find(m => m.name === 'service_health_status');
    if (!healthMetric) return {};
    
    const status = {};
    healthMetric.values.forEach(v => {
      status[v.labels.service] = v.value === 1 ? 'healthy' : 'unhealthy';
    });
    
    return status;
  }
}

const metricsCollector = new MetricsCollector();

module.exports = metricsCollector;
module.exports.MetricsCollector = MetricsCollector;

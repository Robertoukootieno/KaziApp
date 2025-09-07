const promClient = require('prom-client');

// Create a Registry to register the metrics
const register = new promClient.Registry();

// Add default metrics
promClient.collectDefaultMetrics({
  register,
  prefix: 'kaziapp_auth_',
});

// Custom metrics
const httpRequestDuration = new promClient.Histogram({
  name: 'kaziapp_auth_http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status_code'],
  buckets: [0.1, 0.3, 0.5, 0.7, 1, 3, 5, 7, 10],
});

const httpRequestTotal = new promClient.Counter({
  name: 'kaziapp_auth_http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code'],
});

const authenticationAttempts = new promClient.Counter({
  name: 'kaziapp_auth_authentication_attempts_total',
  help: 'Total number of authentication attempts',
  labelNames: ['client_type', 'result'],
});

const activeUsers = new promClient.Gauge({
  name: 'kaziapp_auth_active_users',
  help: 'Number of currently active users',
  labelNames: ['client_type'],
});

const tokenOperations = new promClient.Counter({
  name: 'kaziapp_auth_token_operations_total',
  help: 'Total number of token operations',
  labelNames: ['operation', 'result'],
});

// Register custom metrics
register.registerMetric(httpRequestDuration);
register.registerMetric(httpRequestTotal);
register.registerMetric(authenticationAttempts);
register.registerMetric(activeUsers);
register.registerMetric(tokenOperations);

// Middleware to collect HTTP metrics
const collectMetrics = (req, res, next) => {
  const start = Date.now();
  
  res.on('finish', () => {
    const duration = (Date.now() - start) / 1000;
    const route = req.route ? req.route.path : req.path;
    
    httpRequestDuration
      .labels(req.method, route, res.statusCode)
      .observe(duration);
    
    httpRequestTotal
      .labels(req.method, route, res.statusCode)
      .inc();
  });
  
  next();
};

// Function to record authentication attempts
const recordAuthAttempt = (clientType, success) => {
  authenticationAttempts
    .labels(clientType, success ? 'success' : 'failure')
    .inc();
};

// Function to record token operations
const recordTokenOperation = (operation, success) => {
  tokenOperations
    .labels(operation, success ? 'success' : 'failure')
    .inc();
};

// Function to update active users
const updateActiveUsers = (clientType, count) => {
  activeUsers
    .labels(clientType)
    .set(count);
};

// Metrics endpoint handler
const getMetricsHandler = () => {
  return async (req, res) => {
    try {
      res.set('Content-Type', register.contentType);
      const metrics = await register.metrics();
      res.end(metrics);
    } catch (error) {
      res.status(500).end(error.message);
    }
  };
};

module.exports = {
  register,
  collectMetrics,
  recordAuthAttempt,
  recordTokenOperation,
  updateActiveUsers,
  getMetricsHandler,
};

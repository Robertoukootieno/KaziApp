const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const morgan = require('morgan');
const compression = require('compression');
const rateLimit = require('express-rate-limit');
const slowDown = require('express-slow-down');
const { createProxyMiddleware } = require('http-proxy-middleware');
const swaggerUi = require('swagger-ui-express');
const swaggerJsdoc = require('swagger-jsdoc');
const fs = require('fs');
const https = require('https');
const http = require('http');
const cluster = require('cluster');
const os = require('os');
require('dotenv').config();

const authMiddleware = require('./middleware/auth');
const securityMiddleware = require('./middleware/security');
const rateLimitMiddleware = require('./middleware/rateLimit');
const requestValidation = require('./middleware/requestValidation');
const circuitBreaker = require('./middleware/circuitBreaker');
const errorHandler = require('./middleware/errorHandler');
const logger = require('./utils/logger');
const redisClient = require('./config/redis');
const routes = require('./routes');
const healthCheck = require('./utils/healthCheck');
const metrics = require('./utils/metrics');

// Cluster setup for production
if (cluster.isMaster && process.env.NODE_ENV === 'production') {
  const numCPUs = os.cpus().length;
  logger.info(`Master ${process.pid} is running`);

  // Fork workers
  for (let i = 0; i < numCPUs; i++) {
    cluster.fork();
  }

  cluster.on('exit', (worker, code, signal) => {
    logger.error(`Worker ${worker.process.pid} died`);
    cluster.fork();
  });
} else {
  // Worker process
  const app = express();
  const PORT = process.env.PORT || 3000;
  const HTTPS_PORT = process.env.HTTPS_PORT || 3443;

// Swagger configuration
const swaggerOptions = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'KaziApp API Gateway',
      version: '1.0.0',
      description: 'Africa-First Agricultural Platform API Gateway',
    },
    servers: [
      {
        url: `http://localhost:${PORT}`,
        description: 'Development server',
      },
    ],
  },
  apis: ['./src/routes/*.js'],
};

const specs = swaggerJsdoc(swaggerOptions);

// Enhanced rate limiting with Redis store
const createRateLimiter = (windowMs, max, message) => {
  return rateLimit({
    store: new (require('rate-limit-redis'))({
      sendCommand: (...args) => redisClient.call(...args),
    }),
    windowMs,
    max,
    message: {
      error: message,
      retryAfter: Math.ceil(windowMs / 1000),
      timestamp: new Date().toISOString(),
    },
    standardHeaders: true,
    legacyHeaders: false,
    keyGenerator: (req) => {
      // Use user ID if authenticated, otherwise IP
      return req.user?.id || req.ip;
    },
  });
};

// Different rate limits for different endpoints
const generalLimiter = createRateLimiter(15 * 60 * 1000, 1000, 'Too many requests');
const authLimiter = createRateLimiter(15 * 60 * 1000, 10, 'Too many authentication attempts');
const apiLimiter = createRateLimiter(15 * 60 * 1000, 500, 'API rate limit exceeded');

// Speed limiter for suspicious activity
const speedLimiter = slowDown({
  windowMs: 15 * 60 * 1000,
  delayAfter: 100,
  delayMs: 500,
  maxDelayMs: 20000,
});

// Enhanced security middleware
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      scriptSrc: ["'self'"],
      imgSrc: ["'self'", "data:", "https:"],
    },
  },
  hsts: {
    maxAge: 31536000,
    includeSubDomains: true,
    preload: true,
  },
}));

app.use(compression());

// Enhanced CORS configuration
app.use(cors({
  origin: (origin, callback) => {
    const allowedOrigins = process.env.ALLOWED_ORIGINS?.split(',') || [
      'http://localhost:3000',  // Farmer app
      'http://localhost:3001',  // Service provider app
      'http://localhost:3002',  // Admin dashboard
      'https://kaziapp.com',    // Production domain
    ];

    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  },
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With', 'X-API-Key'],
}));

// Request logging with correlation ID
app.use((req, res, next) => {
  req.correlationId = req.headers['x-correlation-id'] || require('uuid').v4();
  res.setHeader('X-Correlation-ID', req.correlationId);
  next();
});

app.use(morgan('combined', {
  stream: {
    write: message => logger.info(message.trim(), { correlationId: 'gateway' })
  }
}));

// Body parsing with security
app.use(express.json({
  limit: '10mb',
  verify: (req, res, buf) => {
    req.rawBody = buf;
  }
}));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Apply rate limiting
app.use(generalLimiter);
app.use(speedLimiter);

// Security middleware
app.use(securityMiddleware);

// Request validation
app.use(requestValidation);

// Metrics collection
app.use(metrics.collectMetrics);

// API Documentation
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(specs));

// Enhanced health checks
app.get('/health', healthCheck.getHealthHandler());
app.get('/health/ready', healthCheck.getReadinessHandler());
app.get('/health/live', healthCheck.getLivenessHandler());

// Metrics endpoint
app.get('/metrics', metrics.getMetricsHandler());

// Admin endpoints for monitoring
app.get('/admin/circuit-breakers', authMiddleware, async (req, res) => {
  if (req.user.type !== 'admin') {
    return res.status(403).json({ error: 'Admin access required' });
  }

  const stats = await circuitBreaker.getStatistics();
  res.json(stats);
});

app.post('/admin/circuit-breakers/:service/reset', authMiddleware, async (req, res) => {
  if (req.user.type !== 'admin') {
    return res.status(403).json({ error: 'Admin access required' });
  }

  const { service } = req.params;
  const success = await circuitBreaker.resetCircuit(service);

  if (success) {
    res.json({ message: `Circuit breaker for ${service} reset successfully` });
  } else {
    res.status(500).json({ error: 'Failed to reset circuit breaker' });
  }
});

// API Routes
app.use('/api', routes);

// Service Proxies with authentication
const serviceProxies = {
  '/api/users': {
    target: process.env.USER_SERVICE_URL || 'http://user-service:3000',
    pathRewrite: { '^/api/users': '' },
  },
  '/api/matching': {
    target: process.env.MATCHING_SERVICE_URL || 'http://matching-service:3000',
    pathRewrite: { '^/api/matching': '' },
  },
  '/api/communication': {
    target: process.env.COMMUNICATION_SERVICE_URL || 'http://communication:3000',
    pathRewrite: { '^/api/communication': '' },
  },
  '/api/ai-diagnostics': {
    target: process.env.AI_DIAGNOSTICS_SERVICE_URL || 'http://ai-diagnostics:3000',
    pathRewrite: { '^/api/ai-diagnostics': '' },
  },
  '/api/marketplace': {
    target: process.env.MARKETPLACE_SERVICE_URL || 'http://marketplace:3000',
    pathRewrite: { '^/api/marketplace': '' },
  },
  '/api/farm-management': {
    target: process.env.FARM_MANAGEMENT_SERVICE_URL || 'http://farm-management:3000',
    pathRewrite: { '^/api/farm-management': '' },
  },
  '/api/payments': {
    target: process.env.PAYMENT_SERVICE_URL || 'http://payment-service:3000',
    pathRewrite: { '^/api/payments': '' },
  },
  '/api/notifications': {
    target: process.env.NOTIFICATION_SERVICE_URL || 'http://notification:3000',
    pathRewrite: { '^/api/notifications': '' },
  },
  '/api/community': {
    target: process.env.COMMUNITY_SERVICE_URL || 'http://community:3000',
    pathRewrite: { '^/api/community': '' },
  },
};

// Enhanced proxy setup with circuit breaker and monitoring
Object.entries(serviceProxies).forEach(([path, config]) => {
  const proxy = createProxyMiddleware({
    target: config.target,
    changeOrigin: true,
    pathRewrite: config.pathRewrite,
    timeout: 30000, // 30 second timeout
    proxyTimeout: 30000,
    onProxyReq: (proxyReq, req, res) => {
      // Add comprehensive headers for service communication
      if (req.user) {
        proxyReq.setHeader('X-User-ID', req.user.id);
        proxyReq.setHeader('X-User-Type', req.user.type);
        proxyReq.setHeader('X-User-Phone', req.user.phoneNumber);
        proxyReq.setHeader('X-User-County', req.user.county);
      }

      // Add correlation ID for distributed tracing
      proxyReq.setHeader('X-Correlation-ID', req.correlationId);
      proxyReq.setHeader('X-Request-ID', req.headers['x-request-id'] || require('uuid').v4());
      proxyReq.setHeader('X-Forwarded-For', req.ip);
      proxyReq.setHeader('X-Gateway-Version', process.env.npm_package_version || '1.0.0');

      // Add API key info if present
      if (req.apiKey) {
        proxyReq.setHeader('X-API-Key-Name', req.apiKey.name);
        proxyReq.setHeader('X-API-Key-Permissions', JSON.stringify(req.apiKey.permissions));
      }

      // Add timestamp for request tracking
      proxyReq.setHeader('X-Gateway-Timestamp', new Date().toISOString());
    },
    onProxyRes: (proxyRes, req, res) => {
      // Add response headers
      proxyRes.headers['X-Served-By'] = 'KaziApp-Gateway';
      proxyRes.headers['X-Response-Time'] = Date.now() - req.startTime;
    },
    onError: (err, req, res) => {
      const service = path.replace('/api/', '');
      logger.error(`Proxy error for ${path}:`, {
        error: err.message,
        service,
        correlationId: req.correlationId,
        userAgent: req.headers['user-agent'],
      });

      // Record circuit breaker failure
      if (req.circuitBreaker) {
        req.circuitBreaker.recordFailure();
      }

      // Return appropriate error response
      if (!res.headersSent) {
        res.status(503).json({
          success: false,
          error: 'Service temporarily unavailable',
          service: path,
          correlationId: req.correlationId,
          timestamp: new Date().toISOString(),
          retryAfter: 30,
        });
      }
    },
  });

  // Apply middleware stack based on path sensitivity
  const middlewareStack = [circuitBreaker];

  // Authentication for protected routes
  const protectedPaths = [
    '/api/users/profile',
    '/api/matching',
    '/api/communication',
    '/api/marketplace',
    '/api/farm-management',
    '/api/payments',
    '/api/community',
  ];

  if (protectedPaths.some(protectedPath => path.startsWith(protectedPath))) {
    middlewareStack.push(authMiddleware);
  }

  // Apply rate limiting based on endpoint
  if (path.startsWith('/api/auth')) {
    middlewareStack.push(authLimiter);
  } else if (path.startsWith('/api/payments')) {
    middlewareStack.push(createRateLimiter(15 * 60 * 1000, 100, 'Payment API rate limit exceeded'));
  } else {
    middlewareStack.push(apiLimiter);
  }

  // Add the proxy as the final middleware
  middlewareStack.push(proxy);

  // Apply all middleware to the path
  app.use(path, ...middlewareStack);
});

// Error handling
app.use((req, res) => {
  res.status(404).json({
    error: 'Route not found',
    path: req.path,
    method: req.method,
    timestamp: new Date().toISOString(),
  });
});

app.use(errorHandler);

// Graceful shutdown
const gracefulShutdown = (signal) => {
  logger.info(`Received ${signal}, shutting down gracefully`);
  server.close(() => {
    logger.info('HTTP server closed');
    redisClient.quit(() => {
      logger.info('Redis connection closed');
      process.exit(0);
    });
  });
};

process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
process.on('SIGINT', () => gracefulShutdown('SIGINT'));

// TLS/HTTPS setup for production
let server;

if (process.env.NODE_ENV === 'production' && process.env.TLS_CERT && process.env.TLS_KEY) {
  const tlsOptions = {
    cert: fs.readFileSync(process.env.TLS_CERT),
    key: fs.readFileSync(process.env.TLS_KEY),
  };

  // HTTPS server
  server = https.createServer(tlsOptions, app).listen(HTTPS_PORT, () => {
    logger.info(`KaziApp API Gateway (HTTPS) running on port ${HTTPS_PORT}`);
    logger.info(`Environment: ${process.env.NODE_ENV}`);
    logger.info(`API Documentation: https://localhost:${HTTPS_PORT}/api-docs`);
  });

  // HTTP redirect server
  const redirectApp = express();
  redirectApp.use((req, res) => {
    res.redirect(301, `https://${req.headers.host}${req.url}`);
  });

  http.createServer(redirectApp).listen(PORT, () => {
    logger.info(`HTTP redirect server running on port ${PORT}`);
  });
} else {
  // HTTP server for development
  server = http.createServer(app).listen(PORT, () => {
    logger.info(`KaziApp API Gateway (HTTP) running on port ${PORT}`);
    logger.info(`Environment: ${process.env.NODE_ENV || 'development'}`);
    logger.info(`API Documentation: http://localhost:${PORT}/api-docs`);
    logger.info(`Health Check: http://localhost:${PORT}/health`);
    logger.info(`Metrics: http://localhost:${PORT}/metrics`);
  });
}

module.exports = app;

} // End of worker process

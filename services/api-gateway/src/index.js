const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const morgan = require('morgan');
const compression = require('compression');
const rateLimit = require('express-rate-limit');
const { createProxyMiddleware } = require('http-proxy-middleware');
const swaggerUi = require('swagger-ui-express');
const swaggerJsdoc = require('swagger-jsdoc');
require('dotenv').config();

const authMiddleware = require('./middleware/auth');
const errorHandler = require('./middleware/errorHandler');
const logger = require('./utils/logger');
const redisClient = require('./config/redis');
const routes = require('./routes');

const app = express();
const PORT = process.env.PORT || 3000;

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

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
  message: 'Too many requests from this IP, please try again later.',
  standardHeaders: true,
  legacyHeaders: false,
});

// Middleware
app.use(helmet());
app.use(compression());
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || ['http://localhost:3010'],
  credentials: true,
}));
app.use(morgan('combined', { stream: { write: message => logger.info(message.trim()) } }));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));
app.use(limiter);

// API Documentation
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(specs));

// Health check
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'OK',
    timestamp: new Date().toISOString(),
    service: 'KaziApp API Gateway',
    version: process.env.npm_package_version || '1.0.0',
    uptime: process.uptime(),
  });
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

// Setup proxies with authentication middleware
Object.entries(serviceProxies).forEach(([path, config]) => {
  const proxy = createProxyMiddleware({
    target: config.target,
    changeOrigin: true,
    pathRewrite: config.pathRewrite,
    onProxyReq: (proxyReq, req, res) => {
      // Add user context to proxied requests
      if (req.user) {
        proxyReq.setHeader('X-User-ID', req.user.id);
        proxyReq.setHeader('X-User-Type', req.user.type);
        proxyReq.setHeader('X-User-Phone', req.user.phoneNumber);
      }
      
      // Add request ID for tracing
      proxyReq.setHeader('X-Request-ID', req.headers['x-request-id'] || require('uuid').v4());
    },
    onError: (err, req, res) => {
      logger.error(`Proxy error for ${path}:`, err);
      res.status(503).json({
        error: 'Service temporarily unavailable',
        service: path,
        timestamp: new Date().toISOString(),
      });
    },
  });

  // Apply authentication middleware to protected routes
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
    app.use(path, authMiddleware, proxy);
  } else {
    app.use(path, proxy);
  }
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

const server = app.listen(PORT, () => {
  logger.info(`KaziApp API Gateway running on port ${PORT}`);
  logger.info(`Environment: ${process.env.NODE_ENV || 'development'}`);
  logger.info(`API Documentation: http://localhost:${PORT}/api-docs`);
});

module.exports = app;

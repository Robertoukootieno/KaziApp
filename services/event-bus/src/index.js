const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const morgan = require('morgan');
const compression = require('compression');
require('dotenv').config();

const logger = require('./utils/logger');
const redisClient = require('./config/redis');
const EventBus = require('./core/EventBus');
const EventStore = require('./core/EventStore');
const routes = require('./routes');
const metrics = require('./utils/metrics');

const app = express();
const PORT = process.env.PORT || 3200;

// Initialize event bus and event store
const eventBus = new EventBus(redisClient);
const eventStore = new EventStore(redisClient);

// Middleware
app.use(helmet());
app.use(compression());
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || [
    'http://localhost:3000',  // API Gateway
    'http://localhost:3010',  // Farmer BFF
    'http://localhost:3011',  // Provider BFF
    'http://localhost:3012',  // Admin BFF
    'http://localhost:3100',  // Auth Service
  ],
  credentials: true,
}));

app.use(morgan('combined', { 
  stream: { 
    write: message => logger.info(message.trim())
  }
}));

app.use(express.json({ limit: '1mb' }));
app.use(express.urlencoded({ extended: true, limit: '1mb' }));

// Metrics collection
app.use(metrics.collectMetrics);

// Make event bus and store available to routes
app.locals.eventBus = eventBus;
app.locals.eventStore = eventStore;

// Health check
app.get('/health', async (req, res) => {
  try {
    // Check Redis connection
    await redisClient.ping();
    
    // Check event bus health
    const busHealth = await eventBus.healthCheck();
    
    res.status(200).json({
      status: 'OK',
      service: 'KaziApp Event Bus',
      timestamp: new Date().toISOString(),
      version: process.env.npm_package_version || '1.0.0',
      uptime: process.uptime(),
      redis: 'connected',
      eventBus: busHealth,
    });
  } catch (error) {
    logger.error('Health check failed:', error);
    res.status(503).json({
      status: 'UNHEALTHY',
      service: 'KaziApp Event Bus',
      timestamp: new Date().toISOString(),
      error: error.message,
    });
  }
});

// Metrics endpoint
app.get('/metrics', metrics.getMetricsHandler());

// API Routes
app.use('/events', routes.events);
app.use('/streams', routes.streams);
app.use('/admin', routes.admin);

// Error handling
app.use((req, res) => {
  res.status(404).json({
    success: false,
    error: 'Endpoint not found',
    path: req.path,
    method: req.method,
    timestamp: new Date().toISOString(),
  });
});

app.use((error, req, res, next) => {
  logger.error('Unhandled error:', error);
  res.status(500).json({
    success: false,
    error: 'Internal server error',
    timestamp: new Date().toISOString(),
  });
});

// Initialize and start server
async function startServer() {
  try {
    // Test Redis connection
    await redisClient.ping();
    logger.info('Redis connection established successfully');
    
    // Initialize event bus
    await eventBus.initialize();
    logger.info('Event bus initialized successfully');
    
    // Initialize event store
    await eventStore.initialize();
    logger.info('Event store initialized successfully');
    
    // Start server
    const server = app.listen(PORT, () => {
      logger.info(`KaziApp Event Bus running on port ${PORT}`);
      logger.info(`Environment: ${process.env.NODE_ENV || 'development'}`);
    });

    // Graceful shutdown
    const gracefulShutdown = (signal) => {
      logger.info(`Received ${signal}, shutting down gracefully`);
      server.close(async () => {
        logger.info('HTTP server closed');
        
        try {
          await eventBus.shutdown();
          logger.info('Event bus shutdown complete');
          
          await redisClient.quit();
          logger.info('Redis connection closed');
          
          process.exit(0);
        } catch (error) {
          logger.error('Error during shutdown:', error);
          process.exit(1);
        }
      });
    };

    process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
    process.on('SIGINT', () => gracefulShutdown('SIGINT'));
    
  } catch (error) {
    logger.error('Failed to start server:', error);
    process.exit(1);
  }
}

// Start the server
startServer();

module.exports = app;

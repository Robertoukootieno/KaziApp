const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const morgan = require('morgan');
const compression = require('compression');
require('dotenv').config();

const logger = require('./utils/logger');
const redisClient = require('./config/redis');
const mongoClient = require('./config/mongodb');
const elasticsearchClient = require('./config/elasticsearch');
const routes = require('./routes');
const metrics = require('./utils/metrics');

const app = express();
const PORT = process.env.PORT || 3700;

// Middleware
app.use(helmet());
app.use(compression());
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || [
    'http://localhost:3000',  // API Gateway
    'http://localhost:3010',  // Farmer BFF
    'http://localhost:3011',  // Provider BFF
    'http://localhost:3012',  // Admin BFF
  ],
  credentials: true,
}));

app.use(morgan('combined', { 
  stream: { 
    write: message => logger.info(message.trim())
  }
}));

app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Metrics collection
app.use(metrics.collectMetrics);

// Health check
app.get('/health', async (req, res) => {
  try {
    // Check Redis connection
    await redisClient.ping();
    
    // Check MongoDB connection
    const mongoStatus = mongoClient.readyState === 1 ? 'connected' : 'disconnected';
    
    // Check Elasticsearch connection
    const esHealth = await elasticsearchClient.ping();
    
    res.status(200).json({
      status: 'OK',
      service: 'KaziApp Catalog Service',
      timestamp: new Date().toISOString(),
      version: process.env.npm_package_version || '1.0.0',
      uptime: process.uptime(),
      dependencies: {
        redis: 'connected',
        mongodb: mongoStatus,
        elasticsearch: esHealth ? 'connected' : 'disconnected',
      },
    });
  } catch (error) {
    logger.error('Health check failed:', error);
    res.status(503).json({
      status: 'UNHEALTHY',
      service: 'KaziApp Catalog Service',
      timestamp: new Date().toISOString(),
      error: error.message,
    });
  }
});

// Metrics endpoint
app.get('/metrics', metrics.getMetricsHandler());

// API Routes
app.use('/categories', routes.categories);
app.use('/services', routes.services);
app.use('/products', routes.products);
app.use('/inventory', routes.inventory);
app.use('/pricing', routes.pricing);
app.use('/search', routes.search);

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
    // Test connections
    await redisClient.ping();
    logger.info('Redis connection established successfully');
    
    await mongoClient.connection.once('open', () => {
      logger.info('MongoDB connection established successfully');
    });
    
    try {
      await elasticsearchClient.ping();
      logger.info('Elasticsearch connection established successfully');
    } catch (error) {
      logger.warn('Elasticsearch connection failed, search functionality will be limited');
    }
    
    // Start server
    const server = app.listen(PORT, () => {
      logger.info(`KaziApp Catalog Service running on port ${PORT}`);
      logger.info(`Environment: ${process.env.NODE_ENV || 'development'}`);
    });

    // Graceful shutdown
    const gracefulShutdown = (signal) => {
      logger.info(`Received ${signal}, shutting down gracefully`);
      server.close(async () => {
        logger.info('HTTP server closed');
        
        try {
          await redisClient.quit();
          logger.info('Redis connection closed');
          
          await mongoClient.connection.close();
          logger.info('MongoDB connection closed');
          
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

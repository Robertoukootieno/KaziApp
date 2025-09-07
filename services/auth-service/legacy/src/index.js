const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const morgan = require('morgan');
const compression = require('compression');
const rateLimit = require('express-rate-limit');
const passport = require('passport');
require('dotenv').config();

const logger = require('./utils/logger');
const database = require('./config/database');
const redisClient = require('./config/redis');
const passportConfig = require('./config/passport');
const errorHandler = require('./middleware/errorHandler');
const routes = require('./routes');

const app = express();
const PORT = process.env.PORT || 3100;

// Rate limiting for auth service - stricter limits
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 20, // Strict limit for auth endpoints
  message: {
    error: 'Too many authentication attempts',
    retryAfter: 900,
    timestamp: new Date().toISOString(),
  },
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => {
    // Use IP + user agent for more specific rate limiting
    return `${req.ip}-${req.headers['user-agent']}`;
  },
});

// General rate limiter
const generalLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
  message: {
    error: 'Rate limit exceeded',
    retryAfter: 900,
    timestamp: new Date().toISOString(),
  },
});

// Middleware
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      scriptSrc: ["'self'"],
      imgSrc: ["'self'", "data:", "https:"],
    },
  },
}));

app.use(compression());
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || [
    'http://localhost:3000',  // API Gateway
    'http://localhost:3010',  // Farmer BFF
    'http://localhost:3011',  // Provider BFF
    'http://localhost:3012',  // Admin BFF
  ],
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With'],
}));

app.use(morgan('combined', { 
  stream: { 
    write: message => logger.info(message.trim())
  }
}));

app.use(express.json({ limit: '1mb' }));
app.use(express.urlencoded({ extended: true, limit: '1mb' }));

// Initialize Passport
app.use(passport.initialize());

// Apply rate limiting
app.use('/auth/login', authLimiter);
app.use('/auth/register', authLimiter);
app.use('/auth/forgot-password', authLimiter);
app.use('/auth/reset-password', authLimiter);
app.use('/auth/verify', authLimiter);
app.use(generalLimiter);

// Health check
app.get('/health', async (req, res) => {
  try {
    // Check database connection
    await database.authenticate();
    
    // Check Redis connection
    await redisClient.ping();
    
    res.status(200).json({
      status: 'OK',
      service: 'KaziApp Auth Service',
      timestamp: new Date().toISOString(),
      version: process.env.npm_package_version || '1.0.0',
      uptime: process.uptime(),
      database: 'connected',
      redis: 'connected',
    });
  } catch (error) {
    logger.error('Health check failed:', error);
    res.status(503).json({
      status: 'UNHEALTHY',
      service: 'KaziApp Auth Service',
      timestamp: new Date().toISOString(),
      error: error.message,
    });
  }
});

// API Routes
app.use('/auth', routes.auth);
app.use('/users', routes.users);
app.use('/admin', routes.admin);
app.use('/oauth', routes.oauth);

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

app.use(errorHandler);

// Initialize database and start server
async function startServer() {
  try {
    // Test database connection
    await database.authenticate();
    logger.info('Database connection established successfully');
    
    // Sync database models (in development)
    if (process.env.NODE_ENV === 'development') {
      await database.sync({ alter: true });
      logger.info('Database models synchronized');
    }
    
    // Test Redis connection
    await redisClient.ping();
    logger.info('Redis connection established successfully');
    
    // Start server
    const server = app.listen(PORT, () => {
      logger.info(`KaziApp Auth Service running on port ${PORT}`);
      logger.info(`Environment: ${process.env.NODE_ENV || 'development'}`);
    });

    // Graceful shutdown
    const gracefulShutdown = (signal) => {
      logger.info(`Received ${signal}, shutting down gracefully`);
      server.close(async () => {
        logger.info('HTTP server closed');
        
        try {
          await database.close();
          logger.info('Database connection closed');
          
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

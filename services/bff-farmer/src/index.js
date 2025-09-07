const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const morgan = require('morgan');
const compression = require('compression');
const rateLimit = require('express-rate-limit');
require('dotenv').config();

const logger = require('./utils/logger');
const authMiddleware = require('./middleware/auth');
const errorHandler = require('./middleware/errorHandler');
const routes = require('./routes');
const serviceClient = require('./services/serviceClient');

const app = express();
const PORT = process.env.PORT || 3010;

// Rate limiting for farmer BFF
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 500, // Higher limit for authenticated farmers
  message: {
    error: 'Too many requests from this device',
    retryAfter: 900,
    timestamp: new Date().toISOString(),
  },
  standardHeaders: true,
  legacyHeaders: false,
});

// Middleware
app.use(helmet());
app.use(compression());
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || [
    'http://localhost:3000',  // Farmer mobile app
    'https://farmer.kaziapp.com',
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
app.use(limiter);

// Health check
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'OK',
    service: 'KaziApp Farmer BFF',
    timestamp: new Date().toISOString(),
    version: process.env.npm_package_version || '1.0.0',
    uptime: process.uptime(),
  });
});

// Authentication middleware for protected routes
app.use('/api', authMiddleware);

// API Routes
app.use('/api', routes);

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

// Graceful shutdown
const gracefulShutdown = (signal) => {
  logger.info(`Received ${signal}, shutting down gracefully`);
  server.close(() => {
    logger.info('HTTP server closed');
    serviceClient.close();
    process.exit(0);
  });
};

process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
process.on('SIGINT', () => gracefulShutdown('SIGINT'));

const server = app.listen(PORT, () => {
  logger.info(`KaziApp Farmer BFF running on port ${PORT}`);
  logger.info(`Environment: ${process.env.NODE_ENV || 'development'}`);
});

module.exports = app;

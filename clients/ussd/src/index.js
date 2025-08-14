const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const compression = require('compression');
const rateLimit = require('rate-limiter-flexible');
require('dotenv').config();

const ussdController = require('./controllers/ussdController');
const smsController = require('./controllers/smsController');
const logger = require('./utils/logger');
const redisClient = require('./config/redis');
const { errorHandler, notFound } = require('./middleware/errorMiddleware');

const app = express();
const PORT = process.env.PORT || 3011;

// Rate limiting
const rateLimiter = new rateLimit.RateLimiterRedis({
  storeClient: redisClient,
  keyPrefix: 'ussd_rate_limit',
  points: 10, // Number of requests
  duration: 60, // Per 60 seconds
});

const rateLimiterMiddleware = async (req, res, next) => {
  try {
    const key = req.ip || req.connection.remoteAddress;
    await rateLimiter.consume(key);
    next();
  } catch (rejRes) {
    res.status(429).send('Too Many Requests');
  }
};

// Middleware
app.use(helmet());
app.use(compression());
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || ['http://localhost:3000'],
  credentials: true,
}));
app.use(morgan('combined', { stream: { write: message => logger.info(message.trim()) } }));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(rateLimiterMiddleware);

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'OK',
    timestamp: new Date().toISOString(),
    service: 'KaziApp USSD Gateway',
    version: process.env.npm_package_version || '1.0.0',
  });
});

// USSD Routes
app.post('/ussd', ussdController.handleUSSD);
app.post('/ussd/callback', ussdController.handleCallback);

// SMS Routes
app.post('/sms', smsController.handleSMS);
app.post('/sms/delivery', smsController.handleDeliveryReport);

// Voice Routes (for voice assistant integration)
app.post('/voice/callback', (req, res) => {
  logger.info('Voice callback received:', req.body);
  res.status(200).json({ status: 'received' });
});

// WhatsApp webhook (for WhatsApp Business API)
app.post('/whatsapp/webhook', (req, res) => {
  logger.info('WhatsApp webhook received:', req.body);
  res.status(200).json({ status: 'received' });
});

// Error handling middleware
app.use(notFound);
app.use(errorHandler);

// Graceful shutdown
process.on('SIGTERM', () => {
  logger.info('SIGTERM received, shutting down gracefully');
  server.close(() => {
    logger.info('Process terminated');
    redisClient.quit();
    process.exit(0);
  });
});

process.on('SIGINT', () => {
  logger.info('SIGINT received, shutting down gracefully');
  server.close(() => {
    logger.info('Process terminated');
    redisClient.quit();
    process.exit(0);
  });
});

const server = app.listen(PORT, () => {
  logger.info(`KaziApp USSD Gateway running on port ${PORT}`);
  logger.info(`Environment: ${process.env.NODE_ENV || 'development'}`);
});

module.exports = app;

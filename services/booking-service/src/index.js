const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const mongoose = require('mongoose');
const Redis = require('redis');
const { createServer } = require('http');
const { Server } = require('socket.io');
require('dotenv').config();

const logger = require('./utils/logger');
const bookingRoutes = require('./routes/booking');
const jobRoutes = require('./routes/job');
const providerRoutes = require('./routes/provider');
const authMiddleware = require('./middleware/auth');
const errorHandler = require('./middleware/errorHandler');
const BookingService = require('./services/BookingService');
const EventBusClient = require('./services/EventBusClient');

const app = express();
const server = createServer(app);
const io = new Server(server, {
  cors: {
    origin: process.env.ALLOWED_ORIGINS?.split(',') || ['http://localhost:3000'],
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
  },
});

// Global rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 1000, // limit each IP to 1000 requests per windowMs
  message: 'Too many requests from this IP, please try again later.',
  standardHeaders: true,
  legacyHeaders: false,
});

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));
app.use(limiter);

// Request logging
app.use((req, res, next) => {
  req.startTime = Date.now();
  logger.info(`${req.method} ${req.path}`, {
    ip: req.ip,
    userAgent: req.headers['user-agent'],
    correlationId: req.headers['x-correlation-id'],
  });
  next();
});

// Health check
app.get('/health', async (req, res) => {
  try {
    // Check database connection
    const dbStatus = mongoose.connection.readyState === 1 ? 'connected' : 'disconnected';
    
    // Check Redis connection
    const redisStatus = redisClient?.isOpen ? 'connected' : 'disconnected';
    
    res.status(200).json({
      status: 'OK',
      service: 'KaziApp Booking Service',
      timestamp: new Date().toISOString(),
      version: process.env.npm_package_version || '1.0.0',
      uptime: process.uptime(),
      database: dbStatus,
      redis: redisStatus,
    });
  } catch (error) {
    logger.error('Health check failed:', error);
    res.status(503).json({
      status: 'UNHEALTHY',
      service: 'KaziApp Booking Service',
      timestamp: new Date().toISOString(),
      error: error.message,
    });
  }
});

// API Routes
app.use('/api/bookings', authMiddleware, bookingRoutes);
app.use('/api/jobs', authMiddleware, jobRoutes);
app.use('/api/providers', authMiddleware, providerRoutes);

// Error handling
app.use(errorHandler);

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    error: 'Endpoint not found',
    path: req.path,
    method: req.method,
    timestamp: new Date().toISOString(),
  });
});

// Global error handler
app.use((error, req, res, next) => {
  logger.error('Unhandled error:', error);
  res.status(500).json({
    success: false,
    error: 'Internal server error',
    timestamp: new Date().toISOString(),
  });
});

// Initialize services
let redisClient;
let bookingService;
let eventBusClient;

async function initializeServices() {
  try {
    // Connect to MongoDB
    await mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/kaziapp_booking', {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    logger.info('Connected to MongoDB');

    // Connect to Redis
    redisClient = Redis.createClient({
      url: process.env.REDIS_URL || 'redis://localhost:6379',
    });
    await redisClient.connect();
    logger.info('Connected to Redis');

    // Initialize Event Bus Client
    eventBusClient = new EventBusClient(redisClient);
    await eventBusClient.initialize();

    // Initialize Booking Service
    bookingService = new BookingService(redisClient, eventBusClient, io);
    await bookingService.initialize();

    // Make services available globally
    app.locals.bookingService = bookingService;
    app.locals.eventBusClient = eventBusClient;
    app.locals.redisClient = redisClient;

    logger.info('All services initialized successfully');
  } catch (error) {
    logger.error('Failed to initialize services:', error);
    process.exit(1);
  }
}

// Socket.IO connection handling
io.on('connection', (socket) => {
  logger.info(`Client connected: ${socket.id}`);

  socket.on('join-room', (data) => {
    const { roomId, userId, userType } = data;
    socket.join(roomId);
    socket.userId = userId;
    socket.userType = userType;
    logger.info(`User ${userId} (${userType}) joined room ${roomId}`);
  });

  socket.on('disconnect', () => {
    logger.info(`Client disconnected: ${socket.id}`);
  });
});

// Start server
const PORT = process.env.PORT || 3005;

async function startServer() {
  await initializeServices();
  
  server.listen(PORT, () => {
    logger.info(`Booking Service running on port ${PORT}`);
    logger.info(`Environment: ${process.env.NODE_ENV || 'development'}`);
  });
}

// Graceful shutdown
process.on('SIGTERM', async () => {
  logger.info('SIGTERM received, shutting down gracefully');
  
  if (redisClient) {
    await redisClient.quit();
  }
  
  if (mongoose.connection) {
    await mongoose.connection.close();
  }
  
  server.close(() => {
    logger.info('Process terminated');
    process.exit(0);
  });
});

process.on('SIGINT', async () => {
  logger.info('SIGINT received, shutting down gracefully');
  
  if (redisClient) {
    await redisClient.quit();
  }
  
  if (mongoose.connection) {
    await mongoose.connection.close();
  }
  
  server.close(() => {
    logger.info('Process terminated');
    process.exit(0);
  });
});

startServer().catch((error) => {
  logger.error('Failed to start server:', error);
  process.exit(1);
});

module.exports = app;

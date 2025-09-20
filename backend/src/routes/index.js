const express = require('express');
const router = express.Router();

// Import route modules
const authRoutes = require('./auth');
const registrationRoutes = require('./registration');

// Health check endpoint
router.get('/health', (req, res) => {
  res.json({
    success: true,
    message: 'KaziApp Backend API is running',
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  });
});

// API status endpoint
router.get('/status', (req, res) => {
  res.json({
    success: true,
    data: {
      service: 'KaziApp Backend',
      status: 'operational',
      uptime: process.uptime(),
      memory: process.memoryUsage(),
      environment: process.env.NODE_ENV || 'development',
      timestamp: new Date().toISOString()
    }
  });
});

// Mount route modules
router.use('/auth', authRoutes);
router.use('/', registrationRoutes);

// 404 handler for API routes
router.use('*', (req, res) => {
  res.status(404).json({
    success: false,
    message: 'API endpoint not found',
    path: req.originalUrl,
    method: req.method
  });
});

module.exports = router;

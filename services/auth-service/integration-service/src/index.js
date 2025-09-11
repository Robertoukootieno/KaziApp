const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const morgan = require('morgan');
const compression = require('compression');
require('dotenv').config();

const logger = require('./utils/logger');
const redisClient = require('./config/redis');
const KeycloakService = require('./core/KeycloakService');
const authRoutes = require('./routes/auth');
const userRoutes = require('./routes/users');
const adminRoutes = require('./routes/admin');
const metrics = require('./utils/metrics');

const app = express();
const PORT = process.env.PORT || 3150;

// Initialize Keycloak service
let keycloakService;

// Middleware
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      scriptSrc: ["'self'"],
      imgSrc: ["'self'", "data:", "https:"],
      connectSrc: ["'self'", "http://localhost:8080"], // Allow Keycloak connections
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
    'http://localhost:3002',  // Admin Dashboard
    'http://localhost:8080',  // Keycloak
    /^http:\/\/127\.0\.0\.1:\d+$/, // Allow any port on 127.0.0.1 for Flutter development
    /^http:\/\/localhost:\d+$/, // Allow any port on localhost for development
  ],
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With', 'X-Client-Type'],
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
    
    // Check Keycloak connection
    let keycloakStatus = 'disconnected';
    try {
      if (keycloakService && keycloakService.adminClient) {
        await keycloakService.adminClient.realms.findOne({
          realm: keycloakService.keycloakConfig.realmName,
        });
        keycloakStatus = 'connected';
      }
    } catch (error) {
      keycloakStatus = 'error';
    }
    
    res.status(200).json({
      status: 'OK',
      service: 'KaziApp Keycloak Integration Service',
      timestamp: new Date().toISOString(),
      version: process.env.npm_package_version || '1.0.0',
      uptime: process.uptime(),
      dependencies: {
        redis: 'connected',
        keycloak: keycloakStatus,
      },
    });
  } catch (error) {
    logger.error('Health check failed:', error);
    res.status(503).json({
      status: 'UNHEALTHY',
      service: 'KaziApp Keycloak Integration Service',
      timestamp: new Date().toISOString(),
      error: error.message,
    });
  }
});

// Metrics endpoint
app.get('/metrics', metrics.getMetricsHandler());

// Keycloak configuration endpoint
app.get('/config', (req, res) => {
  const clientType = req.query.client || req.headers['x-client-type'] || 'farmer';
  
  const configs = {
    farmer: {
      realm: 'kaziapp',
      'auth-server-url': process.env.KEYCLOAK_BASE_URL || 'http://localhost:8080',
      'ssl-required': 'external',
      resource: 'kaziapp-farmer-mobile',
      'public-client': true,
      'confidential-port': 0,
    },
    provider: {
      realm: 'kaziapp',
      'auth-server-url': process.env.KEYCLOAK_BASE_URL || 'http://localhost:8080',
      'ssl-required': 'external',
      resource: 'kaziapp-provider-mobile',
      'public-client': true,
      'confidential-port': 0,
    },
    admin: {
      realm: 'kaziapp',
      'auth-server-url': process.env.KEYCLOAK_BASE_URL || 'http://localhost:8080',
      'ssl-required': 'external',
      resource: 'kaziapp-admin-web',
      'public-client': false,
      'confidential-port': 0,
      credentials: {
        secret: 'admin-web-secret-2024',
      },
    },
  };

  const config = configs[clientType] || configs.farmer;
  
  res.json({
    success: true,
    config,
    endpoints: {
      auth: `${config['auth-server-url']}/realms/${config.realm}/protocol/openid-connect/auth`,
      token: `${config['auth-server-url']}/realms/${config.realm}/protocol/openid-connect/token`,
      userinfo: `${config['auth-server-url']}/realms/${config.realm}/protocol/openid-connect/userinfo`,
      logout: `${config['auth-server-url']}/realms/${config.realm}/protocol/openid-connect/logout`,
      jwks: `${config['auth-server-url']}/realms/${config.realm}/protocol/openid-connect/certs`,
    },
  });
});

// Middleware to inject Keycloak service
app.use((req, res, next) => {
  req.keycloakService = keycloakService;
  next();
});

// API Routes
app.use('/auth', authRoutes);
app.use('/users', userRoutes);
app.use('/admin', adminRoutes);

// Token validation middleware for other services
app.post('/validate-token', async (req, res) => {
  try {
    const { token } = req.body;
    
    if (!token) {
      return res.status(400).json({
        success: false,
        error: 'Token is required',
      });
    }

    const decoded = await keycloakService.verifyToken(token);
    
    // Get cached user session for additional info
    const session = await keycloakService.getCachedSession(decoded.sub);
    
    res.json({
      success: true,
      valid: true,
      decoded,
      user: session?.user || null,
    });

  } catch (error) {
    logger.error('Token validation error:', error);
    res.status(401).json({
      success: false,
      valid: false,
      error: 'Invalid token',
    });
  }
});

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
    
    // Initialize Keycloak service
    keycloakService = new KeycloakService({
      KEYCLOAK_BASE_URL: process.env.KEYCLOAK_BASE_URL || 'http://localhost:8080',
      KEYCLOAK_REALM: process.env.KEYCLOAK_REALM || 'kaziapp',
      KEYCLOAK_CLIENT_ID: process.env.KEYCLOAK_CLIENT_ID || 'kaziapp-backend-services',
      KEYCLOAK_CLIENT_SECRET: process.env.KEYCLOAK_CLIENT_SECRET || 'backend-services-secret-2024',
      KEYCLOAK_ADMIN_USERNAME: process.env.KEYCLOAK_ADMIN_USERNAME || 'admin',
      KEYCLOAK_ADMIN_PASSWORD: process.env.KEYCLOAK_ADMIN_PASSWORD || 'admin_password',
    }, redisClient);

    // Initialize Keycloak service (non-blocking for development)
    try {
      await keycloakService.initialize();
      logger.info('Keycloak service initialized successfully');
    } catch (error) {
      logger.warn('Keycloak not available, starting service in limited mode:', error.message);
      // Continue without Keycloak for development/testing
    }
    
    // Start server
    const server = app.listen(PORT, () => {
      logger.info(`KaziApp Keycloak Integration Service running on port ${PORT}`);
      logger.info(`Environment: ${process.env.NODE_ENV || 'development'}`);
      logger.info(`Keycloak URL: ${process.env.KEYCLOAK_BASE_URL || 'http://localhost:8080'}`);
    });

    // Graceful shutdown
    const gracefulShutdown = (signal) => {
      logger.info(`Received ${signal}, shutting down gracefully`);
      server.close(async () => {
        logger.info('HTTP server closed');
        
        try {
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

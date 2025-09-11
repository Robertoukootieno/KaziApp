const jwt = require('jsonwebtoken');
const axios = require('axios');
const logger = require('../utils/logger');

/**
 * Authentication middleware
 * Validates JWT tokens and extracts user information
 */
const authMiddleware = async (req, res, next) => {
  try {
    // Get token from header
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        error: 'Access token required',
        message: 'Please provide a valid access token',
      });
    }

    const token = authHeader.substring(7); // Remove 'Bearer ' prefix

    // Validate token with auth service
    try {
      const authServiceUrl = process.env.AUTH_SERVICE_URL || 'http://localhost:3001';
      const response = await axios.post(`${authServiceUrl}/validate-token`, {
        token,
      }, {
        timeout: 5000,
      });

      if (!response.data.success || !response.data.valid) {
        return res.status(401).json({
          success: false,
          error: 'Invalid token',
          message: 'The provided token is invalid or expired',
        });
      }

      // Extract user information from token
      const decoded = response.data.decoded;
      const userSession = response.data.user;

      // Set user information in request
      req.user = {
        id: decoded.sub,
        email: decoded.email,
        phone: decoded.phone_number,
        name: decoded.name,
        type: decoded.user_type || 'farmer', // farmer, provider, admin
        roles: decoded.realm_access?.roles || [],
        permissions: decoded.resource_access || {},
        session: userSession,
      };

      // Add correlation ID for tracing
      req.correlationId = req.headers['x-correlation-id'] || `${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;

      logger.debug(`Authenticated user: ${req.user.id} (${req.user.type})`);
      next();

    } catch (authError) {
      logger.error('Auth service validation error:', authError.message);
      
      // Fallback to local JWT verification if auth service is unavailable
      try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET || 'fallback-secret');
        
        req.user = {
          id: decoded.sub || decoded.id,
          email: decoded.email,
          phone: decoded.phone_number || decoded.phone,
          name: decoded.name,
          type: decoded.user_type || decoded.type || 'farmer',
          roles: decoded.realm_access?.roles || decoded.roles || [],
          permissions: decoded.resource_access || decoded.permissions || {},
        };

        req.correlationId = req.headers['x-correlation-id'] || `${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;

        logger.warn(`Using fallback JWT verification for user: ${req.user.id}`);
        next();

      } catch (jwtError) {
        logger.error('JWT verification failed:', jwtError.message);
        return res.status(401).json({
          success: false,
          error: 'Invalid token',
          message: 'The provided token is invalid or expired',
        });
      }
    }

  } catch (error) {
    logger.error('Authentication middleware error:', error);
    res.status(500).json({
      success: false,
      error: 'Authentication error',
      message: 'An error occurred during authentication',
    });
  }
};

/**
 * Role-based authorization middleware
 */
const requireRole = (requiredRoles) => {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({
        success: false,
        error: 'Authentication required',
        message: 'Please authenticate first',
      });
    }

    const userRoles = req.user.roles || [];
    const userType = req.user.type;

    // Check if user has required role or type
    const hasRequiredRole = requiredRoles.some(role => 
      userRoles.includes(role) || userType === role
    );

    if (!hasRequiredRole) {
      logger.warn(`Access denied for user ${req.user.id}. Required: ${requiredRoles.join(', ')}, Has: ${userRoles.join(', ')}, Type: ${userType}`);
      return res.status(403).json({
        success: false,
        error: 'Access denied',
        message: `This endpoint requires one of the following roles: ${requiredRoles.join(', ')}`,
      });
    }

    next();
  };
};

/**
 * Permission-based authorization middleware
 */
const requirePermission = (resource, action) => {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({
        success: false,
        error: 'Authentication required',
        message: 'Please authenticate first',
      });
    }

    const permissions = req.user.permissions || {};
    const resourcePermissions = permissions[resource];

    if (!resourcePermissions || !resourcePermissions.includes(action)) {
      logger.warn(`Permission denied for user ${req.user.id}. Required: ${resource}:${action}`);
      return res.status(403).json({
        success: false,
        error: 'Permission denied',
        message: `You don't have permission to ${action} ${resource}`,
      });
    }

    next();
  };
};

/**
 * Optional authentication middleware
 * Sets user information if token is provided, but doesn't require it
 */
const optionalAuth = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      // No token provided, continue without authentication
      return next();
    }

    // Use the main auth middleware
    await authMiddleware(req, res, next);
  } catch (error) {
    // If authentication fails, continue without user information
    logger.debug('Optional authentication failed, continuing without user info');
    next();
  }
};

module.exports = {
  authMiddleware,
  requireRole,
  requirePermission,
  optionalAuth,
};

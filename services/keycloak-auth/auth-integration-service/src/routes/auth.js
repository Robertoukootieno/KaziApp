const express = require('express');
const Joi = require('joi');
const logger = require('../utils/logger');

const router = express.Router();

// Validation schemas
const loginSchema = Joi.object({
  username: Joi.string().required(),
  password: Joi.string().min(6).required(),
  clientType: Joi.string().valid('farmer', 'provider', 'veterinarian', 'agronomist', 'buyer', 'vendor', 'admin').default('farmer'),
  rememberMe: Joi.boolean().default(false),
});

const registerSchema = Joi.object({
  firstName: Joi.string().min(2).max(50).required(),
  lastName: Joi.string().min(2).max(50).required(),
  phoneNumber: Joi.string().pattern(/^\+254[0-9]{9}$/).required(),
  email: Joi.string().email().optional(),
  password: Joi.string().min(8).pattern(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/).required(),
  confirmPassword: Joi.string().valid(Joi.ref('password')).required(),
  county: Joi.string().optional(),
  preferredLanguage: Joi.string().valid('en', 'sw').default('en'),
  clientType: Joi.string().valid('farmer', 'provider', 'veterinarian', 'agronomist', 'buyer', 'vendor').default('farmer'),
  acceptTerms: Joi.boolean().valid(true).required(),
});

const refreshTokenSchema = Joi.object({
  refreshToken: Joi.string().required(),
  clientType: Joi.string().valid('farmer', 'provider', 'veterinarian', 'agronomist', 'buyer', 'vendor', 'admin').default('farmer'),
});

/**
 * POST /auth/login
 * Authenticate user with username/password
 */
router.post('/login', async (req, res) => {
  try {
    // Validate request
    const { error, value } = loginSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        success: false,
        error: 'Validation error',
        details: error.details.map(d => d.message),
      });
    }

    const { username, password, clientType, rememberMe } = value;

    // Authenticate with Keycloak
    const result = await req.keycloakService.authenticateUser(username, password, clientType);

    if (!result.success) {
      return res.status(401).json({
        success: false,
        error: result.error,
        code: result.code,
      });
    }

    // Log successful login
    logger.info(`User login successful: ${result.user.id} (${username}) - ${clientType}`);

    res.json({
      success: true,
      message: 'Login successful',
      data: {
        user: {
          id: result.user.id,
          username: result.user.username,
          email: result.user.email,
          firstName: result.user.firstName,
          lastName: result.user.lastName,
          phoneNumber: result.user.attributes.phoneNumber?.[0],
          county: result.user.attributes.county?.[0],
          userType: result.user.attributes.userType?.[0] || clientType,
          preferredLanguage: result.user.attributes.preferredLanguage?.[0] || 'en',
          emailVerified: result.user.emailVerified,
          enabled: result.user.enabled,
          roles: result.user.roles.realm,
          groups: result.user.groups.map(g => g.name),
        },
        tokens: {
          accessToken: result.tokens.access_token,
          refreshToken: result.tokens.refresh_token,
          idToken: result.tokens.id_token,
          tokenType: result.tokens.token_type,
          expiresIn: result.tokens.expires_in,
          refreshExpiresIn: result.tokens.refresh_expires_in,
        },
        sessionId: result.sessionId,
      },
    });

  } catch (error) {
    logger.error('Login error:', error);
    res.status(500).json({
      success: false,
      error: 'Internal server error',
    });
  }
});

/**
 * POST /auth/register
 * Register new user
 */
router.post('/register', async (req, res) => {
  try {
    // Validate request
    const { error, value } = registerSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        success: false,
        error: 'Validation error',
        details: error.details.map(d => d.message),
      });
    }

    const userData = value;
    delete userData.confirmPassword;
    delete userData.acceptTerms;

    // Create user in Keycloak
    const result = await req.keycloakService.createUser(userData, userData.clientType);

    if (!result.success) {
      return res.status(400).json({
        success: false,
        error: result.error,
        code: result.code,
      });
    }

    // Log successful registration
    logger.info(`User registration successful: ${result.userId} (${userData.phoneNumber}) - ${userData.clientType}`);

    res.status(201).json({
      success: true,
      message: 'Registration successful',
      data: {
        user: {
          id: result.user.id,
          username: result.user.username,
          email: result.user.email,
          firstName: result.user.firstName,
          lastName: result.user.lastName,
          phoneNumber: result.user.attributes.phoneNumber?.[0],
          county: result.user.attributes.county?.[0],
          userType: result.user.attributes.userType?.[0],
          preferredLanguage: result.user.attributes.preferredLanguage?.[0],
          emailVerified: result.user.emailVerified,
          enabled: result.user.enabled,
          roles: result.user.roles.realm,
          groups: result.user.groups.map(g => g.name),
        },
        requiresVerification: !result.user.emailVerified,
      },
    });

  } catch (error) {
    logger.error('Registration error:', error);
    res.status(500).json({
      success: false,
      error: 'Internal server error',
    });
  }
});

/**
 * POST /auth/refresh
 * Refresh access token
 */
router.post('/refresh', async (req, res) => {
  try {
    // Validate request
    const { error, value } = refreshTokenSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        success: false,
        error: 'Validation error',
        details: error.details.map(d => d.message),
      });
    }

    const { refreshToken, clientType } = value;

    // Refresh token with Keycloak
    const result = await req.keycloakService.refreshToken(refreshToken, clientType);

    if (!result.success) {
      return res.status(401).json({
        success: false,
        error: result.error,
      });
    }

    res.json({
      success: true,
      message: 'Token refreshed successfully',
      data: {
        tokens: {
          accessToken: result.tokens.access_token,
          refreshToken: result.tokens.refresh_token,
          idToken: result.tokens.id_token,
          tokenType: result.tokens.token_type,
          expiresIn: result.tokens.expires_in,
          refreshExpiresIn: result.tokens.refresh_expires_in,
        },
      },
    });

  } catch (error) {
    logger.error('Token refresh error:', error);
    res.status(500).json({
      success: false,
      error: 'Internal server error',
    });
  }
});

/**
 * POST /auth/logout
 * Logout user
 */
router.post('/logout', async (req, res) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        error: 'Authorization token required',
      });
    }

    const token = authHeader.substring(7);
    
    // Verify token to get user info
    const decoded = await req.keycloakService.verifyToken(token);
    
    // Logout user
    const result = await req.keycloakService.logoutUser(decoded.sub, decoded.session_state);

    if (!result.success) {
      return res.status(400).json({
        success: false,
        error: result.error,
      });
    }

    // Log successful logout
    logger.info(`User logout successful: ${decoded.sub}`);

    res.json({
      success: true,
      message: 'Logout successful',
    });

  } catch (error) {
    logger.error('Logout error:', error);
    res.status(500).json({
      success: false,
      error: 'Internal server error',
    });
  }
});

/**
 * POST /auth/verify-token
 * Verify JWT token
 */
router.post('/verify-token', async (req, res) => {
  try {
    const { token } = req.body;
    
    if (!token) {
      return res.status(400).json({
        success: false,
        error: 'Token is required',
      });
    }

    const decoded = await req.keycloakService.verifyToken(token);
    
    // Get cached user session
    const session = await req.keycloakService.getCachedSession(decoded.sub);
    
    res.json({
      success: true,
      valid: true,
      data: {
        userId: decoded.sub,
        username: decoded.preferred_username,
        email: decoded.email,
        roles: decoded.realm_access?.roles || [],
        clientId: decoded.azp,
        sessionState: decoded.session_state,
        expiresAt: new Date(decoded.exp * 1000).toISOString(),
        user: session?.user || null,
      },
    });

  } catch (error) {
    logger.error('Token verification error:', error);
    res.status(401).json({
      success: false,
      valid: false,
      error: 'Invalid token',
    });
  }
});

/**
 * POST /auth/forgot-password
 * Send password reset email
 */
router.post('/forgot-password', async (req, res) => {
  try {
    const { username } = req.body;
    
    if (!username) {
      return res.status(400).json({
        success: false,
        error: 'Username is required',
      });
    }

    // Find user by username (phone number or email)
    const users = await req.keycloakService.adminClient.users.find({
      username,
      max: 1,
    });

    if (users.length === 0) {
      // Don't reveal if user exists or not
      return res.json({
        success: true,
        message: 'If the user exists, a password reset email will be sent',
      });
    }

    const user = users[0];
    
    // Send password reset email
    const result = await req.keycloakService.resetPassword(user.id);

    if (!result.success) {
      return res.status(400).json({
        success: false,
        error: result.error,
      });
    }

    // Log password reset request
    logger.info(`Password reset requested for user: ${user.id} (${username})`);

    res.json({
      success: true,
      message: 'Password reset email sent successfully',
    });

  } catch (error) {
    logger.error('Password reset error:', error);
    res.status(500).json({
      success: false,
      error: 'Internal server error',
    });
  }
});

/**
 * POST /auth/resend-verification
 * Resend email verification
 */
router.post('/resend-verification', async (req, res) => {
  try {
    const { username } = req.body;
    
    if (!username) {
      return res.status(400).json({
        success: false,
        error: 'Username is required',
      });
    }

    // Find user by username
    const users = await req.keycloakService.adminClient.users.find({
      username,
      max: 1,
    });

    if (users.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'User not found',
      });
    }

    const user = users[0];
    
    if (user.emailVerified) {
      return res.status(400).json({
        success: false,
        error: 'Email already verified',
      });
    }

    // Send verification email
    const result = await req.keycloakService.sendVerificationEmail(user.id);

    if (!result.success) {
      return res.status(400).json({
        success: false,
        error: result.error,
      });
    }

    // Log verification email sent
    logger.info(`Verification email sent for user: ${user.id} (${username})`);

    res.json({
      success: true,
      message: 'Verification email sent successfully',
    });

  } catch (error) {
    logger.error('Resend verification error:', error);
    res.status(500).json({
      success: false,
      error: 'Internal server error',
    });
  }
});

module.exports = router;

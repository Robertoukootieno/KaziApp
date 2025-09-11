const express = require('express');
const Joi = require('joi');
const logger = require('../utils/logger');

const router = express.Router();

// Validation schemas
const updateProfileSchema = Joi.object({
  firstName: Joi.string().min(2).max(50).optional(),
  lastName: Joi.string().min(2).max(50).optional(),
  email: Joi.string().email().optional(),
  phoneNumber: Joi.string().pattern(/^\+254[0-9]{9}$/).optional(),
  county: Joi.string().optional(),
  preferredLanguage: Joi.string().valid('en', 'sw').optional(),
});

// Middleware to verify token and extract user info
const authenticateToken = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        error: 'Authorization token required',
      });
    }

    const token = authHeader.substring(7);
    const decoded = await req.keycloakService.verifyToken(token);
    
    req.user = decoded;
    next();
  } catch (error) {
    logger.error('Token authentication failed:', error);
    res.status(401).json({
      success: false,
      error: 'Invalid token',
    });
  }
};

/**
 * GET /users/profile
 * Get current user profile
 */
router.get('/profile', authenticateToken, async (req, res) => {
  try {
    const userProfile = await req.keycloakService.getUserProfile(req.user.sub);
    
    res.json({
      success: true,
      data: {
        user: {
          id: userProfile.id,
          username: userProfile.username,
          email: userProfile.email,
          firstName: userProfile.firstName,
          lastName: userProfile.lastName,
          phoneNumber: userProfile.attributes.phoneNumber?.[0],
          county: userProfile.attributes.county?.[0],
          userType: userProfile.attributes.userType?.[0],
          preferredLanguage: userProfile.attributes.preferredLanguage?.[0] || 'en',
          emailVerified: userProfile.emailVerified,
          enabled: userProfile.enabled,
          roles: userProfile.roles.realm,
          groups: userProfile.groups.map(g => g.name),
          createdAt: new Date(userProfile.createdTimestamp).toISOString(),
        },
      },
    });

  } catch (error) {
    logger.error('Get profile error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to get user profile',
    });
  }
});

/**
 * PUT /users/profile
 * Update user profile
 */
router.put('/profile', authenticateToken, async (req, res) => {
  try {
    // Validate request
    const { error, value } = updateProfileSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        success: false,
        error: 'Validation error',
        details: error.details.map(d => d.message),
      });
    }

    const updates = value;
    
    // Update user profile in Keycloak
    const result = await req.keycloakService.updateUserProfile(req.user.sub, updates);

    if (!result.success) {
      return res.status(400).json({
        success: false,
        error: result.error,
      });
    }

    // Log profile update
    logger.info(`User profile updated: ${req.user.sub}`);

    res.json({
      success: true,
      message: 'Profile updated successfully',
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
          preferredLanguage: result.user.attributes.preferredLanguage?.[0] || 'en',
          emailVerified: result.user.emailVerified,
          enabled: result.user.enabled,
          roles: result.user.roles.realm,
          groups: result.user.groups.map(g => g.name),
        },
      },
    });

  } catch (error) {
    logger.error('Update profile error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to update user profile',
    });
  }
});

/**
 * POST /users/change-password
 * Change user password
 */
router.post('/change-password', authenticateToken, async (req, res) => {
  try {
    const { currentPassword, newPassword } = req.body;
    
    if (!currentPassword || !newPassword) {
      return res.status(400).json({
        success: false,
        error: 'Current password and new password are required',
      });
    }

    if (newPassword.length < 8) {
      return res.status(400).json({
        success: false,
        error: 'New password must be at least 8 characters long',
      });
    }

    // Verify current password by attempting login
    const username = req.user.preferred_username;
    const authResult = await req.keycloakService.authenticateUser(username, currentPassword);
    
    if (!authResult.success) {
      return res.status(400).json({
        success: false,
        error: 'Current password is incorrect',
      });
    }

    // Update password in Keycloak
    await req.keycloakService.adminClient.users.resetPassword({
      id: req.user.sub,
      credential: {
        type: 'password',
        value: newPassword,
        temporary: false,
      },
    });

    // Log password change
    logger.info(`Password changed for user: ${req.user.sub}`);

    res.json({
      success: true,
      message: 'Password changed successfully',
    });

  } catch (error) {
    logger.error('Change password error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to change password',
    });
  }
});

/**
 * POST /users/verify-email
 * Resend email verification
 */
router.post('/verify-email', authenticateToken, async (req, res) => {
  try {
    const result = await req.keycloakService.sendVerificationEmail(req.user.sub);

    if (!result.success) {
      return res.status(400).json({
        success: false,
        error: result.error,
      });
    }

    // Log verification email sent
    logger.info(`Verification email sent for user: ${req.user.sub}`);

    res.json({
      success: true,
      message: 'Verification email sent successfully',
    });

  } catch (error) {
    logger.error('Send verification email error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to send verification email',
    });
  }
});

/**
 * GET /users/sessions
 * Get user sessions
 */
router.get('/sessions', authenticateToken, async (req, res) => {
  try {
    const sessions = await req.keycloakService.adminClient.users.listSessions({
      id: req.user.sub,
    });

    res.json({
      success: true,
      data: {
        sessions: sessions.map(session => ({
          id: session.id,
          ipAddress: session.ipAddress,
          start: new Date(session.start).toISOString(),
          lastAccess: new Date(session.lastAccess).toISOString(),
          clients: session.clients || {},
        })),
      },
    });

  } catch (error) {
    logger.error('Get sessions error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to get user sessions',
    });
  }
});

/**
 * DELETE /users/sessions/:sessionId
 * Logout specific session
 */
router.delete('/sessions/:sessionId', authenticateToken, async (req, res) => {
  try {
    const { sessionId } = req.params;
    
    await req.keycloakService.adminClient.users.logoutSession({
      id: req.user.sub,
      session: sessionId,
    });

    // Log session logout
    logger.info(`Session logged out: ${sessionId} for user: ${req.user.sub}`);

    res.json({
      success: true,
      message: 'Session logged out successfully',
    });

  } catch (error) {
    logger.error('Logout session error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to logout session',
    });
  }
});

module.exports = router;

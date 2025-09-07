const express = require('express');
const Joi = require('joi');
const logger = require('../utils/logger');

const router = express.Router();

// Middleware to verify admin token
const authenticateAdmin = async (req, res, next) => {
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
    
    // Check if user has admin role
    const hasAdminRole = decoded.realm_access?.roles?.includes('admin') || 
                        decoded.realm_access?.roles?.includes('super_admin');
    
    if (!hasAdminRole) {
      return res.status(403).json({
        success: false,
        error: 'Admin access required',
      });
    }
    
    req.user = decoded;
    next();
  } catch (error) {
    logger.error('Admin token authentication failed:', error);
    res.status(401).json({
      success: false,
      error: 'Invalid token',
    });
  }
};

/**
 * GET /admin/users
 * Get all users with pagination
 */
router.get('/users', authenticateAdmin, async (req, res) => {
  try {
    const { page = 1, limit = 20, search, userType } = req.query;
    const first = (page - 1) * limit;
    const max = parseInt(limit);

    let searchParams = {
      first,
      max,
    };

    if (search) {
      searchParams.search = search;
    }

    const users = await req.keycloakService.adminClient.users.find(searchParams);
    
    // Filter by user type if specified
    let filteredUsers = users;
    if (userType) {
      filteredUsers = users.filter(user => 
        user.attributes?.userType?.[0] === userType
      );
    }

    // Get total count
    const totalUsers = await req.keycloakService.adminClient.users.count();

    res.json({
      success: true,
      data: {
        users: filteredUsers.map(user => ({
          id: user.id,
          username: user.username,
          email: user.email,
          firstName: user.firstName,
          lastName: user.lastName,
          phoneNumber: user.attributes?.phoneNumber?.[0],
          county: user.attributes?.county?.[0],
          userType: user.attributes?.userType?.[0],
          preferredLanguage: user.attributes?.preferredLanguage?.[0] || 'en',
          emailVerified: user.emailVerified,
          enabled: user.enabled,
          createdAt: new Date(user.createdTimestamp).toISOString(),
        })),
        pagination: {
          page: parseInt(page),
          limit: max,
          total: totalUsers,
          pages: Math.ceil(totalUsers / max),
        },
      },
    });

  } catch (error) {
    logger.error('Get users error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to get users',
    });
  }
});

/**
 * GET /admin/users/:userId
 * Get specific user details
 */
router.get('/users/:userId', authenticateAdmin, async (req, res) => {
  try {
    const { userId } = req.params;
    
    const userProfile = await req.keycloakService.getUserProfile(userId);
    
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
    logger.error('Get user error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to get user',
    });
  }
});

/**
 * PUT /admin/users/:userId/enable
 * Enable/disable user
 */
router.put('/users/:userId/enable', authenticateAdmin, async (req, res) => {
  try {
    const { userId } = req.params;
    const { enabled } = req.body;
    
    if (typeof enabled !== 'boolean') {
      return res.status(400).json({
        success: false,
        error: 'enabled field must be a boolean',
      });
    }

    await req.keycloakService.adminClient.users.update(
      { id: userId },
      { enabled }
    );

    // Log user enable/disable
    logger.info(`User ${enabled ? 'enabled' : 'disabled'}: ${userId} by admin: ${req.user.sub}`);

    res.json({
      success: true,
      message: `User ${enabled ? 'enabled' : 'disabled'} successfully`,
    });

  } catch (error) {
    logger.error('Enable/disable user error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to update user status',
    });
  }
});

/**
 * POST /admin/users/:userId/reset-password
 * Reset user password
 */
router.post('/users/:userId/reset-password', authenticateAdmin, async (req, res) => {
  try {
    const { userId } = req.params;
    
    const result = await req.keycloakService.resetPassword(userId);

    if (!result.success) {
      return res.status(400).json({
        success: false,
        error: result.error,
      });
    }

    // Log password reset
    logger.info(`Password reset initiated for user: ${userId} by admin: ${req.user.sub}`);

    res.json({
      success: true,
      message: 'Password reset email sent successfully',
    });

  } catch (error) {
    logger.error('Reset password error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to reset password',
    });
  }
});

/**
 * GET /admin/stats
 * Get system statistics
 */
router.get('/stats', authenticateAdmin, async (req, res) => {
  try {
    // Get total users
    const totalUsers = await req.keycloakService.adminClient.users.count();
    
    // Get users by type
    const allUsers = await req.keycloakService.adminClient.users.find({ max: 10000 });
    
    const usersByType = allUsers.reduce((acc, user) => {
      const userType = user.attributes?.userType?.[0] || 'unknown';
      acc[userType] = (acc[userType] || 0) + 1;
      return acc;
    }, {});

    // Get users by status
    const enabledUsers = allUsers.filter(user => user.enabled).length;
    const disabledUsers = totalUsers - enabledUsers;
    
    // Get verified users
    const verifiedUsers = allUsers.filter(user => user.emailVerified).length;
    const unverifiedUsers = totalUsers - verifiedUsers;

    // Get recent registrations (last 30 days)
    const thirtyDaysAgo = Date.now() - (30 * 24 * 60 * 60 * 1000);
    const recentRegistrations = allUsers.filter(user => 
      user.createdTimestamp > thirtyDaysAgo
    ).length;

    res.json({
      success: true,
      data: {
        totalUsers,
        usersByType,
        usersByStatus: {
          enabled: enabledUsers,
          disabled: disabledUsers,
        },
        usersByVerification: {
          verified: verifiedUsers,
          unverified: unverifiedUsers,
        },
        recentRegistrations,
        generatedAt: new Date().toISOString(),
      },
    });

  } catch (error) {
    logger.error('Get stats error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to get statistics',
    });
  }
});

/**
 * GET /admin/sessions
 * Get all active sessions
 */
router.get('/sessions', authenticateAdmin, async (req, res) => {
  try {
    // Get realm sessions
    const sessions = await req.keycloakService.adminClient.realms.findSessions({
      realm: req.keycloakService.keycloakConfig.realmName,
    });

    res.json({
      success: true,
      data: {
        sessions: sessions.map(session => ({
          id: session.id,
          userId: session.userId,
          username: session.username,
          ipAddress: session.ipAddress,
          start: new Date(session.start).toISOString(),
          lastAccess: new Date(session.lastAccess).toISOString(),
          clients: session.clients || {},
        })),
        total: sessions.length,
      },
    });

  } catch (error) {
    logger.error('Get sessions error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to get sessions',
    });
  }
});

/**
 * DELETE /admin/sessions/:sessionId
 * Delete specific session
 */
router.delete('/sessions/:sessionId', authenticateAdmin, async (req, res) => {
  try {
    const { sessionId } = req.params;
    
    await req.keycloakService.adminClient.realms.deleteSession({
      realm: req.keycloakService.keycloakConfig.realmName,
      session: sessionId,
    });

    // Log session deletion
    logger.info(`Session deleted: ${sessionId} by admin: ${req.user.sub}`);

    res.json({
      success: true,
      message: 'Session deleted successfully',
    });

  } catch (error) {
    logger.error('Delete session error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to delete session',
    });
  }
});

module.exports = router;

const KcAdminClient = require('@keycloak/keycloak-admin-client').default;
const jwt = require('jsonwebtoken');
const jwksRsa = require('jwks-rsa');
const axios = require('axios');
const logger = require('../utils/logger');

/**
 * Keycloak Service - Handles all Keycloak operations
 * User management, authentication, authorization, token validation
 */
class KeycloakService {
  constructor(config, redisClient) {
    this.config = config;
    this.redis = redisClient;
    this.adminClient = null;
    this.jwksClient = null;
    this.publicKey = null;
    
    this.keycloakConfig = {
      baseUrl: config.KEYCLOAK_BASE_URL || 'http://localhost:8080',
      realmName: config.KEYCLOAK_REALM || 'kaziapp',
      clientId: config.KEYCLOAK_CLIENT_ID || 'kaziapp-backend-services',
      clientSecret: config.KEYCLOAK_CLIENT_SECRET || 'backend-services-secret-2024',
      adminUsername: config.KEYCLOAK_ADMIN_USERNAME || 'admin',
      adminPassword: config.KEYCLOAK_ADMIN_PASSWORD || 'admin_password',
    };

    this.clientConfigs = {
      farmer: {
        clientId: 'kaziapp-farmer-mobile',
        clientSecret: 'farmer-mobile-secret-2024',
      },
      provider: {
        clientId: 'kaziapp-provider-mobile',
        clientSecret: 'provider-mobile-secret-2024',
      },
      admin: {
        clientId: 'kaziapp-admin-web',
        clientSecret: 'admin-web-secret-2024',
      },
    };

    this.initialize();
  }

  /**
   * Initialize Keycloak service
   */
  async initialize() {
    try {
      // Initialize admin client
      this.adminClient = new KcAdminClient({
        baseUrl: this.keycloakConfig.baseUrl,
        realmName: 'master', // Use master realm for admin operations
      });

      // Authenticate admin client
      await this.adminClient.auth({
        username: this.keycloakConfig.adminUsername,
        password: this.keycloakConfig.adminPassword,
        grantType: 'password',
        clientId: 'admin-cli',
      });

      // Set target realm
      this.adminClient.setConfig({
        realmName: this.keycloakConfig.realmName,
      });

      // Initialize JWKS client for token verification
      this.jwksClient = jwksRsa({
        jwksUri: `${this.keycloakConfig.baseUrl}/realms/${this.keycloakConfig.realmName}/protocol/openid-connect/certs`,
        cache: true,
        cacheMaxEntries: 5,
        cacheMaxAge: 600000, // 10 minutes
      });

      // Get realm public key
      await this.updateRealmPublicKey();

      logger.info('Keycloak service initialized successfully');

    } catch (error) {
      logger.error('Failed to initialize Keycloak service:', error);
      throw error;
    }
  }

  /**
   * Authenticate user with username/password
   */
  async authenticateUser(username, password, clientType = 'farmer') {
    try {
      const clientConfig = this.clientConfigs[clientType];
      if (!clientConfig) {
        throw new Error(`Invalid client type: ${clientType}`);
      }

      const tokenUrl = `${this.keycloakConfig.baseUrl}/realms/${this.keycloakConfig.realmName}/protocol/openid-connect/token`;
      
      const response = await axios.post(tokenUrl, new URLSearchParams({
        grant_type: 'password',
        client_id: clientConfig.clientId,
        client_secret: clientConfig.clientSecret,
        username,
        password,
        scope: 'openid profile email phone offline_access',
      }), {
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      });

      const tokens = response.data;
      
      // Decode and validate access token
      const decodedToken = await this.verifyToken(tokens.access_token);

      // Extract user profile from JWT token
      const userProfile = {
        id: decodedToken.sub,
        username: decodedToken.preferred_username,
        email: decodedToken.email,
        firstName: decodedToken.given_name,
        lastName: decodedToken.family_name,
        fullName: decodedToken.name,
        emailVerified: decodedToken.email_verified,
        enabled: true,
        roles: {
          realm: decodedToken.realm_access?.roles || []
        },
        groups: [], // Groups would need to be fetched separately if needed
        clientType: clientType,
        attributes: {
          phoneNumber: decodedToken.phone_number,
          location: decodedToken.location,
          preferredLanguage: decodedToken.locale
        }
      };

      // Cache user session
      await this.cacheUserSession(decodedToken.sub, tokens, userProfile);

      return {
        success: true,
        tokens,
        user: userProfile,
        sessionId: decodedToken.session_state,
      };

    } catch (error) {
      logger.error('Authentication failed:', error);
      
      if (error.response?.status === 401) {
        return {
          success: false,
          error: 'Invalid credentials',
          code: 'INVALID_CREDENTIALS',
        };
      }
      
      return {
        success: false,
        error: 'Authentication failed',
        code: 'AUTH_ERROR',
      };
    }
  }

  /**
   * Refresh access token
   */
  async refreshToken(refreshToken, clientType = 'farmer') {
    try {
      const clientConfig = this.clientConfigs[clientType];
      const tokenUrl = `${this.keycloakConfig.baseUrl}/realms/${this.keycloakConfig.realmName}/protocol/openid-connect/token`;
      
      const response = await axios.post(tokenUrl, new URLSearchParams({
        grant_type: 'refresh_token',
        client_id: clientConfig.clientId,
        client_secret: clientConfig.clientSecret,
        refresh_token: refreshToken,
      }), {
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      });

      const tokens = response.data;
      const decodedToken = await this.verifyToken(tokens.access_token);
      
      // Update cached session
      await this.updateCachedSession(decodedToken.sub, tokens);

      return {
        success: true,
        tokens,
      };

    } catch (error) {
      logger.error('Token refresh failed:', error);
      return {
        success: false,
        error: 'Token refresh failed',
      };
    }
  }

  /**
   * Verify JWT token
   */
  async verifyToken(token) {
    try {
      // Get signing key
      const decoded = jwt.decode(token, { complete: true });
      if (!decoded) {
        throw new Error('Invalid token format');
      }

      const kid = decoded.header.kid;
      const signingKey = await this.getSigningKey(kid);
      
      // Verify token
      const verified = jwt.verify(token, signingKey, {
        algorithms: ['RS256'],
        issuer: `${this.keycloakConfig.baseUrl}/realms/${this.keycloakConfig.realmName}`,
        audience: 'account', // Keycloak uses 'account' as the default audience
      });

      return verified;

    } catch (error) {
      logger.error('Token verification failed:', error);
      throw new Error('Invalid token');
    }
  }

  /**
   * Create new user
   */
  async createUser(userData, clientType = 'farmer') {
    try {
      // Prepare user data for Keycloak
      const keycloakUser = {
        username: userData.phoneNumber || userData.email,
        email: userData.email,
        firstName: userData.firstName,
        lastName: userData.lastName,
        enabled: true,
        emailVerified: false,
        attributes: {
          phoneNumber: [userData.phoneNumber],
          county: [userData.county || ''],
          userType: [clientType],
          registrationSource: ['mobile_app'],
          preferredLanguage: [userData.preferredLanguage || 'en'],
        },
        credentials: userData.password ? [{
          type: 'password',
          value: userData.password,
          temporary: false,
        }] : [],
        groups: this.getUserGroups(clientType),
        realmRoles: this.getUserRoles(clientType),
      };

      // Create user in Keycloak
      const createdUser = await this.adminClient.users.create(keycloakUser);
      
      // Send verification email if email provided
      if (userData.email) {
        await this.sendVerificationEmail(createdUser.id);
      }

      // Get full user profile
      const userProfile = await this.getUserProfile(createdUser.id);

      logger.info(`User created successfully: ${createdUser.id}`);

      return {
        success: true,
        user: userProfile,
        userId: createdUser.id,
      };

    } catch (error) {
      logger.error('User creation failed:', error);
      
      if (error.response?.status === 409) {
        return {
          success: false,
          error: 'User already exists',
          code: 'USER_EXISTS',
        };
      }
      
      return {
        success: false,
        error: 'User creation failed',
        code: 'CREATE_ERROR',
      };
    }
  }

  /**
   * Get user profile
   */
  async getUserProfile(userId) {
    try {
      const user = await this.adminClient.users.findOne({ id: userId });
      if (!user) {
        throw new Error('User not found');
      }

      // Get user roles
      const realmRoles = await this.adminClient.users.listRealmRoleMappings({ id: userId });
      const clientRoles = await this.adminClient.users.listClientRoleMappings({ id: userId });

      // Get user groups
      const groups = await this.adminClient.users.listGroups({ id: userId });

      return {
        id: user.id,
        username: user.username,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        enabled: user.enabled,
        emailVerified: user.emailVerified,
        createdTimestamp: user.createdTimestamp,
        attributes: user.attributes || {},
        roles: {
          realm: realmRoles.map(role => role.name),
          client: clientRoles,
        },
        groups: groups.map(group => ({
          id: group.id,
          name: group.name,
          path: group.path,
        })),
      };

    } catch (error) {
      logger.error('Failed to get user profile:', error);
      throw error;
    }
  }

  /**
   * Update user profile
   */
  async updateUserProfile(userId, updates) {
    try {
      const updateData = {
        firstName: updates.firstName,
        lastName: updates.lastName,
        email: updates.email,
        attributes: {
          ...updates.attributes,
          phoneNumber: updates.phoneNumber ? [updates.phoneNumber] : undefined,
          county: updates.county ? [updates.county] : undefined,
          preferredLanguage: updates.preferredLanguage ? [updates.preferredLanguage] : undefined,
        },
      };

      // Remove undefined values
      Object.keys(updateData).forEach(key => {
        if (updateData[key] === undefined) {
          delete updateData[key];
        }
      });

      await this.adminClient.users.update({ id: userId }, updateData);

      // Get updated profile
      const updatedProfile = await this.getUserProfile(userId);

      return {
        success: true,
        user: updatedProfile,
      };

    } catch (error) {
      logger.error('Failed to update user profile:', error);
      return {
        success: false,
        error: 'Profile update failed',
      };
    }
  }

  /**
   * Logout user
   */
  async logoutUser(userId, sessionId) {
    try {
      // Logout from Keycloak
      if (sessionId) {
        await this.adminClient.users.logout({ id: userId });
      }

      // Clear cached session
      await this.clearCachedSession(userId);

      return {
        success: true,
      };

    } catch (error) {
      logger.error('Logout failed:', error);
      return {
        success: false,
        error: 'Logout failed',
      };
    }
  }

  /**
   * Send verification email
   */
  async sendVerificationEmail(userId) {
    try {
      await this.adminClient.users.executeActionsEmail({
        id: userId,
        actions: ['VERIFY_EMAIL'],
        lifespan: 86400, // 24 hours
      });

      return { success: true };

    } catch (error) {
      logger.error('Failed to send verification email:', error);
      return { success: false, error: 'Failed to send verification email' };
    }
  }

  /**
   * Reset password
   */
  async resetPassword(userId) {
    try {
      await this.adminClient.users.executeActionsEmail({
        id: userId,
        actions: ['UPDATE_PASSWORD'],
        lifespan: 3600, // 1 hour
      });

      return { success: true };

    } catch (error) {
      logger.error('Failed to send password reset:', error);
      return { success: false, error: 'Failed to send password reset' };
    }
  }

  // Helper methods
  async getSigningKey(kid) {
    return new Promise((resolve, reject) => {
      this.jwksClient.getSigningKey(kid, (err, key) => {
        if (err) {
          reject(err);
        } else {
          resolve(key.getPublicKey());
        }
      });
    });
  }

  async updateRealmPublicKey() {
    try {
      const realmInfo = await this.adminClient.realms.findOne({
        realm: this.keycloakConfig.realmName,
      });
      this.publicKey = realmInfo.publicKey;
    } catch (error) {
      logger.error('Failed to update realm public key:', error);
    }
  }

  getUserGroups(clientType) {
    const groupMappings = {
      farmer: ['/Farmers'],
      provider: ['/Service Providers'],
      veterinarian: ['/Service Providers/Veterinarians'],
      agronomist: ['/Service Providers/Agronomists'],
      buyer: ['/Marketplace Users/Buyers'],
      vendor: ['/Marketplace Users/Vendors'],
      admin: ['/Administrators'],
    };
    return groupMappings[clientType] || [];
  }

  getUserRoles(clientType) {
    const roleMappings = {
      farmer: ['farmer'],
      provider: ['service_provider'],
      veterinarian: ['veterinarian'],
      agronomist: ['agronomist'],
      buyer: ['buyer'],
      vendor: ['vendor'],
      admin: ['admin'],
    };
    return roleMappings[clientType] || [];
  }

  async cacheUserSession(userId, tokens, userProfile) {
    const sessionKey = `session:${userId}`;
    const sessionData = {
      tokens,
      user: userProfile,
      lastActivity: new Date().toISOString(),
    };
    await this.redis.setEx(sessionKey, 3600, JSON.stringify(sessionData)); // 1 hour
  }

  async updateCachedSession(userId, tokens) {
    const sessionKey = `session:${userId}`;
    const existingSession = await this.redis.get(sessionKey);
    if (existingSession) {
      const sessionData = JSON.parse(existingSession);
      sessionData.tokens = tokens;
      sessionData.lastActivity = new Date().toISOString();
      await this.redis.setEx(sessionKey, 3600, JSON.stringify(sessionData));
    }
  }

  async clearCachedSession(userId) {
    const sessionKey = `session:${userId}`;
    await this.redis.del(sessionKey);
  }

  async getCachedSession(userId) {
    const sessionKey = `session:${userId}`;
    const sessionData = await this.redis.get(sessionKey);
    return sessionData ? JSON.parse(sessionData) : null;
  }

  /**
   * Verify user email
   */
  async verifyUserEmail(userId, token) {
    try {
      // In Keycloak, email verification is typically handled through email links
      // For now, we'll mark the user as email verified
      await this.adminClient.users.update({ id: userId }, {
        emailVerified: true,
      });

      logger.info(`Email verified for user: ${userId}`);
      return { success: true };

    } catch (error) {
      logger.error('Email verification failed:', error);
      return { success: false, error: 'Email verification failed' };
    }
  }

  /**
   * Resend verification email
   */
  async resendVerificationEmail(username) {
    try {
      // Find user by username
      const users = await this.adminClient.users.find({ username });
      if (!users || users.length === 0) {
        return { success: false, error: 'User not found' };
      }

      const user = users[0];

      // Send verification email
      const result = await this.sendVerificationEmail(user.id);

      if (result.success) {
        logger.info(`Verification email resent for user: ${username}`);
        return { success: true };
      } else {
        return { success: false, error: result.error };
      }

    } catch (error) {
      logger.error('Resend verification email failed:', error);
      return { success: false, error: 'Failed to resend verification email' };
    }
  }

  /**
   * Get user verification status
   */
  async getVerificationStatus(username) {
    try {
      // Find user by username
      const users = await this.adminClient.users.find({ username });
      if (!users || users.length === 0) {
        return { success: false, error: 'User not found' };
      }

      const user = users[0];

      return {
        success: true,
        emailVerified: user.emailVerified || false,
        enabled: user.enabled || false,
      };

    } catch (error) {
      logger.error('Get verification status failed:', error);
      return { success: false, error: 'Failed to get verification status' };
    }
  }
}

module.exports = KeycloakService;

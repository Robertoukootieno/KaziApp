const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const speakeasy = require('speakeasy');
const QRCode = require('qrcode');
const { validationResult } = require('express-validator');

const User = require('../models/User');
const Session = require('../models/Session');
const LoginAttempt = require('../models/LoginAttempt');
const logger = require('../utils/logger');
const redisClient = require('../config/redis');
const smsService = require('../services/smsService');
const emailService = require('../services/emailService');
const tokenService = require('../services/tokenService');
const rbacService = require('../services/rbacService');

/**
 * User registration with comprehensive validation
 */
const register = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Validation errors',
        errors: errors.array(),
      });
    }

    const {
      firstName,
      lastName,
      phoneNumber,
      email,
      password,
      userType,
      county,
      subCounty,
      ward,
      licenseNumber,
      preferredLanguage,
    } = req.body;

    // Check if user already exists
    const existingUser = await User.findOne({
      where: {
        $or: [
          { phoneNumber },
          { email: email || null },
        ],
      },
    });

    if (existingUser) {
      return res.status(409).json({
        success: false,
        message: 'User already exists with this phone number or email',
      });
    }

    // Validate veterinarian license if applicable
    let licenseStatus = null;
    if (userType === 'veterinarian' && licenseNumber) {
      try {
        licenseStatus = await validateVeterinarianLicense(licenseNumber);
      } catch (error) {
        logger.warn('License validation failed:', error.message);
        licenseStatus = 'pending_verification';
      }
    }

    // Hash password
    const saltRounds = 12;
    const hashedPassword = await bcrypt.hash(password, saltRounds);

    // Create user
    const user = await User.create({
      firstName,
      lastName,
      phoneNumber,
      email,
      password: hashedPassword,
      userType,
      county,
      subCounty,
      ward,
      licenseNumber,
      licenseStatus,
      preferredLanguage: preferredLanguage || 'sw',
      status: 'pending_verification',
      emailVerified: false,
      phoneVerified: false,
    });

    // Generate verification code
    const verificationCode = generateVerificationCode();
    const verificationExpiry = new Date(Date.now() + 10 * 60 * 1000); // 10 minutes

    // Store verification code in Redis
    await redisClient.setex(
      `verification:${phoneNumber}`,
      600, // 10 minutes
      JSON.stringify({
        code: verificationCode,
        userId: user.id,
        attempts: 0,
      })
    );

    // Send verification SMS
    try {
      await smsService.sendVerificationCode(
        phoneNumber,
        verificationCode,
        preferredLanguage
      );
    } catch (error) {
      logger.error('Failed to send verification SMS:', error);
      // Don't fail registration if SMS fails
    }

    // Generate initial JWT token (limited access until verified)
    const tokenPayload = {
      userId: user.id,
      userType: user.userType,
      verified: false,
    };

    const token = tokenService.generateAccessToken(tokenPayload);
    const refreshToken = tokenService.generateRefreshToken(tokenPayload);

    // Create session
    await Session.create({
      userId: user.id,
      token: refreshToken,
      userAgent: req.headers['user-agent'],
      ipAddress: req.ip,
      expiresAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // 30 days
    });

    // Log registration
    logger.info(`User registered: ${user.id} (${phoneNumber})`);

    res.status(201).json({
      success: true,
      message: 'User registered successfully. Please verify your phone number.',
      data: {
        user: {
          id: user.id,
          firstName: user.firstName,
          lastName: user.lastName,
          phoneNumber: user.phoneNumber,
          email: user.email,
          userType: user.userType,
          status: user.status,
          verified: false,
        },
        tokens: {
          accessToken: token,
          refreshToken,
          expiresIn: process.env.JWT_EXPIRES_IN || '24h',
        },
        requiresVerification: true,
      },
    });

  } catch (error) {
    logger.error('Registration error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
};

/**
 * User login with security measures
 */
const login = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Validation errors',
        errors: errors.array(),
      });
    }

    const { phoneNumber, password, rememberMe } = req.body;
    const userAgent = req.headers['user-agent'];
    const ipAddress = req.ip;

    // Check for too many failed attempts
    const attemptKey = `login_attempts:${phoneNumber}:${ipAddress}`;
    const attempts = await redisClient.get(attemptKey);
    
    if (attempts && parseInt(attempts) >= 5) {
      return res.status(429).json({
        success: false,
        message: 'Too many failed login attempts. Please try again later.',
        retryAfter: 900, // 15 minutes
      });
    }

    // Find user
    const user = await User.findOne({
      where: { phoneNumber },
      include: ['roles', 'permissions'],
    });

    if (!user) {
      await recordFailedAttempt(phoneNumber, ipAddress, userAgent, 'user_not_found');
      return res.status(401).json({
        success: false,
        message: 'Invalid credentials',
      });
    }

    // Check password
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      await recordFailedAttempt(phoneNumber, ipAddress, userAgent, 'invalid_password');
      return res.status(401).json({
        success: false,
        message: 'Invalid credentials',
      });
    }

    // Check user status
    if (user.status === 'suspended') {
      return res.status(403).json({
        success: false,
        message: 'Account suspended. Please contact support.',
      });
    }

    if (user.status === 'banned') {
      return res.status(403).json({
        success: false,
        message: 'Account banned. Please contact support.',
      });
    }

    // Clear failed attempts
    await redisClient.del(attemptKey);

    // Check if 2FA is enabled
    if (user.twoFactorEnabled) {
      // Generate and send 2FA code
      const twoFactorCode = generateVerificationCode();
      await redisClient.setex(
        `2fa:${user.id}`,
        300, // 5 minutes
        JSON.stringify({
          code: twoFactorCode,
          phoneNumber,
          attempts: 0,
        })
      );

      try {
        await smsService.send2FACode(phoneNumber, twoFactorCode, user.preferredLanguage);
      } catch (error) {
        logger.error('Failed to send 2FA code:', error);
      }

      return res.status(200).json({
        success: true,
        message: '2FA code sent to your phone',
        data: {
          requires2FA: true,
          userId: user.id,
        },
      });
    }

    // Generate tokens
    const tokenPayload = {
      userId: user.id,
      userType: user.userType,
      verified: user.phoneVerified,
      permissions: rbacService.getUserPermissions(user),
    };

    const accessToken = tokenService.generateAccessToken(tokenPayload);
    const refreshToken = tokenService.generateRefreshToken(tokenPayload);

    // Create session
    const expiresAt = rememberMe 
      ? new Date(Date.now() + 30 * 24 * 60 * 60 * 1000) // 30 days
      : new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours

    await Session.create({
      userId: user.id,
      token: refreshToken,
      userAgent,
      ipAddress,
      expiresAt,
    });

    // Update user last login
    await user.update({
      lastLoginAt: new Date(),
      lastLoginIp: ipAddress,
    });

    // Cache user session
    await redisClient.setex(
      `user_session:${user.id}`,
      86400, // 24 hours
      JSON.stringify({
        id: user.id,
        phoneNumber: user.phoneNumber,
        userType: user.userType,
        status: user.status,
        permissions: tokenPayload.permissions,
      })
    );

    logger.info(`User logged in: ${user.id} (${phoneNumber})`);

    res.json({
      success: true,
      message: 'Login successful',
      data: {
        user: {
          id: user.id,
          firstName: user.firstName,
          lastName: user.lastName,
          phoneNumber: user.phoneNumber,
          email: user.email,
          userType: user.userType,
          status: user.status,
          verified: user.phoneVerified,
          profilePicture: user.profilePicture,
          county: user.county,
          preferredLanguage: user.preferredLanguage,
        },
        tokens: {
          accessToken,
          refreshToken,
          expiresIn: process.env.JWT_EXPIRES_IN || '24h',
        },
        permissions: tokenPayload.permissions,
        requiresVerification: !user.phoneVerified,
      },
    });

  } catch (error) {
    logger.error('Login error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
};

/**
 * Verify 2FA code
 */
const verify2FA = async (req, res) => {
  try {
    const { userId, code } = req.body;

    const twoFactorData = await redisClient.get(`2fa:${userId}`);
    if (!twoFactorData) {
      return res.status(400).json({
        success: false,
        message: '2FA code expired or not found',
      });
    }

    const { code: storedCode, attempts } = JSON.parse(twoFactorData);

    if (attempts >= 3) {
      await redisClient.del(`2fa:${userId}`);
      return res.status(429).json({
        success: false,
        message: 'Too many 2FA attempts',
      });
    }

    if (code !== storedCode) {
      await redisClient.setex(
        `2fa:${userId}`,
        300,
        JSON.stringify({ code: storedCode, attempts: attempts + 1 })
      );
      
      return res.status(400).json({
        success: false,
        message: 'Invalid 2FA code',
      });
    }

    // 2FA successful - complete login
    await redisClient.del(`2fa:${userId}`);

    const user = await User.findByPk(userId, {
      include: ['roles', 'permissions'],
    });

    const tokenPayload = {
      userId: user.id,
      userType: user.userType,
      verified: user.phoneVerified,
      permissions: rbacService.getUserPermissions(user),
    };

    const accessToken = tokenService.generateAccessToken(tokenPayload);
    const refreshToken = tokenService.generateRefreshToken(tokenPayload);

    res.json({
      success: true,
      message: '2FA verification successful',
      data: {
        user: {
          id: user.id,
          firstName: user.firstName,
          lastName: user.lastName,
          phoneNumber: user.phoneNumber,
          userType: user.userType,
        },
        tokens: {
          accessToken,
          refreshToken,
          expiresIn: process.env.JWT_EXPIRES_IN || '24h',
        },
      },
    });

  } catch (error) {
    logger.error('2FA verification error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
};

/**
 * Helper functions
 */
function generateVerificationCode() {
  return Math.floor(100000 + Math.random() * 900000).toString();
}

async function recordFailedAttempt(phoneNumber, ipAddress, userAgent, reason) {
  try {
    // Record in database
    await LoginAttempt.create({
      phoneNumber,
      ipAddress,
      userAgent,
      success: false,
      reason,
    });

    // Increment Redis counter
    const attemptKey = `login_attempts:${phoneNumber}:${ipAddress}`;
    const attempts = await redisClient.incr(attemptKey);
    
    if (attempts === 1) {
      await redisClient.expire(attemptKey, 900); // 15 minutes
    }

    logger.warn(`Failed login attempt: ${phoneNumber} from ${ipAddress} (${reason})`);
  } catch (error) {
    logger.error('Error recording failed attempt:', error);
  }
}

async function validateVeterinarianLicense(licenseNumber) {
  // This would integrate with Kenya Veterinary Board API
  // For now, return pending verification
  return 'pending_verification';
}

module.exports = {
  register,
  login,
  verify2FA,
};

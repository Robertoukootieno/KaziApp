const jwt = require('jsonwebtoken');
const { validationResult } = require('express-validator');
const User = require('../models/User');
const logger = require('../utils/logger');
const smsService = require('../services/smsService');
const kenyaVetBoardService = require('../services/kenyaVetBoardService');
const redisClient = require('../config/redis');

/**
 * Register a new user
 */
const register = async (req, res) => {
  try {
    // Check validation errors
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
      preferredLanguage,
      // Farmer-specific fields
      farmSize,
      farmingType,
      primaryCrops,
      livestock,
      // Veterinarian-specific fields
      licenseNumber,
      specializations,
      yearsOfExperience,
      consultationFee,
      // Business fields
      businessName,
      businessRegistrationNumber,
      businessType,
    } = req.body;

    // Check if user already exists
    const existingUser = await User.findByPhoneNumber(phoneNumber);
    if (existingUser) {
      return res.status(409).json({
        success: false,
        message: 'User with this phone number already exists',
      });
    }

    // Check email if provided
    if (email) {
      const existingEmailUser = await User.findByEmail(email);
      if (existingEmailUser) {
        return res.status(409).json({
          success: false,
          message: 'User with this email already exists',
        });
      }
    }

    // Validate veterinarian license if userType is veterinarian
    let licenseStatus = null;
    if (userType === 'veterinarian' && licenseNumber) {
      try {
        const licenseValidation = await kenyaVetBoardService.validateLicense(licenseNumber);
        licenseStatus = licenseValidation.isValid ? 'valid' : 'pending_verification';
      } catch (error) {
        logger.warn('Could not validate vet license:', error.message);
        licenseStatus = 'pending_verification';
      }
    }

    // Create user
    const userData = {
      firstName,
      lastName,
      phoneNumber,
      email,
      password,
      userType,
      county,
      subCounty,
      ward,
      preferredLanguage: preferredLanguage || 'sw',
      status: 'pending_verification',
    };

    // Add type-specific fields
    if (userType === 'farmer') {
      Object.assign(userData, {
        farmSize,
        farmingType,
        primaryCrops,
        livestock,
      });
    } else if (userType === 'veterinarian') {
      Object.assign(userData, {
        licenseNumber,
        licenseStatus,
        specializations,
        yearsOfExperience,
        consultationFee,
      });
    } else if (userType === 'buyer' || userType === 'vendor') {
      Object.assign(userData, {
        businessName,
        businessRegistrationNumber,
        businessType,
      });
    }

    const user = await User.create(userData);

    // Generate and send verification code
    const verificationCode = user.generateVerificationCode();
    await user.save();

    // Send SMS verification code
    try {
      await smsService.sendVerificationCode(phoneNumber, verificationCode, preferredLanguage);
    } catch (error) {
      logger.error('Failed to send verification SMS:', error);
      // Don't fail registration if SMS fails
    }

    // Generate JWT token
    const token = generateToken(user.id);

    logger.info(`User registered: ${user.id} (${phoneNumber})`);

    res.status(201).json({
      success: true,
      message: 'User registered successfully. Please verify your phone number.',
      data: {
        user: user.toJSON(),
        token,
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
 * Login user
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

    const { phoneNumber, password } = req.body;

    // Find user
    const user = await User.findByPhoneNumber(phoneNumber);
    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Invalid credentials',
      });
    }

    // Check password
    const isPasswordValid = await user.comparePassword(password);
    if (!isPasswordValid) {
      return res.status(401).json({
        success: false,
        message: 'Invalid credentials',
      });
    }

    // Check if user is suspended
    if (user.status === 'suspended') {
      return res.status(403).json({
        success: false,
        message: 'Account suspended. Please contact support.',
      });
    }

    // Update last login
    user.lastLoginAt = new Date();
    await user.save();

    // Generate token
    const token = generateToken(user.id);

    // Cache user session
    await redisClient.setex(`user_session:${user.id}`, 86400, JSON.stringify({
      id: user.id,
      phoneNumber: user.phoneNumber,
      userType: user.userType,
      status: user.status,
    }));

    logger.info(`User logged in: ${user.id} (${phoneNumber})`);

    res.json({
      success: true,
      message: 'Login successful',
      data: {
        user: user.toJSON(),
        token,
        requiresVerification: !user.isPhoneVerified,
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
 * Verify phone number
 */
const verifyPhone = async (req, res) => {
  try {
    const { phoneNumber, code } = req.body;

    const user = await User.findByPhoneNumber(phoneNumber);
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    }

    if (!user.isVerificationCodeValid(code)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid or expired verification code',
      });
    }

    // Update user verification status
    user.isPhoneVerified = true;
    user.phoneVerificationCode = null;
    user.phoneVerificationExpiry = null;
    user.status = 'active';
    await user.save();

    logger.info(`Phone verified for user: ${user.id} (${phoneNumber})`);

    res.json({
      success: true,
      message: 'Phone number verified successfully',
      data: {
        user: user.toJSON(),
      },
    });

  } catch (error) {
    logger.error('Phone verification error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
};

/**
 * Resend verification code
 */
const resendVerificationCode = async (req, res) => {
  try {
    const { phoneNumber } = req.body;

    const user = await User.findByPhoneNumber(phoneNumber);
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    }

    if (user.isPhoneVerified) {
      return res.status(400).json({
        success: false,
        message: 'Phone number already verified',
      });
    }

    // Generate new verification code
    const verificationCode = user.generateVerificationCode();
    await user.save();

    // Send SMS
    try {
      await smsService.sendVerificationCode(phoneNumber, verificationCode, user.preferredLanguage);
    } catch (error) {
      logger.error('Failed to send verification SMS:', error);
      return res.status(500).json({
        success: false,
        message: 'Failed to send verification code',
      });
    }

    res.json({
      success: true,
      message: 'Verification code sent successfully',
    });

  } catch (error) {
    logger.error('Resend verification error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
};

/**
 * Logout user
 */
const logout = async (req, res) => {
  try {
    const userId = req.user.id;

    // Remove user session from cache
    await redisClient.del(`user_session:${userId}`);

    logger.info(`User logged out: ${userId}`);

    res.json({
      success: true,
      message: 'Logout successful',
    });

  } catch (error) {
    logger.error('Logout error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
};

/**
 * Generate JWT token
 */
const generateToken = (userId) => {
  return jwt.sign(
    { userId },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_EXPIRES_IN || '24h' }
  );
};

module.exports = {
  register,
  login,
  verifyPhone,
  resendVerificationCode,
  logout,
};

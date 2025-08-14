const { DataTypes } = require('sequelize');
const bcrypt = require('bcryptjs');
const sequelize = require('../config/database');

const User = sequelize.define('User', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
  
  // Basic Information
  firstName: {
    type: DataTypes.STRING,
    allowNull: false,
    validate: {
      notEmpty: true,
      len: [2, 50],
    },
  },
  
  lastName: {
    type: DataTypes.STRING,
    allowNull: false,
    validate: {
      notEmpty: true,
      len: [2, 50],
    },
  },
  
  email: {
    type: DataTypes.STRING,
    allowNull: true,
    unique: true,
    validate: {
      isEmail: true,
    },
  },
  
  phoneNumber: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
    validate: {
      notEmpty: true,
      is: /^(\+254|0)[17]\d{8}$/, // Kenyan phone number format
    },
  },
  
  password: {
    type: DataTypes.STRING,
    allowNull: false,
    validate: {
      len: [6, 100],
    },
  },
  
  // User Type and Status
  userType: {
    type: DataTypes.ENUM('farmer', 'veterinarian', 'buyer', 'vendor', 'admin'),
    allowNull: false,
    defaultValue: 'farmer',
  },
  
  status: {
    type: DataTypes.ENUM('active', 'inactive', 'suspended', 'pending_verification'),
    allowNull: false,
    defaultValue: 'pending_verification',
  },
  
  // Location Information
  county: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  
  subCounty: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  
  ward: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  
  location: {
    type: DataTypes.GEOMETRY('POINT'),
    allowNull: true,
  },
  
  address: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  
  // Profile Information
  profilePicture: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  
  dateOfBirth: {
    type: DataTypes.DATEONLY,
    allowNull: true,
  },
  
  gender: {
    type: DataTypes.ENUM('male', 'female', 'other'),
    allowNull: true,
  },
  
  // Language and Preferences
  preferredLanguage: {
    type: DataTypes.ENUM('en', 'sw', 'ki', 'luo', 'kln', 'so'),
    allowNull: false,
    defaultValue: 'sw',
  },
  
  // Verification
  isPhoneVerified: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
  },
  
  isEmailVerified: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
  },
  
  phoneVerificationCode: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  
  phoneVerificationExpiry: {
    type: DataTypes.DATE,
    allowNull: true,
  },
  
  emailVerificationToken: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  
  // Security
  lastLoginAt: {
    type: DataTypes.DATE,
    allowNull: true,
  },
  
  passwordResetToken: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  
  passwordResetExpiry: {
    type: DataTypes.DATE,
    allowNull: true,
  },
  
  // Farmer-specific fields
  farmSize: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: true,
    comment: 'Farm size in acres',
  },
  
  farmingType: {
    type: DataTypes.ENUM('crop', 'livestock', 'mixed', 'aquaculture'),
    allowNull: true,
  },
  
  primaryCrops: {
    type: DataTypes.JSON,
    allowNull: true,
    comment: 'Array of primary crops grown',
  },
  
  livestock: {
    type: DataTypes.JSON,
    allowNull: true,
    comment: 'Object with livestock types and counts',
  },
  
  // Veterinarian-specific fields
  licenseNumber: {
    type: DataTypes.STRING,
    allowNull: true,
    unique: true,
  },
  
  licenseStatus: {
    type: DataTypes.ENUM('valid', 'expired', 'suspended', 'pending_verification'),
    allowNull: true,
  },
  
  licenseExpiry: {
    type: DataTypes.DATEONLY,
    allowNull: true,
  },
  
  specializations: {
    type: DataTypes.JSON,
    allowNull: true,
    comment: 'Array of veterinary specializations',
  },
  
  yearsOfExperience: {
    type: DataTypes.INTEGER,
    allowNull: true,
  },
  
  consultationFee: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: true,
    comment: 'Consultation fee in KSh',
  },
  
  // Business Information (for vendors/buyers)
  businessName: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  
  businessRegistrationNumber: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  
  businessType: {
    type: DataTypes.ENUM('individual', 'partnership', 'company', 'cooperative'),
    allowNull: true,
  },
  
  // Metadata
  metadata: {
    type: DataTypes.JSON,
    allowNull: true,
    comment: 'Additional user metadata',
  },
  
}, {
  tableName: 'users',
  timestamps: true,
  paranoid: true, // Soft delete
  
  hooks: {
    beforeCreate: async (user) => {
      if (user.password) {
        user.password = await bcrypt.hash(user.password, 12);
      }
    },
    
    beforeUpdate: async (user) => {
      if (user.changed('password')) {
        user.password = await bcrypt.hash(user.password, 12);
      }
    },
  },
  
  indexes: [
    {
      fields: ['phoneNumber'],
      unique: true,
    },
    {
      fields: ['email'],
      unique: true,
      where: {
        email: {
          [sequelize.Sequelize.Op.ne]: null,
        },
      },
    },
    {
      fields: ['userType'],
    },
    {
      fields: ['status'],
    },
    {
      fields: ['county', 'subCounty'],
    },
    {
      fields: ['licenseNumber'],
      unique: true,
      where: {
        licenseNumber: {
          [sequelize.Sequelize.Op.ne]: null,
        },
      },
    },
    {
      type: 'GIST',
      fields: ['location'],
    },
  ],
});

// Instance methods
User.prototype.comparePassword = async function(candidatePassword) {
  return bcrypt.compare(candidatePassword, this.password);
};

User.prototype.generateVerificationCode = function() {
  const code = Math.floor(100000 + Math.random() * 900000).toString();
  this.phoneVerificationCode = code;
  this.phoneVerificationExpiry = new Date(Date.now() + 10 * 60 * 1000); // 10 minutes
  return code;
};

User.prototype.isVerificationCodeValid = function(code) {
  return this.phoneVerificationCode === code && 
         this.phoneVerificationExpiry && 
         this.phoneVerificationExpiry > new Date();
};

User.prototype.toJSON = function() {
  const values = { ...this.get() };
  delete values.password;
  delete values.phoneVerificationCode;
  delete values.emailVerificationToken;
  delete values.passwordResetToken;
  return values;
};

// Class methods
User.findByPhoneNumber = function(phoneNumber) {
  return this.findOne({ where: { phoneNumber } });
};

User.findByEmail = function(email) {
  return this.findOne({ where: { email } });
};

User.findByLicenseNumber = function(licenseNumber) {
  return this.findOne({ where: { licenseNumber } });
};

module.exports = User;

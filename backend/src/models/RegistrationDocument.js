const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const RegistrationDocument = sequelize.define('RegistrationDocument', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  
  registrationId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'service_provider_registrations',
      key: 'id'
    },
    onDelete: 'CASCADE'
  },
  
  type: {
    type: DataTypes.ENUM(
      'business_license',
      'business_logo',
      'id_copy',
      'tax_certificate',
      'insurance_certificate',
      'bank_statement',
      'other'
    ),
    allowNull: false
  },
  
  filename: {
    type: DataTypes.STRING,
    allowNull: false
  },
  
  originalName: {
    type: DataTypes.STRING,
    allowNull: false
  },
  
  mimeType: {
    type: DataTypes.STRING,
    allowNull: false
  },
  
  size: {
    type: DataTypes.INTEGER,
    allowNull: false,
    validate: {
      min: 0
    }
  },
  
  path: {
    type: DataTypes.STRING,
    allowNull: false
  },
  
  url: {
    type: DataTypes.STRING,
    allowNull: true
  },
  
  // Document verification status
  status: {
    type: DataTypes.ENUM('pending', 'approved', 'rejected'),
    defaultValue: 'pending',
    allowNull: false
  },
  
  // Verification information
  verifiedBy: {
    type: DataTypes.UUID,
    allowNull: true
  },
  
  verifiedAt: {
    type: DataTypes.DATE,
    allowNull: true
  },
  
  verificationNotes: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  
  // Rejection information
  rejectionReason: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  
  // File metadata
  checksum: {
    type: DataTypes.STRING,
    allowNull: true
  },
  
  isProcessed: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  },
  
  processedAt: {
    type: DataTypes.DATE,
    allowNull: true
  },
  
  // Storage information
  storageProvider: {
    type: DataTypes.ENUM('local', 's3', 'gcs'),
    defaultValue: 'local'
  },
  
  storageKey: {
    type: DataTypes.STRING,
    allowNull: true
  }
}, {
  tableName: 'registration_documents',
  indexes: [
    {
      fields: ['registrationId']
    },
    {
      fields: ['type']
    },
    {
      fields: ['status']
    },
    {
      fields: ['filename']
    }
  ]
});

// Instance methods
RegistrationDocument.prototype.approve = function(adminId, notes = null) {
  this.status = 'approved';
  this.verifiedBy = adminId;
  this.verifiedAt = new Date();
  this.verificationNotes = notes;
  return this.save();
};

RegistrationDocument.prototype.reject = function(adminId, reason) {
  this.status = 'rejected';
  this.verifiedBy = adminId;
  this.verifiedAt = new Date();
  this.rejectionReason = reason;
  return this.save();
};

RegistrationDocument.prototype.markAsProcessed = function() {
  this.isProcessed = true;
  this.processedAt = new Date();
  return this.save();
};

// Class methods
RegistrationDocument.getByRegistrationId = function(registrationId) {
  return this.findAll({
    where: { registrationId },
    order: [['createdAt', 'ASC']]
  });
};

RegistrationDocument.getByType = function(registrationId, type) {
  return this.findOne({
    where: { 
      registrationId,
      type 
    }
  });
};

module.exports = RegistrationDocument;

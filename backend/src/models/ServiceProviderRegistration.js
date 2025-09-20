const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const ServiceProviderRegistration = sequelize.define('ServiceProviderRegistration', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  
  // Business Information
  businessName: {
    type: DataTypes.STRING,
    allowNull: false,
    validate: {
      notEmpty: true,
      len: [2, 100]
    }
  },
  
  ownerName: {
    type: DataTypes.STRING,
    allowNull: false,
    validate: {
      notEmpty: true,
      len: [2, 100]
    }
  },
  
  email: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
    validate: {
      isEmail: true
    }
  },
  
  phone: {
    type: DataTypes.STRING,
    allowNull: false,
    validate: {
      notEmpty: true,
      len: [10, 15]
    }
  },
  
  location: {
    type: DataTypes.STRING,
    allowNull: false,
    validate: {
      notEmpty: true
    }
  },
  
  serviceType: {
    type: DataTypes.ENUM(
      'crop_production',
      'livestock_farming',
      'agricultural_equipment',
      'irrigation_services',
      'pest_control',
      'soil_testing',
      'harvesting_services',
      'transportation',
      'storage_facilities',
      'consulting',
      'other'
    ),
    allowNull: false
  },
  
  description: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  
  // Registration Status
  status: {
    type: DataTypes.ENUM('pending', 'approved', 'rejected', 'under_review'),
    defaultValue: 'pending',
    allowNull: false
  },
  
  // Approval Information
  approvedBy: {
    type: DataTypes.UUID,
    allowNull: true
  },
  
  approvedAt: {
    type: DataTypes.DATE,
    allowNull: true
  },
  
  approvalNotes: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  
  // Rejection Information
  rejectedBy: {
    type: DataTypes.UUID,
    allowNull: true
  },
  
  rejectedAt: {
    type: DataTypes.DATE,
    allowNull: true
  },
  
  rejectionReason: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  
  // Additional Information
  businessRegistrationNumber: {
    type: DataTypes.STRING,
    allowNull: true
  },
  
  taxId: {
    type: DataTypes.STRING,
    allowNull: true
  },
  
  yearsOfExperience: {
    type: DataTypes.INTEGER,
    allowNull: true,
    validate: {
      min: 0,
      max: 100
    }
  },
  
  servicesOffered: {
    type: DataTypes.JSON,
    allowNull: true,
    defaultValue: []
  },
  
  operatingAreas: {
    type: DataTypes.JSON,
    allowNull: true,
    defaultValue: []
  },
  
  // Verification Status
  isVerified: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  },
  
  verifiedAt: {
    type: DataTypes.DATE,
    allowNull: true
  },
  
  // Metadata
  submittedAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  },
  
  lastUpdatedBy: {
    type: DataTypes.UUID,
    allowNull: true
  },
  
  notes: {
    type: DataTypes.TEXT,
    allowNull: true
  }
}, {
  tableName: 'service_provider_registrations',
  indexes: [
    {
      fields: ['email']
    },
    {
      fields: ['status']
    },
    {
      fields: ['serviceType']
    },
    {
      fields: ['submittedAt']
    },
    {
      fields: ['businessName']
    }
  ],
  hooks: {
    beforeUpdate: (registration, options) => {
      // Update verification status based on approval
      if (registration.status === 'approved' && !registration.isVerified) {
        registration.isVerified = true;
        registration.verifiedAt = new Date();
      }
    }
  }
});

// Instance methods
ServiceProviderRegistration.prototype.approve = function(adminId, notes = null) {
  this.status = 'approved';
  this.approvedBy = adminId;
  this.approvedAt = new Date();
  this.approvalNotes = notes;
  this.isVerified = true;
  this.verifiedAt = new Date();
  this.lastUpdatedBy = adminId;
  return this.save();
};

ServiceProviderRegistration.prototype.reject = function(adminId, reason) {
  this.status = 'rejected';
  this.rejectedBy = adminId;
  this.rejectedAt = new Date();
  this.rejectionReason = reason;
  this.lastUpdatedBy = adminId;
  return this.save();
};

ServiceProviderRegistration.prototype.setUnderReview = function(adminId) {
  this.status = 'under_review';
  this.lastUpdatedBy = adminId;
  return this.save();
};

// Class methods
ServiceProviderRegistration.getStatistics = async function() {
  const stats = await this.findAll({
    attributes: [
      'status',
      [sequelize.fn('COUNT', sequelize.col('id')), 'count']
    ],
    group: ['status'],
    raw: true
  });
  
  const result = {
    total: 0,
    pending: 0,
    approved: 0,
    rejected: 0,
    under_review: 0
  };
  
  stats.forEach(stat => {
    result[stat.status] = parseInt(stat.count);
    result.total += parseInt(stat.count);
  });
  
  return result;
};

module.exports = ServiceProviderRegistration;

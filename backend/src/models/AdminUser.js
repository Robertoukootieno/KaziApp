const { DataTypes } = require('sequelize');
const bcrypt = require('bcryptjs');
const { sequelize } = require('../config/database');

const AdminUser = sequelize.define('AdminUser', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  
  name: {
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
  
  password: {
    type: DataTypes.STRING,
    allowNull: false,
    validate: {
      len: [6, 255]
    }
  },
  
  role: {
    type: DataTypes.ENUM(
      'super_admin',
      'admin',
      'moderator',
      'reviewer'
    ),
    defaultValue: 'reviewer',
    allowNull: false
  },
  
  permissions: {
    type: DataTypes.JSON,
    defaultValue: [],
    allowNull: false
  },
  
  isActive: {
    type: DataTypes.BOOLEAN,
    defaultValue: true
  },
  
  lastLoginAt: {
    type: DataTypes.DATE,
    allowNull: true
  },
  
  loginCount: {
    type: DataTypes.INTEGER,
    defaultValue: 0
  },
  
  // Profile information
  avatar: {
    type: DataTypes.STRING,
    allowNull: true
  },
  
  phone: {
    type: DataTypes.STRING,
    allowNull: true
  },
  
  department: {
    type: DataTypes.STRING,
    allowNull: true
  },
  
  // Security
  passwordResetToken: {
    type: DataTypes.STRING,
    allowNull: true
  },
  
  passwordResetExpires: {
    type: DataTypes.DATE,
    allowNull: true
  },
  
  twoFactorSecret: {
    type: DataTypes.STRING,
    allowNull: true
  },
  
  twoFactorEnabled: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  },
  
  // Audit fields
  createdBy: {
    type: DataTypes.UUID,
    allowNull: true
  },
  
  updatedBy: {
    type: DataTypes.UUID,
    allowNull: true
  }
}, {
  tableName: 'admin_users',
  indexes: [
    {
      fields: ['email']
    },
    {
      fields: ['role']
    },
    {
      fields: ['isActive']
    }
  ],
  hooks: {
    beforeCreate: async (user) => {
      if (user.password) {
        const salt = await bcrypt.genSalt(parseInt(process.env.BCRYPT_ROUNDS) || 12);
        user.password = await bcrypt.hash(user.password, salt);
      }
    },
    beforeUpdate: async (user) => {
      if (user.changed('password')) {
        const salt = await bcrypt.genSalt(parseInt(process.env.BCRYPT_ROUNDS) || 12);
        user.password = await bcrypt.hash(user.password, salt);
      }
    }
  }
});

// Instance methods
AdminUser.prototype.validatePassword = async function(password) {
  return bcrypt.compare(password, this.password);
};

AdminUser.prototype.updateLastLogin = function() {
  this.lastLoginAt = new Date();
  this.loginCount += 1;
  return this.save();
};

AdminUser.prototype.hasPermission = function(permission) {
  if (this.role === 'super_admin') return true;
  return this.permissions.includes(permission);
};

AdminUser.prototype.addPermission = function(permission) {
  if (!this.permissions.includes(permission)) {
    this.permissions.push(permission);
    return this.save();
  }
  return Promise.resolve(this);
};

AdminUser.prototype.removePermission = function(permission) {
  const index = this.permissions.indexOf(permission);
  if (index > -1) {
    this.permissions.splice(index, 1);
    return this.save();
  }
  return Promise.resolve(this);
};

// Class methods
AdminUser.findByEmail = function(email) {
  return this.findOne({
    where: { email, isActive: true }
  });
};

AdminUser.getActiveAdmins = function() {
  return this.findAll({
    where: { isActive: true },
    attributes: { exclude: ['password', 'passwordResetToken', 'twoFactorSecret'] },
    order: [['name', 'ASC']]
  });
};

module.exports = AdminUser;

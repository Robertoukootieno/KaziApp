const { sequelize } = require('../config/database');
const ServiceProviderRegistration = require('./ServiceProviderRegistration');
const RegistrationDocument = require('./RegistrationDocument');
const AdminUser = require('./AdminUser');

// Define associations
ServiceProviderRegistration.hasMany(RegistrationDocument, {
  foreignKey: 'registrationId',
  as: 'documents',
  onDelete: 'CASCADE'
});

RegistrationDocument.belongsTo(ServiceProviderRegistration, {
  foreignKey: 'registrationId',
  as: 'registration'
});

// Admin user associations (optional - for audit trail)
ServiceProviderRegistration.belongsTo(AdminUser, {
  foreignKey: 'approvedBy',
  as: 'approver',
  constraints: false
});

ServiceProviderRegistration.belongsTo(AdminUser, {
  foreignKey: 'rejectedBy',
  as: 'rejector',
  constraints: false
});

ServiceProviderRegistration.belongsTo(AdminUser, {
  foreignKey: 'lastUpdatedBy',
  as: 'lastUpdater',
  constraints: false
});

RegistrationDocument.belongsTo(AdminUser, {
  foreignKey: 'verifiedBy',
  as: 'verifier',
  constraints: false
});

// Export models
const models = {
  ServiceProviderRegistration,
  RegistrationDocument,
  AdminUser,
  sequelize
};

module.exports = models;

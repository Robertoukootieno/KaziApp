const { sequelize } = require('../config/database');
const models = require('../models');
const logger = require('../config/logger');

const migrate = async () => {
  try {
    logger.info('🔄 Starting database migration...');

    // Test database connection
    await sequelize.authenticate();
    logger.info('✅ Database connection established');

    // Sync all models
    await sequelize.sync({ 
      force: process.env.NODE_ENV === 'development' && process.env.DB_FORCE_SYNC === 'true',
      alter: process.env.NODE_ENV === 'development'
    });

    logger.info('✅ Database migration completed successfully');
    
    // Log table information
    const tables = await sequelize.getQueryInterface().showAllTables();
    logger.info(`📊 Created/Updated tables: ${tables.join(', ')}`);

  } catch (error) {
    logger.error('❌ Database migration failed:', error);
    process.exit(1);
  }
};

// Run migration if this file is executed directly
if (require.main === module) {
  migrate()
    .then(() => {
      logger.info('🎉 Migration process completed');
      process.exit(0);
    })
    .catch((error) => {
      logger.error('💥 Migration process failed:', error);
      process.exit(1);
    });
}

module.exports = migrate;

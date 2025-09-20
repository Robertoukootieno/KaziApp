const { AdminUser } = require('../models');
const logger = require('../config/logger');

const seedData = {
  adminUsers: [
    {
      name: process.env.ADMIN_NAME || 'System Administrator',
      email: process.env.ADMIN_EMAIL || 'admin@kaziapp.com',
      password: process.env.ADMIN_PASSWORD || 'admin123',
      role: 'super_admin',
      permissions: [
        'registration.view',
        'registration.approve',
        'registration.reject',
        'registration.bulk_operations',
        'documents.verify',
        'users.manage',
        'system.admin'
      ],
      isActive: true,
      department: 'Administration'
    },
    {
      name: 'Registration Reviewer',
      email: 'reviewer@kaziapp.com',
      password: 'reviewer123',
      role: 'reviewer',
      permissions: [
        'registration.view',
        'documents.verify'
      ],
      isActive: true,
      department: 'Registration Review'
    },
    {
      name: 'Registration Moderator',
      email: 'moderator@kaziapp.com',
      password: 'moderator123',
      role: 'moderator',
      permissions: [
        'registration.view',
        'registration.approve',
        'registration.reject',
        'documents.verify'
      ],
      isActive: true,
      department: 'Registration Management'
    }
  ]
};

const seedAdminUsers = async () => {
  try {
    logger.info('🌱 Seeding admin users...');

    for (const userData of seedData.adminUsers) {
      const existingUser = await AdminUser.findOne({
        where: { email: userData.email }
      });

      if (!existingUser) {
        const user = await AdminUser.create(userData);
        logger.info(`✅ Created admin user: ${user.email} (${user.role})`);
      } else {
        logger.info(`⏭️  Admin user already exists: ${userData.email}`);
      }
    }

    logger.info('✅ Admin users seeding completed');
  } catch (error) {
    logger.error('❌ Admin users seeding failed:', error);
    throw error;
  }
};

const seedSampleRegistrations = async () => {
  try {
    const { ServiceProviderRegistration, RegistrationDocument } = require('../models');
    
    logger.info('🌱 Seeding sample registrations...');

    const sampleRegistrations = [
      {
        businessName: 'Green Valley Farms',
        ownerName: 'John Doe',
        email: 'john@greenvalley.com',
        phone: '+254712345678',
        location: 'Nakuru County',
        serviceType: 'crop_production',
        description: 'Organic vegetable farming and supply',
        status: 'pending',
        yearsOfExperience: 5,
        servicesOffered: ['Organic Vegetables', 'Crop Consulting'],
        operatingAreas: ['Nakuru', 'Naivasha']
      },
      {
        businessName: 'Livestock Solutions Ltd',
        ownerName: 'Jane Smith',
        email: 'jane@livestock.com',
        phone: '+254723456789',
        location: 'Kajiado County',
        serviceType: 'livestock_farming',
        description: 'Dairy farming and livestock management services',
        status: 'approved',
        yearsOfExperience: 8,
        servicesOffered: ['Dairy Farming', 'Livestock Health'],
        operatingAreas: ['Kajiado', 'Machakos']
      },
      {
        businessName: 'AgriTech Equipment',
        ownerName: 'Peter Mwangi',
        email: 'peter@agritech.com',
        phone: '+254734567890',
        location: 'Kiambu County',
        serviceType: 'agricultural_equipment',
        description: 'Farm equipment rental and maintenance',
        status: 'under_review',
        yearsOfExperience: 12,
        servicesOffered: ['Equipment Rental', 'Maintenance Services'],
        operatingAreas: ['Kiambu', 'Murang\'a', 'Nyeri']
      }
    ];

    for (const regData of sampleRegistrations) {
      const existingReg = await ServiceProviderRegistration.findOne({
        where: { email: regData.email }
      });

      if (!existingReg) {
        const registration = await ServiceProviderRegistration.create(regData);
        logger.info(`✅ Created sample registration: ${registration.businessName}`);
      } else {
        logger.info(`⏭️  Sample registration already exists: ${regData.businessName}`);
      }
    }

    logger.info('✅ Sample registrations seeding completed');
  } catch (error) {
    logger.error('❌ Sample registrations seeding failed:', error);
    throw error;
  }
};

const seed = async () => {
  try {
    logger.info('🌱 Starting database seeding...');

    await seedAdminUsers();
    
    // Only seed sample data in development
    if (process.env.NODE_ENV === 'development') {
      await seedSampleRegistrations();
    }

    logger.info('✅ Database seeding completed successfully');
  } catch (error) {
    logger.error('❌ Database seeding failed:', error);
    throw error;
  }
};

// Run seeding if this file is executed directly
if (require.main === module) {
  seed()
    .then(() => {
      logger.info('🎉 Seeding process completed');
      process.exit(0);
    })
    .catch((error) => {
      logger.error('💥 Seeding process failed:', error);
      process.exit(1);
    });
}

module.exports = {
  seed,
  seedAdminUsers,
  seedSampleRegistrations
};

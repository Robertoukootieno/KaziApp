const { ServiceProviderRegistration, RegistrationDocument } = require('../models');
const logger = require('../config/logger');
const { redisUtils } = require('../config/redis');
const { Op } = require('sequelize');
const path = require('path');

// Submit new service provider registration
const submitRegistration = async (req, res) => {
  try {
    const {
      businessName,
      ownerName,
      email,
      phone,
      location,
      serviceType,
      description,
      businessRegistrationNumber,
      taxId,
      yearsOfExperience,
      servicesOffered,
      operatingAreas
    } = req.body;

    // Check if email already exists
    const existingRegistration = await ServiceProviderRegistration.findOne({
      where: { email }
    });

    if (existingRegistration) {
      return res.status(400).json({
        success: false,
        message: 'A registration with this email already exists.'
      });
    }

    // Create registration
    const registration = await ServiceProviderRegistration.create({
      businessName,
      ownerName,
      email,
      phone,
      location,
      serviceType,
      description,
      businessRegistrationNumber,
      taxId,
      yearsOfExperience: yearsOfExperience ? parseInt(yearsOfExperience) : null,
      servicesOffered: servicesOffered ? JSON.parse(servicesOffered) : [],
      operatingAreas: operatingAreas ? JSON.parse(operatingAreas) : []
    });

    // Process uploaded documents
    const documents = [];
    if (req.files) {
      for (const [fieldName, files] of Object.entries(req.files)) {
        for (const file of files) {
          const documentType = getDocumentType(fieldName);
          
          const document = await RegistrationDocument.create({
            registrationId: registration.id,
            type: documentType,
            filename: file.filename,
            originalName: file.originalname,
            mimeType: file.mimetype,
            size: file.size,
            path: file.path,
            url: `/uploads/${path.basename(path.dirname(file.path))}/${file.filename}`,
            storageProvider: 'local'
          });

          documents.push(document);
        }
      }
    }

    // Emit real-time notification
    const io = req.app.get('io');
    if (io) {
      io.to('admin-room').emit('registration_submitted', {
        type: 'registration_submitted',
        data: {
          ...registration.toJSON(),
          documents: documents.map(doc => doc.toJSON())
        }
      });
    }

    // Clear cache
    await redisUtils.del('registration_stats');

    logger.info(`New registration submitted: ${registration.id} by ${email}`);

    res.status(201).json({
      success: true,
      message: 'Registration submitted successfully. You will be notified within 24-48 hours.',
      data: {
        id: registration.id,
        status: registration.status,
        submittedAt: registration.submittedAt,
        documentsCount: documents.length
      }
    });

  } catch (error) {
    logger.error('Registration submission error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to submit registration. Please try again.',
      error: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
};

// Get all registrations (admin only)
const getRegistrations = async (req, res) => {
  try {
    const {
      page = 1,
      limit = 10,
      status,
      serviceType,
      search
    } = req.query;

    const offset = (page - 1) * limit;
    const where = {};

    // Apply filters
    if (status && status !== 'all') {
      where.status = status;
    }

    if (serviceType) {
      where.serviceType = {
        [Op.iLike]: `%${serviceType}%`
      };
    }

    if (search) {
      where[Op.or] = [
        { businessName: { [Op.iLike]: `%${search}%` } },
        { ownerName: { [Op.iLike]: `%${search}%` } },
        { email: { [Op.iLike]: `%${search}%` } }
      ];
    }

    const { count, rows } = await ServiceProviderRegistration.findAndCountAll({
      where,
      include: [
        {
          model: RegistrationDocument,
          as: 'documents',
          attributes: ['id', 'type', 'filename', 'status', 'createdAt']
        }
      ],
      order: [['submittedAt', 'DESC']],
      limit: parseInt(limit),
      offset: parseInt(offset)
    });

    res.json({
      success: true,
      data: rows,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total: count,
        totalPages: Math.ceil(count / limit)
      }
    });

  } catch (error) {
    logger.error('Get registrations error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch registrations.'
    });
  }
};

// Get pending registrations
const getPendingRegistrations = async (req, res) => {
  try {
    const registrations = await ServiceProviderRegistration.findAll({
      where: { status: 'pending' },
      include: [
        {
          model: RegistrationDocument,
          as: 'documents',
          attributes: ['id', 'type', 'filename', 'status', 'createdAt']
        }
      ],
      order: [['submittedAt', 'ASC']]
    });

    res.json({
      success: true,
      data: registrations
    });

  } catch (error) {
    logger.error('Get pending registrations error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch pending registrations.'
    });
  }
};

// Get registration by ID
const getRegistrationById = async (req, res) => {
  try {
    const { id } = req.params;

    const registration = await ServiceProviderRegistration.findByPk(id, {
      include: [
        {
          model: RegistrationDocument,
          as: 'documents'
        }
      ]
    });

    if (!registration) {
      return res.status(404).json({
        success: false,
        message: 'Registration not found.'
      });
    }

    res.json({
      success: true,
      data: registration
    });

  } catch (error) {
    logger.error('Get registration by ID error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch registration.'
    });
  }
};

// Get registration statistics
const getRegistrationStatistics = async (req, res) => {
  try {
    // Try to get from cache first
    let stats = await redisUtils.get('registration_stats');
    
    if (!stats) {
      stats = await ServiceProviderRegistration.getStatistics();
      
      // Cache for 5 minutes
      await redisUtils.setex('registration_stats', 300, stats);
    }

    res.json({
      success: true,
      data: stats
    });

  } catch (error) {
    logger.error('Get registration statistics error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch statistics.'
    });
  }
};

// Helper function to map field names to document types
const getDocumentType = (fieldName) => {
  const mapping = {
    businessLicense: 'business_license',
    businessLogo: 'business_logo',
    idCopy: 'id_copy',
    taxCertificate: 'tax_certificate',
    insuranceCertificate: 'insurance_certificate',
    bankStatement: 'bank_statement'
  };
  
  return mapping[fieldName] || 'other';
};

module.exports = {
  submitRegistration,
  getRegistrations,
  getPendingRegistrations,
  getRegistrationById,
  getRegistrationStatistics
};

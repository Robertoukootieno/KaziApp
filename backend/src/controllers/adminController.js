const { ServiceProviderRegistration, RegistrationDocument } = require('../models');
const logger = require('../config/logger');
const { redisUtils } = require('../config/redis');

// Approve registration
const approveRegistration = async (req, res) => {
  try {
    const { id } = req.params;
    const { notes } = req.body;
    const adminId = req.user.id;

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

    if (registration.status !== 'pending' && registration.status !== 'under_review') {
      return res.status(400).json({
        success: false,
        message: 'Registration cannot be approved in its current status.'
      });
    }

    // Approve the registration
    await registration.approve(adminId, notes);

    // Emit real-time notification
    const io = req.app.get('io');
    if (io) {
      io.to('admin-room').emit('registration_updated', {
        type: 'registration_approved',
        data: registration.toJSON()
      });
    }

    // Clear cache
    await redisUtils.del('registration_stats');

    logger.info(`Registration approved: ${id} by admin ${adminId}`);

    res.json({
      success: true,
      message: 'Registration approved successfully.',
      data: registration
    });

  } catch (error) {
    logger.error('Approve registration error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to approve registration.'
    });
  }
};

// Reject registration
const rejectRegistration = async (req, res) => {
  try {
    const { id } = req.params;
    const { reason } = req.body;
    const adminId = req.user.id;

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

    if (registration.status !== 'pending' && registration.status !== 'under_review') {
      return res.status(400).json({
        success: false,
        message: 'Registration cannot be rejected in its current status.'
      });
    }

    // Reject the registration
    await registration.reject(adminId, reason);

    // Emit real-time notification
    const io = req.app.get('io');
    if (io) {
      io.to('admin-room').emit('registration_updated', {
        type: 'registration_rejected',
        data: registration.toJSON()
      });
    }

    // Clear cache
    await redisUtils.del('registration_stats');

    logger.info(`Registration rejected: ${id} by admin ${adminId}`);

    res.json({
      success: true,
      message: 'Registration rejected successfully.',
      data: registration
    });

  } catch (error) {
    logger.error('Reject registration error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to reject registration.'
    });
  }
};

// Set registration under review
const setUnderReview = async (req, res) => {
  try {
    const { id } = req.params;
    const adminId = req.user.id;

    const registration = await ServiceProviderRegistration.findByPk(id);

    if (!registration) {
      return res.status(404).json({
        success: false,
        message: 'Registration not found.'
      });
    }

    if (registration.status !== 'pending') {
      return res.status(400).json({
        success: false,
        message: 'Only pending registrations can be set under review.'
      });
    }

    // Set under review
    await registration.setUnderReview(adminId);

    // Emit real-time notification
    const io = req.app.get('io');
    if (io) {
      io.to('admin-room').emit('registration_updated', {
        type: 'registration_under_review',
        data: registration.toJSON()
      });
    }

    logger.info(`Registration set under review: ${id} by admin ${adminId}`);

    res.json({
      success: true,
      message: 'Registration set under review.',
      data: registration
    });

  } catch (error) {
    logger.error('Set under review error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to set registration under review.'
    });
  }
};

// Verify document
const verifyDocument = async (req, res) => {
  try {
    const { registrationId, documentId } = req.params;
    const { status, notes, reason } = req.body;
    const adminId = req.user.id;

    const document = await RegistrationDocument.findOne({
      where: {
        id: documentId,
        registrationId: registrationId
      }
    });

    if (!document) {
      return res.status(404).json({
        success: false,
        message: 'Document not found.'
      });
    }

    if (status === 'approved') {
      await document.approve(adminId, notes);
    } else if (status === 'rejected') {
      await document.reject(adminId, reason);
    }

    // Emit real-time notification
    const io = req.app.get('io');
    if (io) {
      io.to('admin-room').emit('document_updated', {
        type: 'document_verified',
        data: {
          registrationId,
          document: document.toJSON()
        }
      });
    }

    logger.info(`Document ${status}: ${documentId} by admin ${adminId}`);

    res.json({
      success: true,
      message: `Document ${status} successfully.`,
      data: document
    });

  } catch (error) {
    logger.error('Verify document error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to verify document.'
    });
  }
};

// Get registration documents
const getRegistrationDocuments = async (req, res) => {
  try {
    const { registrationId } = req.params;

    const documents = await RegistrationDocument.getByRegistrationId(registrationId);

    res.json({
      success: true,
      data: documents
    });

  } catch (error) {
    logger.error('Get registration documents error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch documents.'
    });
  }
};

// Bulk approve registrations
const bulkApproveRegistrations = async (req, res) => {
  try {
    const { registrationIds, notes } = req.body;
    const adminId = req.user.id;

    if (!Array.isArray(registrationIds) || registrationIds.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Registration IDs array is required.'
      });
    }

    const results = [];
    const io = req.app.get('io');

    for (const id of registrationIds) {
      try {
        const registration = await ServiceProviderRegistration.findByPk(id);
        
        if (registration && (registration.status === 'pending' || registration.status === 'under_review')) {
          await registration.approve(adminId, notes);
          results.push({ id, status: 'approved' });

          // Emit real-time notification
          if (io) {
            io.to('admin-room').emit('registration_updated', {
              type: 'registration_approved',
              data: registration.toJSON()
            });
          }
        } else {
          results.push({ id, status: 'skipped', reason: 'Invalid status or not found' });
        }
      } catch (error) {
        results.push({ id, status: 'error', reason: error.message });
      }
    }

    // Clear cache
    await redisUtils.del('registration_stats');

    logger.info(`Bulk approval completed by admin ${adminId}: ${results.length} registrations processed`);

    res.json({
      success: true,
      message: 'Bulk approval completed.',
      data: results
    });

  } catch (error) {
    logger.error('Bulk approve error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to perform bulk approval.'
    });
  }
};

// Bulk reject registrations
const bulkRejectRegistrations = async (req, res) => {
  try {
    const { registrationIds, reason } = req.body;
    const adminId = req.user.id;

    if (!Array.isArray(registrationIds) || registrationIds.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Registration IDs array is required.'
      });
    }

    if (!reason || reason.trim().length < 10) {
      return res.status(400).json({
        success: false,
        message: 'Rejection reason is required and must be at least 10 characters.'
      });
    }

    const results = [];
    const io = req.app.get('io');

    for (const id of registrationIds) {
      try {
        const registration = await ServiceProviderRegistration.findByPk(id);
        
        if (registration && (registration.status === 'pending' || registration.status === 'under_review')) {
          await registration.reject(adminId, reason);
          results.push({ id, status: 'rejected' });

          // Emit real-time notification
          if (io) {
            io.to('admin-room').emit('registration_updated', {
              type: 'registration_rejected',
              data: registration.toJSON()
            });
          }
        } else {
          results.push({ id, status: 'skipped', reason: 'Invalid status or not found' });
        }
      } catch (error) {
        results.push({ id, status: 'error', reason: error.message });
      }
    }

    // Clear cache
    await redisUtils.del('registration_stats');

    logger.info(`Bulk rejection completed by admin ${adminId}: ${results.length} registrations processed`);

    res.json({
      success: true,
      message: 'Bulk rejection completed.',
      data: results
    });

  } catch (error) {
    logger.error('Bulk reject error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to perform bulk rejection.'
    });
  }
};

module.exports = {
  approveRegistration,
  rejectRegistration,
  setUnderReview,
  verifyDocument,
  getRegistrationDocuments,
  bulkApproveRegistrations,
  bulkRejectRegistrations
};

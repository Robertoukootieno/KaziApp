const express = require('express');
const router = express.Router();

const {
  submitRegistration,
  getRegistrations,
  getPendingRegistrations,
  getRegistrationById,
  getRegistrationStatistics
} = require('../controllers/registrationController');

const {
  approveRegistration,
  rejectRegistration,
  setUnderReview,
  verifyDocument,
  getRegistrationDocuments,
  bulkApproveRegistrations,
  bulkRejectRegistrations
} = require('../controllers/adminController');

const { verifyToken, requireRole } = require('../middleware/auth');
const {
  validateRegistration,
  validateApproval,
  validateRejection,
  validateDocumentVerification,
  validateRegistrationQuery,
  validateUUID
} = require('../middleware/validation');

const {
  uploadRegistrationDocuments,
  processImages,
  handleUploadError,
  cleanupOnError
} = require('../middleware/upload');

// Public routes (for service providers)
router.post(
  '/service-provider/register',
  cleanupOnError,
  uploadRegistrationDocuments,
  handleUploadError,
  processImages,
  validateRegistration,
  submitRegistration
);

// Admin routes (require authentication)
router.use(verifyToken);

// Get all registrations
router.get(
  '/admin/registrations',
  requireRole(['super_admin', 'admin', 'moderator', 'reviewer']),
  validateRegistrationQuery,
  getRegistrations
);

// Get pending registrations
router.get(
  '/admin/registrations/pending',
  requireRole(['super_admin', 'admin', 'moderator', 'reviewer']),
  getPendingRegistrations
);

// Get registration statistics
router.get(
  '/admin/registrations/statistics',
  requireRole(['super_admin', 'admin', 'moderator', 'reviewer']),
  getRegistrationStatistics
);

// Get registration by ID
router.get(
  '/admin/registrations/:id',
  requireRole(['super_admin', 'admin', 'moderator', 'reviewer']),
  validateUUID('id'),
  getRegistrationById
);

// Get registration documents
router.get(
  '/admin/registrations/:registrationId/documents',
  requireRole(['super_admin', 'admin', 'moderator', 'reviewer']),
  validateUUID('registrationId'),
  getRegistrationDocuments
);

// Approve registration
router.post(
  '/admin/registrations/:id/approve',
  requireRole(['super_admin', 'admin', 'moderator']),
  validateApproval,
  approveRegistration
);

// Reject registration
router.post(
  '/admin/registrations/:id/reject',
  requireRole(['super_admin', 'admin', 'moderator']),
  validateRejection,
  rejectRegistration
);

// Set registration under review
router.post(
  '/admin/registrations/:id/under-review',
  requireRole(['super_admin', 'admin', 'moderator', 'reviewer']),
  validateUUID('id'),
  setUnderReview
);

// Verify document
router.post(
  '/admin/registrations/:registrationId/documents/:documentId/verify',
  requireRole(['super_admin', 'admin', 'moderator']),
  validateDocumentVerification,
  verifyDocument
);

// Bulk operations
router.post(
  '/admin/registrations/bulk/approve',
  requireRole(['super_admin', 'admin']),
  bulkApproveRegistrations
);

router.post(
  '/admin/registrations/bulk/reject',
  requireRole(['super_admin', 'admin']),
  bulkRejectRegistrations
);

module.exports = router;

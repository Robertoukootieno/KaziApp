const { body, param, query, validationResult } = require('express-validator');

// Handle validation errors
const handleValidationErrors = (req, res, next) => {
  const errors = validationResult(req);
  
  if (!errors.isEmpty()) {
    return res.status(400).json({
      success: false,
      message: 'Validation failed',
      errors: errors.array().map(error => ({
        field: error.path,
        message: error.msg,
        value: error.value
      }))
    });
  }
  
  next();
};

// Service Provider Registration validation
const validateRegistration = [
  body('businessName')
    .trim()
    .isLength({ min: 2, max: 100 })
    .withMessage('Business name must be between 2 and 100 characters'),
  
  body('ownerName')
    .trim()
    .isLength({ min: 2, max: 100 })
    .withMessage('Owner name must be between 2 and 100 characters'),
  
  body('email')
    .isEmail()
    .normalizeEmail()
    .withMessage('Please provide a valid email address'),
  
  body('phone')
    .isMobilePhone()
    .withMessage('Please provide a valid phone number'),
  
  body('location')
    .trim()
    .notEmpty()
    .withMessage('Location is required'),
  
  body('serviceType')
    .isIn([
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
    ])
    .withMessage('Invalid service type'),
  
  body('description')
    .optional()
    .trim()
    .isLength({ max: 1000 })
    .withMessage('Description must not exceed 1000 characters'),
  
  body('businessRegistrationNumber')
    .optional()
    .trim()
    .isLength({ max: 50 })
    .withMessage('Business registration number must not exceed 50 characters'),
  
  body('taxId')
    .optional()
    .trim()
    .isLength({ max: 50 })
    .withMessage('Tax ID must not exceed 50 characters'),
  
  body('yearsOfExperience')
    .optional()
    .isInt({ min: 0, max: 100 })
    .withMessage('Years of experience must be between 0 and 100'),
  
  handleValidationErrors
];

// Registration approval validation
const validateApproval = [
  param('id')
    .isUUID()
    .withMessage('Invalid registration ID'),
  
  body('notes')
    .optional()
    .trim()
    .isLength({ max: 1000 })
    .withMessage('Notes must not exceed 1000 characters'),
  
  handleValidationErrors
];

// Registration rejection validation
const validateRejection = [
  param('id')
    .isUUID()
    .withMessage('Invalid registration ID'),
  
  body('reason')
    .trim()
    .notEmpty()
    .isLength({ min: 10, max: 1000 })
    .withMessage('Rejection reason must be between 10 and 1000 characters'),
  
  handleValidationErrors
];

// Document verification validation
const validateDocumentVerification = [
  param('registrationId')
    .isUUID()
    .withMessage('Invalid registration ID'),
  
  param('documentId')
    .isUUID()
    .withMessage('Invalid document ID'),
  
  body('status')
    .isIn(['approved', 'rejected'])
    .withMessage('Status must be either approved or rejected'),
  
  body('notes')
    .optional()
    .trim()
    .isLength({ max: 500 })
    .withMessage('Notes must not exceed 500 characters'),
  
  body('reason')
    .if(body('status').equals('rejected'))
    .trim()
    .notEmpty()
    .isLength({ min: 10, max: 500 })
    .withMessage('Rejection reason is required and must be between 10 and 500 characters'),
  
  handleValidationErrors
];

// Query parameter validation for listing registrations
const validateRegistrationQuery = [
  query('page')
    .optional()
    .isInt({ min: 1 })
    .withMessage('Page must be a positive integer'),
  
  query('limit')
    .optional()
    .isInt({ min: 1, max: 100 })
    .withMessage('Limit must be between 1 and 100'),
  
  query('status')
    .optional()
    .isIn(['pending', 'approved', 'rejected', 'under_review', 'all'])
    .withMessage('Invalid status filter'),
  
  query('serviceType')
    .optional()
    .trim()
    .isLength({ min: 1, max: 50 })
    .withMessage('Service type filter must not exceed 50 characters'),
  
  query('search')
    .optional()
    .trim()
    .isLength({ min: 1, max: 100 })
    .withMessage('Search query must not exceed 100 characters'),
  
  handleValidationErrors
];

// Admin user validation
const validateAdminUser = [
  body('name')
    .trim()
    .isLength({ min: 2, max: 100 })
    .withMessage('Name must be between 2 and 100 characters'),
  
  body('email')
    .isEmail()
    .normalizeEmail()
    .withMessage('Please provide a valid email address'),
  
  body('password')
    .isLength({ min: 6 })
    .withMessage('Password must be at least 6 characters long'),
  
  body('role')
    .optional()
    .isIn(['super_admin', 'admin', 'moderator', 'reviewer'])
    .withMessage('Invalid role'),
  
  handleValidationErrors
];

// Login validation
const validateLogin = [
  body('email')
    .isEmail()
    .normalizeEmail()
    .withMessage('Please provide a valid email address'),
  
  body('password')
    .notEmpty()
    .withMessage('Password is required'),
  
  handleValidationErrors
];

// UUID parameter validation
const validateUUID = (paramName = 'id') => [
  param(paramName)
    .isUUID()
    .withMessage(`Invalid ${paramName}`),
  
  handleValidationErrors
];

module.exports = {
  handleValidationErrors,
  validateRegistration,
  validateApproval,
  validateRejection,
  validateDocumentVerification,
  validateRegistrationQuery,
  validateAdminUser,
  validateLogin,
  validateUUID
};

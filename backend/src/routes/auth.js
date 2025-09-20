const express = require('express');
const router = express.Router();

const {
  login,
  logout,
  refreshToken,
  getProfile,
  updateProfile,
  changePassword
} = require('../controllers/authController');

const { verifyToken } = require('../middleware/auth');
const { validateLogin } = require('../middleware/validation');
const { body } = require('express-validator');

// Public routes
router.post('/login', validateLogin, login);
router.post('/refresh-token', refreshToken);

// Protected routes
router.use(verifyToken);

router.post('/logout', logout);
router.get('/profile', getProfile);

router.put('/profile', [
  body('name')
    .optional()
    .trim()
    .isLength({ min: 2, max: 100 })
    .withMessage('Name must be between 2 and 100 characters'),
  
  body('phone')
    .optional()
    .isMobilePhone()
    .withMessage('Please provide a valid phone number'),
  
  body('department')
    .optional()
    .trim()
    .isLength({ max: 100 })
    .withMessage('Department must not exceed 100 characters')
], updateProfile);

router.put('/change-password', [
  body('currentPassword')
    .notEmpty()
    .withMessage('Current password is required'),
  
  body('newPassword')
    .isLength({ min: 6 })
    .withMessage('New password must be at least 6 characters long')
], changePassword);

module.exports = router;

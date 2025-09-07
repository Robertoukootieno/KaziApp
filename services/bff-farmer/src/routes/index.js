const express = require('express');
const dashboardRoutes = require('./dashboard');
const farmRoutes = require('./farm');
const marketplaceRoutes = require('./marketplace');
const vetRoutes = require('./veterinary');
const communicationRoutes = require('./communication');
const profileRoutes = require('./profile');

const router = express.Router();

// Farmer-specific routes with tailored responses
router.use('/dashboard', dashboardRoutes);
router.use('/farm', farmRoutes);
router.use('/marketplace', marketplaceRoutes);
router.use('/veterinary', vetRoutes);
router.use('/communication', communicationRoutes);
router.use('/profile', profileRoutes);

module.exports = router;

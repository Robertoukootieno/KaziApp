const express = require('express');
const serviceClient = require('../services/serviceClient');
const dataTransformer = require('../utils/dataTransformer');
const logger = require('../utils/logger');

const router = express.Router();

/**
 * Get admin dashboard overview
 * Comprehensive platform statistics and insights
 */
router.get('/', async (req, res) => {
  try {
    const userId = req.user.id;
    const userType = req.user.type;
    
    if (userType !== 'admin') {
      return res.status(403).json({
        success: false,
        error: 'Access denied. Admin account required.',
      });
    }

    // Fetch comprehensive platform data
    const [
      usersData,
      transactionsData,
      appointmentsData,
      marketplaceData,
      systemHealthData,
      analyticsData,
    ] = await Promise.allSettled([
      serviceClient.get('/users/statistics'),
      serviceClient.get('/payments/statistics'),
      serviceClient.get('/matching/statistics'),
      serviceClient.get('/marketplace/statistics'),
      serviceClient.get('/system/health'),
      serviceClient.get('/analytics/platform-overview'),
    ]);

    // Transform data for admin dashboard
    const dashboardData = {
      overview: {
        totalUsers: usersData.status === 'fulfilled' ? 
          usersData.value.data?.total || 0 : 0,
        activeUsers: usersData.status === 'fulfilled' ? 
          usersData.value.data?.active || 0 : 0,
        newUsersToday: usersData.status === 'fulfilled' ? 
          usersData.value.data?.newToday || 0 : 0,
        userGrowth: usersData.status === 'fulfilled' ? 
          dataTransformer.calculateGrowthRate(usersData.value.data) : 0,
      },
      userBreakdown: usersData.status === 'fulfilled' ? 
        dataTransformer.transformUserBreakdown(usersData.value.data) : {},
      transactions: {
        totalVolume: transactionsData.status === 'fulfilled' ? 
          transactionsData.value.data?.totalVolume || 0 : 0,
        todayVolume: transactionsData.status === 'fulfilled' ? 
          transactionsData.value.data?.todayVolume || 0 : 0,
        successRate: transactionsData.status === 'fulfilled' ? 
          transactionsData.value.data?.successRate || 0 : 0,
        averageTransaction: transactionsData.status === 'fulfilled' ? 
          transactionsData.value.data?.averageAmount || 0 : 0,
      },
      appointments: {
        total: appointmentsData.status === 'fulfilled' ? 
          appointmentsData.value.data?.total || 0 : 0,
        completed: appointmentsData.status === 'fulfilled' ? 
          appointmentsData.value.data?.completed || 0 : 0,
        pending: appointmentsData.status === 'fulfilled' ? 
          appointmentsData.value.data?.pending || 0 : 0,
        completionRate: appointmentsData.status === 'fulfilled' ? 
          dataTransformer.calculateCompletionRate(appointmentsData.value.data) : 0,
      },
      marketplace: {
        activeListings: marketplaceData.status === 'fulfilled' ? 
          marketplaceData.value.data?.activeListings || 0 : 0,
        totalSales: marketplaceData.status === 'fulfilled' ? 
          marketplaceData.value.data?.totalSales || 0 : 0,
        averagePrice: marketplaceData.status === 'fulfilled' ? 
          marketplaceData.value.data?.averagePrice || 0 : 0,
        topCategories: marketplaceData.status === 'fulfilled' ? 
          dataTransformer.transformTopCategories(marketplaceData.value.data) : [],
      },
      systemHealth: {
        overall: systemHealthData.status === 'fulfilled' ? 
          systemHealthData.value.data?.overall || 'unknown' : 'unknown',
        services: systemHealthData.status === 'fulfilled' ? 
          dataTransformer.transformServiceHealth(systemHealthData.value.data) : [],
        uptime: systemHealthData.status === 'fulfilled' ? 
          systemHealthData.value.data?.uptime || 0 : 0,
        responseTime: systemHealthData.status === 'fulfilled' ? 
          systemHealthData.value.data?.averageResponseTime || 0 : 0,
      },
      analytics: {
        pageViews: analyticsData.status === 'fulfilled' ? 
          analyticsData.value.data?.pageViews || 0 : 0,
        sessionDuration: analyticsData.status === 'fulfilled' ? 
          analyticsData.value.data?.averageSessionDuration || 0 : 0,
        bounceRate: analyticsData.status === 'fulfilled' ? 
          analyticsData.value.data?.bounceRate || 0 : 0,
        topPages: analyticsData.status === 'fulfilled' ? 
          dataTransformer.transformTopPages(analyticsData.value.data) : [],
      },
      recentActivity: await getRecentPlatformActivity(),
      alerts: await getPlatformAlerts(),
      quickStats: [
        {
          label: 'Total Revenue',
          value: transactionsData.status === 'fulfilled' ? 
            `KES ${(transactionsData.value.data?.totalVolume || 0).toLocaleString()}` : 'KES 0',
          change: transactionsData.status === 'fulfilled' ? 
            dataTransformer.calculateRevenueGrowth(transactionsData.value.data) : 0,
          icon: 'revenue',
        },
        {
          label: 'Active Farmers',
          value: usersData.status === 'fulfilled' ? 
            (usersData.value.data?.farmers?.active || 0).toLocaleString() : '0',
          change: usersData.status === 'fulfilled' ? 
            dataTransformer.calculateFarmerGrowth(usersData.value.data) : 0,
          icon: 'farmers',
        },
        {
          label: 'Vet Consultations',
          value: appointmentsData.status === 'fulfilled' ? 
            (appointmentsData.value.data?.thisMonth || 0).toLocaleString() : '0',
          change: appointmentsData.status === 'fulfilled' ? 
            dataTransformer.calculateConsultationGrowth(appointmentsData.value.data) : 0,
          icon: 'consultations',
        },
        {
          label: 'System Uptime',
          value: systemHealthData.status === 'fulfilled' ? 
            `${(systemHealthData.value.data?.uptime || 0).toFixed(2)}%` : '0%',
          change: 0,
          icon: 'uptime',
        },
      ],
    };

    res.json({
      success: true,
      data: dashboardData,
      timestamp: new Date().toISOString(),
    });

  } catch (error) {
    logger.error('Admin dashboard data fetch error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to load dashboard data',
      timestamp: new Date().toISOString(),
    });
  }
});

/**
 * Get detailed analytics data
 */
router.get('/analytics', async (req, res) => {
  try {
    const period = req.query.period || '30d';
    const metric = req.query.metric || 'overview';
    
    const analyticsData = await serviceClient.get('/analytics/detailed', { 
      period, 
      metric,
      adminId: req.user.id 
    });

    const transformedData = dataTransformer.transformAnalyticsData(
      analyticsData.data, 
      period, 
      metric
    );

    res.json({
      success: true,
      data: transformedData,
      period,
      metric,
      timestamp: new Date().toISOString(),
    });

  } catch (error) {
    logger.error('Analytics data fetch error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to load analytics data',
      timestamp: new Date().toISOString(),
    });
  }
});

/**
 * Get platform alerts and notifications
 */
router.get('/alerts', async (req, res) => {
  try {
    const severity = req.query.severity || 'all';
    const limit = parseInt(req.query.limit) || 50;
    
    const alertsData = await serviceClient.get('/system/alerts', { 
      severity, 
      limit,
      adminId: req.user.id 
    });

    const alerts = dataTransformer.transformPlatformAlerts(alertsData.data);

    res.json({
      success: true,
      data: alerts,
      timestamp: new Date().toISOString(),
    });

  } catch (error) {
    logger.error('Alerts fetch error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to load alerts',
      timestamp: new Date().toISOString(),
    });
  }
});

/**
 * Get recent platform activity
 */
async function getRecentPlatformActivity() {
  try {
    const activities = await serviceClient.get('/system/recent-activity', { limit: 10 });
    return dataTransformer.transformRecentActivity(activities.data);
  } catch (error) {
    logger.error('Error fetching recent activity:', error);
    return [];
  }
}

/**
 * Get platform alerts
 */
async function getPlatformAlerts() {
  try {
    const alerts = await serviceClient.get('/system/alerts', { 
      severity: 'high',
      limit: 5 
    });
    return dataTransformer.transformPlatformAlerts(alerts.data);
  } catch (error) {
    logger.error('Error fetching platform alerts:', error);
    return [];
  }
}

module.exports = router;

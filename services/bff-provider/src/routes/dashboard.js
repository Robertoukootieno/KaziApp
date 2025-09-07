const express = require('express');
const serviceClient = require('../services/serviceClient');
const dataTransformer = require('../utils/dataTransformer');
const logger = require('../utils/logger');

const router = express.Router();

/**
 * Get service provider dashboard data
 * Tailored for veterinarians and other service providers
 */
router.get('/', async (req, res) => {
  try {
    const userId = req.user.id;
    const userType = req.user.type;
    
    if (!['veterinarian', 'buyer', 'vendor'].includes(userType)) {
      return res.status(403).json({
        success: false,
        error: 'Access denied. Service provider account required.',
      });
    }

    // Fetch data from multiple services in parallel
    const [
      appointmentsData,
      clientsData,
      earningsData,
      communicationData,
      reviewsData,
    ] = await Promise.allSettled([
      serviceClient.get('/matching/appointments', { providerId: userId }),
      serviceClient.get('/matching/clients', { providerId: userId }),
      serviceClient.get('/payments/earnings', { providerId: userId }),
      serviceClient.get('/communication/recent-messages', { userId, limit: 10 }),
      serviceClient.get('/matching/reviews', { providerId: userId }),
    ]);

    // Transform data for service provider app
    const dashboardData = {
      user: dataTransformer.transformProviderProfile(req.user),
      appointments: {
        today: appointmentsData.status === 'fulfilled' ? 
          dataTransformer.getTodayAppointments(appointmentsData.value.data) : [],
        upcoming: appointmentsData.status === 'fulfilled' ? 
          dataTransformer.getUpcomingAppointments(appointmentsData.value.data) : [],
        total: appointmentsData.status === 'fulfilled' ? 
          appointmentsData.value.data?.length || 0 : 0,
        pending: appointmentsData.status === 'fulfilled' ? 
          appointmentsData.value.data?.filter(a => a.status === 'pending').length || 0 : 0,
      },
      clients: {
        total: clientsData.status === 'fulfilled' ? 
          clientsData.value.data?.length || 0 : 0,
        active: clientsData.status === 'fulfilled' ? 
          clientsData.value.data?.filter(c => c.status === 'active').length || 0 : 0,
        recent: clientsData.status === 'fulfilled' ? 
          dataTransformer.transformRecentClients(clientsData.value.data) : [],
      },
      earnings: {
        thisMonth: earningsData.status === 'fulfilled' ? 
          earningsData.value.data?.thisMonth || 0 : 0,
        lastMonth: earningsData.status === 'fulfilled' ? 
          earningsData.value.data?.lastMonth || 0 : 0,
        pending: earningsData.status === 'fulfilled' ? 
          earningsData.value.data?.pending || 0 : 0,
        trend: earningsData.status === 'fulfilled' ? 
          dataTransformer.calculateEarningsTrend(earningsData.value.data) : 0,
      },
      communication: {
        unreadMessages: communicationData.status === 'fulfilled' ? 
          communicationData.value.data?.filter(m => !m.read).length || 0 : 0,
        activeChats: communicationData.status === 'fulfilled' ? 
          dataTransformer.getActiveChats(communicationData.value.data) : [],
      },
      performance: {
        rating: reviewsData.status === 'fulfilled' ? 
          dataTransformer.calculateAverageRating(reviewsData.value.data) : 0,
        totalReviews: reviewsData.status === 'fulfilled' ? 
          reviewsData.value.data?.length || 0 : 0,
        responseTime: reviewsData.status === 'fulfilled' ? 
          dataTransformer.calculateAverageResponseTime(reviewsData.value.data) : 0,
      },
      quickActions: [
        {
          id: 'view_appointments',
          title: 'Today\'s Appointments',
          icon: 'calendar',
          route: '/appointments/today',
          badge: appointmentsData.status === 'fulfilled' ? 
            dataTransformer.getTodayAppointments(appointmentsData.value.data).length : 0,
        },
        {
          id: 'client_requests',
          title: 'Client Requests',
          icon: 'requests',
          route: '/requests',
          badge: appointmentsData.status === 'fulfilled' ? 
            appointmentsData.value.data?.filter(a => a.status === 'pending').length || 0 : 0,
        },
        {
          id: 'earnings_report',
          title: 'Earnings Report',
          icon: 'earnings',
          route: '/earnings',
        },
        {
          id: 'client_directory',
          title: 'Client Directory',
          icon: 'clients',
          route: '/clients',
        },
      ],
      insights: await generateProviderInsights(userId, userType, req.user),
    };

    res.json({
      success: true,
      data: dashboardData,
      timestamp: new Date().toISOString(),
    });

  } catch (error) {
    logger.error('Provider dashboard data fetch error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to load dashboard data',
      timestamp: new Date().toISOString(),
    });
  }
});

/**
 * Get provider performance metrics
 */
router.get('/performance', async (req, res) => {
  try {
    const userId = req.user.id;
    const period = req.query.period || '30d';
    
    const [performanceData, earningsData, clientData] = await Promise.allSettled([
      serviceClient.get('/matching/performance', { providerId: userId, period }),
      serviceClient.get('/payments/earnings-breakdown', { providerId: userId, period }),
      serviceClient.get('/matching/client-analytics', { providerId: userId, period }),
    ]);

    const performance = {
      period,
      appointments: performanceData.status === 'fulfilled' ? 
        dataTransformer.transformAppointmentMetrics(performanceData.value.data) : null,
      earnings: earningsData.status === 'fulfilled' ? 
        dataTransformer.transformEarningsMetrics(earningsData.value.data) : null,
      clients: clientData.status === 'fulfilled' ? 
        dataTransformer.transformClientMetrics(clientData.value.data) : null,
      trends: performanceData.status === 'fulfilled' ? 
        dataTransformer.transformPerformanceTrends(performanceData.value.data) : [],
    };

    res.json({
      success: true,
      data: performance,
      timestamp: new Date().toISOString(),
    });

  } catch (error) {
    logger.error('Performance metrics fetch error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to load performance metrics',
      timestamp: new Date().toISOString(),
    });
  }
});

/**
 * Generate personalized insights for service provider
 */
async function generateProviderInsights(userId, userType, user) {
  try {
    const insights = [];

    // Veterinarian-specific insights
    if (userType === 'veterinarian') {
      insights.push(
        {
          id: 'busy_season',
          type: 'seasonal',
          title: 'Peak Season Approaching',
          description: 'Livestock vaccination season is coming. Expect 40% more requests.',
          priority: 'high',
          action: {
            label: 'Prepare Schedule',
            route: '/calendar/bulk-schedule',
          },
        },
        {
          id: 'client_retention',
          type: 'business',
          title: 'Client Retention Opportunity',
          description: '5 clients haven\'t booked in 3 months. Consider reaching out.',
          priority: 'medium',
          action: {
            label: 'View Clients',
            route: '/clients/inactive',
          },
        }
      );
    }

    // Buyer-specific insights
    if (userType === 'buyer') {
      insights.push(
        {
          id: 'market_opportunity',
          type: 'market',
          title: 'New Suppliers Available',
          description: '12 new maize suppliers in your area with competitive prices.',
          priority: 'medium',
          action: {
            label: 'Browse Suppliers',
            route: '/marketplace/suppliers?crop=maize',
          },
        }
      );
    }

    // General insights
    insights.push(
      {
        id: 'rating_improvement',
        type: 'performance',
        title: 'Maintain High Rating',
        description: 'Your 4.8-star rating is excellent. Keep up the great service!',
        priority: 'low',
        action: {
          label: 'View Reviews',
          route: '/reviews',
        },
      }
    );

    return insights;
  } catch (error) {
    logger.error('Error generating provider insights:', error);
    return [];
  }
}

module.exports = router;

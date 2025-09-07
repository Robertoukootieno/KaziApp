const express = require('express');
const serviceClient = require('../services/serviceClient');
const dataTransformer = require('../utils/dataTransformer');
const logger = require('../utils/logger');

const router = express.Router();

/**
 * Get farmer dashboard data
 * Aggregates data from multiple services and shapes it for mobile consumption
 */
router.get('/', async (req, res) => {
  try {
    const userId = req.user.id;
    const userType = req.user.type;
    
    if (userType !== 'farmer') {
      return res.status(403).json({
        success: false,
        error: 'Access denied. Farmer account required.',
      });
    }

    // Fetch data from multiple services in parallel
    const [
      farmsData,
      marketplaceData,
      communicationData,
      weatherData,
      alertsData,
    ] = await Promise.allSettled([
      serviceClient.get('/farm-management/farms', { userId }),
      serviceClient.get('/marketplace/my-listings', { userId }),
      serviceClient.get('/communication/recent-messages', { userId, limit: 5 }),
      serviceClient.get('/external/weather', { county: req.user.county }),
      serviceClient.get('/notification/alerts', { userId, unreadOnly: true }),
    ]);

    // Transform data for farmer mobile app
    const dashboardData = {
      user: dataTransformer.transformUserProfile(req.user),
      farms: {
        total: farmsData.status === 'fulfilled' ? farmsData.value.data?.length || 0 : 0,
        active: farmsData.status === 'fulfilled' ? 
          farmsData.value.data?.filter(f => f.status === 'active').length || 0 : 0,
        summary: farmsData.status === 'fulfilled' ? 
          dataTransformer.transformFarmsSummary(farmsData.value.data) : null,
      },
      marketplace: {
        activeListings: marketplaceData.status === 'fulfilled' ? 
          marketplaceData.value.data?.length || 0 : 0,
        totalRevenue: marketplaceData.status === 'fulfilled' ? 
          dataTransformer.calculateTotalRevenue(marketplaceData.value.data) : 0,
        recentSales: marketplaceData.status === 'fulfilled' ? 
          dataTransformer.transformRecentSales(marketplaceData.value.data) : [],
      },
      communication: {
        unreadMessages: communicationData.status === 'fulfilled' ? 
          communicationData.value.data?.filter(m => !m.read).length || 0 : 0,
        recentChats: communicationData.status === 'fulfilled' ? 
          dataTransformer.transformRecentChats(communicationData.value.data) : [],
      },
      weather: weatherData.status === 'fulfilled' ? 
        dataTransformer.transformWeatherData(weatherData.value.data) : null,
      alerts: {
        count: alertsData.status === 'fulfilled' ? 
          alertsData.value.data?.length || 0 : 0,
        urgent: alertsData.status === 'fulfilled' ? 
          alertsData.value.data?.filter(a => a.priority === 'urgent').length || 0 : 0,
        recent: alertsData.status === 'fulfilled' ? 
          dataTransformer.transformAlerts(alertsData.value.data?.slice(0, 3)) : [],
      },
      quickActions: [
        {
          id: 'add_farm_record',
          title: 'Add Farm Record',
          icon: 'farm',
          route: '/farm/records/add',
        },
        {
          id: 'find_veterinarian',
          title: 'Find Veterinarian',
          icon: 'veterinary',
          route: '/veterinary/find',
        },
        {
          id: 'sell_produce',
          title: 'Sell Produce',
          icon: 'marketplace',
          route: '/marketplace/sell',
        },
        {
          id: 'check_weather',
          title: 'Weather Forecast',
          icon: 'weather',
          route: '/weather',
        },
      ],
      recommendations: await generateFarmerRecommendations(userId, req.user),
    };

    res.json({
      success: true,
      data: dashboardData,
      timestamp: new Date().toISOString(),
    });

  } catch (error) {
    logger.error('Dashboard data fetch error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to load dashboard data',
      timestamp: new Date().toISOString(),
    });
  }
});

/**
 * Get farmer statistics
 */
router.get('/stats', async (req, res) => {
  try {
    const userId = req.user.id;
    const period = req.query.period || '30d'; // 7d, 30d, 90d, 1y
    
    const [farmStats, marketplaceStats, communicationStats] = await Promise.allSettled([
      serviceClient.get('/farm-management/stats', { userId, period }),
      serviceClient.get('/marketplace/stats', { userId, period }),
      serviceClient.get('/communication/stats', { userId, period }),
    ]);

    const stats = {
      period,
      farm: farmStats.status === 'fulfilled' ? 
        dataTransformer.transformFarmStats(farmStats.value.data) : null,
      marketplace: marketplaceStats.status === 'fulfilled' ? 
        dataTransformer.transformMarketplaceStats(marketplaceStats.value.data) : null,
      communication: communicationStats.status === 'fulfilled' ? 
        dataTransformer.transformCommunicationStats(communicationStats.value.data) : null,
    };

    res.json({
      success: true,
      data: stats,
      timestamp: new Date().toISOString(),
    });

  } catch (error) {
    logger.error('Stats fetch error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to load statistics',
      timestamp: new Date().toISOString(),
    });
  }
});

/**
 * Generate personalized recommendations for farmer
 */
async function generateFarmerRecommendations(userId, user) {
  try {
    // This would typically call an AI/ML service for personalized recommendations
    const recommendations = [
      {
        id: 'weather_alert',
        type: 'weather',
        title: 'Rain Expected This Week',
        description: 'Perfect time to plant your maize. Check soil moisture levels.',
        priority: 'medium',
        action: {
          label: 'View Weather Details',
          route: '/weather/forecast',
        },
      },
      {
        id: 'market_opportunity',
        type: 'marketplace',
        title: 'High Demand for Tomatoes',
        description: 'Tomato prices are up 15% in your area. Consider listing your harvest.',
        priority: 'high',
        action: {
          label: 'Create Listing',
          route: '/marketplace/sell?crop=tomatoes',
        },
      },
      {
        id: 'vet_consultation',
        type: 'veterinary',
        title: 'Livestock Health Check',
        description: 'It\'s been 3 months since your last vet visit. Schedule a check-up.',
        priority: 'low',
        action: {
          label: 'Find Veterinarian',
          route: '/veterinary/find',
        },
      },
    ];

    return recommendations;
  } catch (error) {
    logger.error('Error generating recommendations:', error);
    return [];
  }
}

module.exports = router;

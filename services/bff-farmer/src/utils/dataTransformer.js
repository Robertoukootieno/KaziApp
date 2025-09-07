const _ = require('lodash');
const moment = require('moment');

/**
 * Data transformation utilities for farmer BFF
 * Shapes backend data for optimal mobile consumption
 */
class DataTransformer {
  /**
   * Transform user profile for farmer mobile app
   */
  transformUserProfile(user) {
    return {
      id: user.id,
      name: `${user.firstName} ${user.lastName}`,
      phoneNumber: user.phoneNumber,
      email: user.email,
      profilePicture: user.profilePicture,
      location: {
        county: user.county,
        subCounty: user.subCounty,
        ward: user.ward,
      },
      language: user.preferredLanguage,
      verified: user.isPhoneVerified,
      memberSince: moment(user.createdAt).format('MMMM YYYY'),
      lastActive: moment(user.lastLoginAt).fromNow(),
    };
  }

  /**
   * Transform farms data for dashboard summary
   */
  transformFarmsSummary(farms) {
    if (!farms || farms.length === 0) {
      return {
        totalSize: 0,
        totalCrops: 0,
        totalLivestock: 0,
        recentActivity: [],
      };
    }

    const totalSize = farms.reduce((sum, farm) => sum + (farm.size || 0), 0);
    const allCrops = farms.flatMap(farm => farm.crops || []);
    const allLivestock = farms.flatMap(farm => farm.livestock || []);

    return {
      totalSize: Math.round(totalSize * 100) / 100,
      sizeUnit: farms[0]?.sizeUnit || 'acres',
      totalCrops: _.uniq(allCrops).length,
      totalLivestock: allLivestock.reduce((sum, animal) => sum + (animal.count || 0), 0),
      recentActivity: this.extractRecentFarmActivity(farms),
    };
  }

  /**
   * Extract recent farm activity
   */
  extractRecentFarmActivity(farms) {
    const activities = [];
    
    farms.forEach(farm => {
      if (farm.lastActivity) {
        activities.push({
          farmName: farm.name,
          activity: farm.lastActivity.type,
          description: farm.lastActivity.description,
          date: moment(farm.lastActivity.date).fromNow(),
          icon: this.getActivityIcon(farm.lastActivity.type),
        });
      }
    });

    return _.orderBy(activities, ['date'], ['desc']).slice(0, 5);
  }

  /**
   * Get icon for activity type
   */
  getActivityIcon(activityType) {
    const iconMap = {
      planting: 'seedling',
      harvesting: 'harvest',
      watering: 'water',
      fertilizing: 'fertilizer',
      veterinary: 'medical',
      feeding: 'feed',
      default: 'farm',
    };

    return iconMap[activityType] || iconMap.default;
  }

  /**
   * Calculate total revenue from marketplace data
   */
  calculateTotalRevenue(listings) {
    if (!listings || listings.length === 0) return 0;

    return listings.reduce((total, listing) => {
      const sold = listing.quantitySold || 0;
      const price = listing.price || 0;
      return total + (sold * price);
    }, 0);
  }

  /**
   * Transform recent sales data
   */
  transformRecentSales(listings) {
    if (!listings || listings.length === 0) return [];

    const recentSales = listings
      .filter(listing => listing.quantitySold > 0)
      .map(listing => ({
        id: listing.id,
        productName: listing.name,
        quantity: listing.quantitySold,
        unit: listing.unit,
        price: listing.price,
        totalAmount: listing.quantitySold * listing.price,
        soldDate: moment(listing.lastSaleDate).fromNow(),
        buyerName: listing.lastBuyer?.name || 'Anonymous',
        status: 'completed',
      }))
      .sort((a, b) => new Date(b.soldDate) - new Date(a.soldDate))
      .slice(0, 5);

    return recentSales;
  }

  /**
   * Transform recent chats data
   */
  transformRecentChats(messages) {
    if (!messages || messages.length === 0) return [];

    const chatGroups = _.groupBy(messages, 'conversationId');
    
    const recentChats = Object.values(chatGroups).map(chatMessages => {
      const latestMessage = _.maxBy(chatMessages, 'createdAt');
      const unreadCount = chatMessages.filter(m => !m.read).length;
      
      return {
        conversationId: latestMessage.conversationId,
        participantName: latestMessage.sender?.name || 'Unknown',
        participantType: latestMessage.sender?.type || 'user',
        participantAvatar: latestMessage.sender?.profilePicture,
        lastMessage: {
          text: latestMessage.message,
          timestamp: moment(latestMessage.createdAt).fromNow(),
          type: latestMessage.type,
        },
        unreadCount,
        isOnline: latestMessage.sender?.isOnline || false,
      };
    });

    return _.orderBy(recentChats, ['lastMessage.timestamp'], ['desc']).slice(0, 5);
  }

  /**
   * Transform weather data for farmer dashboard
   */
  transformWeatherData(weatherData) {
    if (!weatherData) return null;

    return {
      current: {
        temperature: weatherData.current?.temperature,
        condition: weatherData.current?.condition,
        humidity: weatherData.current?.humidity,
        windSpeed: weatherData.current?.windSpeed,
        icon: this.getWeatherIcon(weatherData.current?.condition),
      },
      forecast: weatherData.forecast?.slice(0, 5).map(day => ({
        date: moment(day.date).format('ddd'),
        high: day.high,
        low: day.low,
        condition: day.condition,
        precipitation: day.precipitation,
        icon: this.getWeatherIcon(day.condition),
      })),
      alerts: weatherData.alerts?.map(alert => ({
        type: alert.type,
        severity: alert.severity,
        message: alert.message,
        validUntil: moment(alert.validUntil).fromNow(),
      })),
    };
  }

  /**
   * Get weather icon based on condition
   */
  getWeatherIcon(condition) {
    const iconMap = {
      sunny: 'sun',
      cloudy: 'cloud',
      rainy: 'rain',
      stormy: 'storm',
      windy: 'wind',
      default: 'weather',
    };

    return iconMap[condition?.toLowerCase()] || iconMap.default;
  }

  /**
   * Transform alerts data
   */
  transformAlerts(alerts) {
    if (!alerts || alerts.length === 0) return [];

    return alerts.map(alert => ({
      id: alert.id,
      title: alert.title,
      message: alert.message,
      type: alert.type,
      priority: alert.priority,
      timestamp: moment(alert.createdAt).fromNow(),
      icon: this.getAlertIcon(alert.type),
      actionRequired: alert.actionRequired || false,
    }));
  }

  /**
   * Get alert icon based on type
   */
  getAlertIcon(alertType) {
    const iconMap = {
      weather: 'weather-alert',
      disease: 'medical-alert',
      market: 'market-alert',
      veterinary: 'vet-alert',
      system: 'info',
      default: 'alert',
    };

    return iconMap[alertType] || iconMap.default;
  }

  /**
   * Transform farm statistics
   */
  transformFarmStats(stats) {
    if (!stats) return null;

    return {
      productivity: {
        current: stats.productivity?.current || 0,
        previous: stats.productivity?.previous || 0,
        change: this.calculatePercentageChange(
          stats.productivity?.current,
          stats.productivity?.previous
        ),
      },
      revenue: {
        current: stats.revenue?.current || 0,
        previous: stats.revenue?.previous || 0,
        change: this.calculatePercentageChange(
          stats.revenue?.current,
          stats.revenue?.previous
        ),
      },
      expenses: {
        current: stats.expenses?.current || 0,
        previous: stats.expenses?.previous || 0,
        change: this.calculatePercentageChange(
          stats.expenses?.current,
          stats.expenses?.previous
        ),
      },
      activities: stats.activities || 0,
      trends: this.transformTrendData(stats.trends),
    };
  }

  /**
   * Transform marketplace statistics
   */
  transformMarketplaceStats(stats) {
    if (!stats) return null;

    return {
      sales: {
        count: stats.sales?.count || 0,
        revenue: stats.sales?.revenue || 0,
        averagePrice: stats.sales?.averagePrice || 0,
      },
      listings: {
        active: stats.listings?.active || 0,
        sold: stats.listings?.sold || 0,
        views: stats.listings?.views || 0,
      },
      performance: {
        conversionRate: stats.performance?.conversionRate || 0,
        averageTimeToSell: stats.performance?.averageTimeToSell || 0,
        customerRating: stats.performance?.customerRating || 0,
      },
    };
  }

  /**
   * Transform communication statistics
   */
  transformCommunicationStats(stats) {
    if (!stats) return null;

    return {
      messages: {
        sent: stats.messages?.sent || 0,
        received: stats.messages?.received || 0,
        responseTime: stats.messages?.averageResponseTime || 0,
      },
      consultations: {
        requested: stats.consultations?.requested || 0,
        completed: stats.consultations?.completed || 0,
        rating: stats.consultations?.averageRating || 0,
      },
      connections: {
        veterinarians: stats.connections?.veterinarians || 0,
        buyers: stats.connections?.buyers || 0,
        farmers: stats.connections?.farmers || 0,
      },
    };
  }

  /**
   * Calculate percentage change
   */
  calculatePercentageChange(current, previous) {
    if (!previous || previous === 0) return 0;
    return Math.round(((current - previous) / previous) * 100);
  }

  /**
   * Transform trend data for charts
   */
  transformTrendData(trends) {
    if (!trends || trends.length === 0) return [];

    return trends.map(point => ({
      date: moment(point.date).format('MMM DD'),
      value: point.value,
      label: point.label,
    }));
  }
}

const dataTransformer = new DataTransformer();

module.exports = dataTransformer;

const axios = require('axios');
const moment = require('moment');
const logger = require('../utils/logger');
const redisClient = require('../config/redis');
const { calculateDistance } = require('../utils/geoUtils');

class ClimateService {
  constructor() {
    this.weatherApiKey = process.env.WEATHER_API_KEY;
    this.weatherApiUrl = process.env.WEATHER_API_URL || 'https://api.openweathermap.org/data/2.5';
    this.kmdApiUrl = process.env.KMD_API_URL || 'https://api.meteo.go.ke'; // Kenya Meteorological Department
    this.faoApiUrl = process.env.FAO_API_URL || 'https://api.fao.org/v1';
    
    // Kenya-specific weather stations for more accurate local data
    this.kenyaWeatherStations = [
      { name: 'Nairobi', lat: -1.2921, lon: 36.8219, county: 'Nairobi' },
      { name: 'Mombasa', lat: -4.0435, lon: 39.6682, county: 'Mombasa' },
      { name: 'Kisumu', lat: -0.1022, lon: 34.7617, county: 'Kisumu' },
      { name: 'Nakuru', lat: -0.3031, lon: 36.0800, county: 'Nakuru' },
      { name: 'Eldoret', lat: 0.5143, lon: 35.2698, county: 'Uasin Gishu' },
      { name: 'Meru', lat: 0.0467, lon: 37.6556, county: 'Meru' },
      { name: 'Kitale', lat: 1.0157, lon: 35.0062, county: 'Trans Nzoia' },
      { name: 'Garissa', lat: -0.4536, lon: 39.6401, county: 'Garissa' },
    ];
  }

  /**
   * Get current weather for a location
   */
  async getCurrentWeather(latitude, longitude, county = null) {
    try {
      const cacheKey = `weather:current:${latitude}:${longitude}`;
      const cached = await redisClient.get(cacheKey);
      
      if (cached) {
        return JSON.parse(cached);
      }

      // Try to get data from Kenya Meteorological Department first
      let weatherData = await this.getKMDWeather(latitude, longitude, county);
      
      // Fallback to OpenWeatherMap if KMD fails
      if (!weatherData) {
        weatherData = await this.getOpenWeatherMapData(latitude, longitude);
      }

      if (weatherData) {
        // Cache for 30 minutes
        await redisClient.setex(cacheKey, 1800, JSON.stringify(weatherData));
      }

      return weatherData;

    } catch (error) {
      logger.error('Error getting current weather:', error);
      throw new Error('Failed to fetch weather data');
    }
  }

  /**
   * Get weather forecast for a location
   */
  async getWeatherForecast(latitude, longitude, days = 7) {
    try {
      const cacheKey = `weather:forecast:${latitude}:${longitude}:${days}`;
      const cached = await redisClient.get(cacheKey);
      
      if (cached) {
        return JSON.parse(cached);
      }

      const response = await axios.get(`${this.weatherApiUrl}/forecast`, {
        params: {
          lat: latitude,
          lon: longitude,
          appid: this.weatherApiKey,
          units: 'metric',
          cnt: days * 8, // 8 forecasts per day (3-hour intervals)
        },
      });

      const forecastData = this.processForecastData(response.data);
      
      // Cache for 2 hours
      await redisClient.setex(cacheKey, 7200, JSON.stringify(forecastData));
      
      return forecastData;

    } catch (error) {
      logger.error('Error getting weather forecast:', error);
      throw new Error('Failed to fetch weather forecast');
    }
  }

  /**
   * Get climate data from Kenya Meteorological Department
   */
  async getKMDWeather(latitude, longitude, county) {
    try {
      // Find nearest weather station
      const nearestStation = this.findNearestWeatherStation(latitude, longitude);
      
      // In a real implementation, you would call the KMD API
      // For now, we'll simulate the response
      const response = await axios.get(`${this.kmdApiUrl}/current`, {
        params: {
          station: nearestStation.name,
          county: county || nearestStation.county,
        },
        timeout: 5000,
      });

      return this.processKMDData(response.data);

    } catch (error) {
      logger.warn('KMD API unavailable, falling back to OpenWeatherMap:', error.message);
      return null;
    }
  }

  /**
   * Get weather data from OpenWeatherMap
   */
  async getOpenWeatherMapData(latitude, longitude) {
    try {
      const response = await axios.get(`${this.weatherApiUrl}/weather`, {
        params: {
          lat: latitude,
          lon: longitude,
          appid: this.weatherApiKey,
          units: 'metric',
        },
      });

      return this.processOpenWeatherMapData(response.data);

    } catch (error) {
      logger.error('Error getting OpenWeatherMap data:', error);
      throw error;
    }
  }

  /**
   * Get agricultural alerts and advisories
   */
  async getAgriculturalAlerts(latitude, longitude, cropTypes = []) {
    try {
      const cacheKey = `alerts:${latitude}:${longitude}:${cropTypes.join(',')}`;
      const cached = await redisClient.get(cacheKey);
      
      if (cached) {
        return JSON.parse(cached);
      }

      const currentWeather = await this.getCurrentWeather(latitude, longitude);
      const forecast = await this.getWeatherForecast(latitude, longitude, 14);
      
      const alerts = this.generateAgriculturalAlerts(currentWeather, forecast, cropTypes);
      
      // Cache for 6 hours
      await redisClient.setex(cacheKey, 21600, JSON.stringify(alerts));
      
      return alerts;

    } catch (error) {
      logger.error('Error generating agricultural alerts:', error);
      throw new Error('Failed to generate agricultural alerts');
    }
  }

  /**
   * Get seasonal climate outlook
   */
  async getSeasonalOutlook(latitude, longitude, season) {
    try {
      const cacheKey = `seasonal:${latitude}:${longitude}:${season}`;
      const cached = await redisClient.get(cacheKey);
      
      if (cached) {
        return JSON.parse(cached);
      }

      // Get historical climate data and seasonal predictions
      const historicalData = await this.getHistoricalClimateData(latitude, longitude);
      const seasonalForecast = await this.getSeasonalForecast(latitude, longitude, season);
      
      const outlook = this.generateSeasonalOutlook(historicalData, seasonalForecast, season);
      
      // Cache for 24 hours
      await redisClient.setex(cacheKey, 86400, JSON.stringify(outlook));
      
      return outlook;

    } catch (error) {
      logger.error('Error getting seasonal outlook:', error);
      throw new Error('Failed to get seasonal outlook');
    }
  }

  /**
   * Calculate crop water requirements
   */
  async calculateCropWaterRequirements(latitude, longitude, cropType, plantingDate, growthStage) {
    try {
      const weather = await this.getCurrentWeather(latitude, longitude);
      const forecast = await this.getWeatherForecast(latitude, longitude, 14);
      
      const waterRequirements = this.calculateETc(weather, forecast, cropType, growthStage);
      const irrigationSchedule = this.generateIrrigationSchedule(waterRequirements, forecast);
      
      return {
        dailyWaterRequirement: waterRequirements.daily,
        weeklyWaterRequirement: waterRequirements.weekly,
        irrigationSchedule,
        recommendations: this.generateWaterManagementRecommendations(waterRequirements, weather),
      };

    } catch (error) {
      logger.error('Error calculating crop water requirements:', error);
      throw new Error('Failed to calculate water requirements');
    }
  }

  /**
   * Get pest and disease risk assessment
   */
  async getPestDiseaseRisk(latitude, longitude, cropTypes) {
    try {
      const weather = await this.getCurrentWeather(latitude, longitude);
      const forecast = await this.getWeatherForecast(latitude, longitude, 7);
      
      const riskAssessment = this.assessPestDiseaseRisk(weather, forecast, cropTypes);
      
      return {
        overallRisk: riskAssessment.overall,
        specificRisks: riskAssessment.specific,
        preventiveMeasures: riskAssessment.preventive,
        monitoringRecommendations: riskAssessment.monitoring,
      };

    } catch (error) {
      logger.error('Error assessing pest and disease risk:', error);
      throw new Error('Failed to assess pest and disease risk');
    }
  }

  /**
   * Find nearest weather station
   */
  findNearestWeatherStation(latitude, longitude) {
    let nearestStation = this.kenyaWeatherStations[0];
    let minDistance = calculateDistance(latitude, longitude, nearestStation.lat, nearestStation.lon);

    for (const station of this.kenyaWeatherStations) {
      const distance = calculateDistance(latitude, longitude, station.lat, station.lon);
      if (distance < minDistance) {
        minDistance = distance;
        nearestStation = station;
      }
    }

    return { ...nearestStation, distance: minDistance };
  }

  /**
   * Process KMD weather data
   */
  processKMDData(data) {
    return {
      source: 'KMD',
      temperature: {
        current: data.temperature,
        min: data.min_temperature,
        max: data.max_temperature,
        feelsLike: data.feels_like,
      },
      humidity: data.humidity,
      pressure: data.pressure,
      windSpeed: data.wind_speed,
      windDirection: data.wind_direction,
      rainfall: data.rainfall,
      visibility: data.visibility,
      uvIndex: data.uv_index,
      description: data.weather_description,
      timestamp: moment().toISOString(),
    };
  }

  /**
   * Process OpenWeatherMap data
   */
  processOpenWeatherMapData(data) {
    return {
      source: 'OpenWeatherMap',
      temperature: {
        current: data.main.temp,
        min: data.main.temp_min,
        max: data.main.temp_max,
        feelsLike: data.main.feels_like,
      },
      humidity: data.main.humidity,
      pressure: data.main.pressure,
      windSpeed: data.wind?.speed || 0,
      windDirection: data.wind?.deg || 0,
      rainfall: data.rain?.['1h'] || 0,
      visibility: data.visibility / 1000, // Convert to km
      uvIndex: null, // Not available in current weather
      description: data.weather[0].description,
      timestamp: moment().toISOString(),
    };
  }

  /**
   * Process forecast data
   */
  processForecastData(data) {
    const dailyForecasts = [];
    const forecasts = data.list;

    // Group forecasts by day
    const groupedByDay = {};
    forecasts.forEach(forecast => {
      const date = moment.unix(forecast.dt).format('YYYY-MM-DD');
      if (!groupedByDay[date]) {
        groupedByDay[date] = [];
      }
      groupedByDay[date].push(forecast);
    });

    // Process each day
    Object.keys(groupedByDay).forEach(date => {
      const dayForecasts = groupedByDay[date];
      const dailyForecast = this.aggregateDailyForecast(dayForecasts);
      dailyForecasts.push({
        date,
        ...dailyForecast,
      });
    });

    return {
      location: data.city.name,
      forecasts: dailyForecasts,
      timestamp: moment().toISOString(),
    };
  }

  /**
   * Aggregate hourly forecasts into daily forecast
   */
  aggregateDailyForecast(hourlyForecasts) {
    const temps = hourlyForecasts.map(f => f.main.temp);
    const rainfall = hourlyForecasts.reduce((sum, f) => sum + (f.rain?.['3h'] || 0), 0);
    const humidity = hourlyForecasts.reduce((sum, f) => sum + f.main.humidity, 0) / hourlyForecasts.length;
    const windSpeed = hourlyForecasts.reduce((sum, f) => sum + f.wind.speed, 0) / hourlyForecasts.length;

    return {
      temperature: {
        min: Math.min(...temps),
        max: Math.max(...temps),
        avg: temps.reduce((sum, temp) => sum + temp, 0) / temps.length,
      },
      rainfall,
      humidity: Math.round(humidity),
      windSpeed: Math.round(windSpeed * 10) / 10,
      description: hourlyForecasts[Math.floor(hourlyForecasts.length / 2)].weather[0].description,
    };
  }

  /**
   * Generate agricultural alerts based on weather conditions
   */
  generateAgriculturalAlerts(currentWeather, forecast, cropTypes) {
    const alerts = [];

    // Temperature alerts
    if (currentWeather.temperature.current > 35) {
      alerts.push({
        type: 'heat_stress',
        severity: 'high',
        title: 'Heat Stress Warning',
        message: 'High temperatures may cause heat stress in crops and livestock. Ensure adequate water supply and shade.',
        recommendations: [
          'Increase watering frequency',
          'Provide shade for livestock',
          'Harvest early morning or late evening',
        ],
      });
    }

    // Rainfall alerts
    const upcomingRain = forecast.forecasts.slice(0, 3).reduce((sum, day) => sum + day.rainfall, 0);
    if (upcomingRain > 50) {
      alerts.push({
        type: 'heavy_rainfall',
        severity: 'medium',
        title: 'Heavy Rainfall Expected',
        message: `Heavy rainfall (${upcomingRain.toFixed(1)}mm) expected in the next 3 days.`,
        recommendations: [
          'Ensure proper drainage in fields',
          'Protect stored crops from moisture',
          'Delay spraying activities',
        ],
      });
    }

    // Drought alerts
    const recentRain = forecast.forecasts.slice(0, 7).reduce((sum, day) => sum + day.rainfall, 0);
    if (recentRain < 5 && currentWeather.humidity < 40) {
      alerts.push({
        type: 'drought_risk',
        severity: 'high',
        title: 'Drought Risk',
        message: 'Low rainfall and humidity indicate drought conditions.',
        recommendations: [
          'Implement water conservation measures',
          'Consider drought-resistant crop varieties',
          'Monitor soil moisture levels',
        ],
      });
    }

    return alerts;
  }

  /**
   * Generate seasonal outlook
   */
  generateSeasonalOutlook(historicalData, seasonalForecast, season) {
    // This would involve complex climate modeling
    // For now, return a simplified outlook
    return {
      season,
      outlook: {
        rainfall: {
          probability: 'above_normal',
          confidence: 70,
          expected_amount: '400-600mm',
        },
        temperature: {
          probability: 'normal',
          confidence: 65,
          expected_range: '18-28°C',
        },
      },
      recommendations: [
        'Plant drought-resistant varieties as backup',
        'Prepare for potential flooding in low-lying areas',
        'Stock up on farm inputs early in the season',
      ],
      lastUpdated: moment().toISOString(),
    };
  }

  /**
   * Calculate crop evapotranspiration (ETc)
   */
  calculateETc(weather, forecast, cropType, growthStage) {
    // Simplified ETc calculation using Penman-Monteith method
    const cropCoefficients = {
      maize: { initial: 0.3, development: 0.7, mid: 1.2, late: 0.6 },
      beans: { initial: 0.4, development: 0.7, mid: 1.15, late: 0.8 },
      tomatoes: { initial: 0.6, development: 0.8, mid: 1.15, late: 0.8 },
      // Add more crops as needed
    };

    const kc = cropCoefficients[cropType]?.[growthStage] || 1.0;
    const et0 = this.calculateReferenceET(weather);
    
    return {
      daily: et0 * kc,
      weekly: et0 * kc * 7,
      monthly: et0 * kc * 30,
    };
  }

  /**
   * Calculate reference evapotranspiration (ET0)
   */
  calculateReferenceET(weather) {
    // Simplified Penman-Monteith calculation
    const temp = weather.temperature.current;
    const humidity = weather.humidity;
    const windSpeed = weather.windSpeed;
    
    // This is a simplified calculation - in production, use the full Penman-Monteith equation
    const et0 = 0.0023 * (temp + 17.8) * Math.sqrt(Math.abs(temp - humidity)) * (windSpeed + 1);
    
    return Math.max(0, et0);
  }

  /**
   * Generate irrigation schedule
   */
  generateIrrigationSchedule(waterRequirements, forecast) {
    const schedule = [];
    
    forecast.forecasts.slice(0, 7).forEach((day, index) => {
      const effectiveRainfall = Math.min(day.rainfall, waterRequirements.daily * 0.8);
      const irrigationNeeded = Math.max(0, waterRequirements.daily - effectiveRainfall);
      
      if (irrigationNeeded > 0) {
        schedule.push({
          date: day.date,
          amount: irrigationNeeded,
          timing: day.temperature.max > 30 ? 'early_morning' : 'morning',
          priority: irrigationNeeded > waterRequirements.daily * 0.7 ? 'high' : 'medium',
        });
      }
    });
    
    return schedule;
  }

  /**
   * Generate water management recommendations
   */
  generateWaterManagementRecommendations(waterRequirements, weather) {
    const recommendations = [];
    
    if (weather.temperature.current > 30) {
      recommendations.push('Water early morning or late evening to reduce evaporation');
    }
    
    if (weather.windSpeed > 15) {
      recommendations.push('Use drip irrigation or mulching to reduce wind evaporation');
    }
    
    if (weather.humidity < 50) {
      recommendations.push('Increase irrigation frequency due to low humidity');
    }
    
    return recommendations;
  }

  /**
   * Assess pest and disease risk
   */
  assessPestDiseaseRisk(weather, forecast, cropTypes) {
    const risks = {
      overall: 'medium',
      specific: [],
      preventive: [],
      monitoring: [],
    };

    // High humidity and warm temperatures increase fungal disease risk
    if (weather.humidity > 80 && weather.temperature.current > 20) {
      risks.specific.push({
        type: 'fungal_diseases',
        risk: 'high',
        crops_affected: cropTypes,
        description: 'High humidity and warm temperatures favor fungal diseases',
      });
      risks.preventive.push('Apply preventive fungicides');
      risks.monitoring.push('Check for early signs of leaf spots and blights');
    }

    // Dry conditions may increase pest pressure
    const avgHumidity = forecast.forecasts.slice(0, 5).reduce((sum, day) => sum + day.humidity, 0) / 5;
    if (avgHumidity < 50) {
      risks.specific.push({
        type: 'pest_pressure',
        risk: 'medium',
        crops_affected: cropTypes,
        description: 'Dry conditions may increase pest activity',
      });
      risks.preventive.push('Monitor for increased pest activity');
      risks.monitoring.push('Check for aphids, thrips, and spider mites');
    }

    return risks;
  }
}

module.exports = new ClimateService();

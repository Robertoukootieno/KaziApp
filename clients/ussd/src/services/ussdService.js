const axios = require('axios');
const redisClient = require('../config/redis');
const logger = require('../utils/logger');
const { getMenuText } = require('../utils/localization');

const API_BASE_URL = process.env.API_GATEWAY_URL || 'http://localhost:3000';
const SESSION_TIMEOUT = 300; // 5 minutes

/**
 * Process USSD request and return appropriate response
 */
const processUSSDRequest = async ({ sessionId, serviceCode, phoneNumber, text }) => {
  try {
    // Get or create session
    let session = await getSession(sessionId);
    if (!session) {
      session = await createSession(sessionId, phoneNumber);
    }

    // Parse user input
    const userInput = text.split('*').filter(input => input !== '');
    const currentLevel = userInput.length;
    const lastInput = userInput[userInput.length - 1] || '';

    // Determine user's preferred language (default to Swahili for Kenya)
    const language = await getUserLanguage(phoneNumber) || 'sw';

    // Route to appropriate menu handler
    if (currentLevel === 0) {
      return await showMainMenu(language);
    }

    const mainChoice = userInput[0];
    
    switch (mainChoice) {
      case '1': // Request Veterinarian
        return await handleVetRequest(userInput, phoneNumber, language, session);
      
      case '2': // Check Market Prices
        return await handleMarketPrices(userInput, phoneNumber, language);
      
      case '3': // Weather & Climate Alerts
        return await handleWeatherAlerts(userInput, phoneNumber, language);
      
      case '4': // Farm Management Tips
        return await handleFarmTips(userInput, phoneNumber, language);
      
      case '5': // Account & Profile
        return await handleAccountMenu(userInput, phoneNumber, language);
      
      case '6': // Help & Support
        return await handleHelpMenu(userInput, phoneNumber, language);
      
      case '0': // Language Selection
        return await handleLanguageSelection(userInput, phoneNumber);
      
      default:
        return {
          type: 'CON',
          message: getMenuText('invalid_option', language),
          options: [
            { text: getMenuText('try_again', language) }
          ]
        };
    }
    
  } catch (error) {
    logger.error('Error processing USSD request:', error);
    return {
      type: 'END',
      message: getMenuText('system_error', 'sw')
    };
  }
};

/**
 * Show main menu
 */
const showMainMenu = async (language = 'sw') => {
  return {
    type: 'CON',
    message: getMenuText('welcome', language),
    options: [
      { text: getMenuText('request_vet', language) },
      { text: getMenuText('market_prices', language) },
      { text: getMenuText('weather_alerts', language) },
      { text: getMenuText('farm_tips', language) },
      { text: getMenuText('my_account', language) },
      { text: getMenuText('help_support', language) },
      { text: getMenuText('change_language', language) }
    ]
  };
};

/**
 * Handle veterinarian request
 */
const handleVetRequest = async (userInput, phoneNumber, language, session) => {
  const subLevel = userInput.length - 1;
  
  if (subLevel === 0) {
    // Show animal types
    return {
      type: 'CON',
      message: getMenuText('select_animal_type', language),
      options: [
        { text: getMenuText('cattle', language) },
        { text: getMenuText('goats', language) },
        { text: getMenuText('sheep', language) },
        { text: getMenuText('chickens', language) },
        { text: getMenuText('other_animals', language) }
      ]
    };
  }
  
  if (subLevel === 1) {
    const animalType = getAnimalType(userInput[1]);
    session.animalType = animalType;
    await updateSession(session.sessionId, session);
    
    // Show problem types
    return {
      type: 'CON',
      message: getMenuText('describe_problem', language),
      options: [
        { text: getMenuText('sick_animal', language) },
        { text: getMenuText('breeding_help', language) },
        { text: getMenuText('vaccination', language) },
        { text: getMenuText('general_checkup', language) },
        { text: getMenuText('emergency', language) }
      ]
    };
  }
  
  if (subLevel === 2) {
    const problemType = getProblemType(userInput[2]);
    session.problemType = problemType;
    
    // Request location
    return {
      type: 'CON',
      message: getMenuText('enter_location', language),
      options: []
    };
  }
  
  if (subLevel === 3) {
    const location = userInput[3];
    
    try {
      // Submit vet request to API
      const vetRequest = await submitVetRequest({
        phoneNumber,
        animalType: session.animalType,
        problemType: session.problemType,
        location,
        language
      });
      
      if (vetRequest.success) {
        return {
          type: 'END',
          message: getMenuText('vet_request_success', language)
            .replace('{requestId}', vetRequest.requestId)
            .replace('{estimatedTime}', vetRequest.estimatedTime)
        };
      } else {
        return {
          type: 'END',
          message: getMenuText('vet_request_failed', language)
        };
      }
      
    } catch (error) {
      logger.error('Error submitting vet request:', error);
      return {
        type: 'END',
        message: getMenuText('system_error', language)
      };
    }
  }
};

/**
 * Handle market prices inquiry
 */
const handleMarketPrices = async (userInput, phoneNumber, language) => {
  const subLevel = userInput.length - 1;
  
  if (subLevel === 0) {
    return {
      type: 'CON',
      message: getMenuText('select_product_category', language),
      options: [
        { text: getMenuText('crops', language) },
        { text: getMenuText('livestock', language) },
        { text: getMenuText('dairy_products', language) },
        { text: getMenuText('farm_inputs', language) }
      ]
    };
  }
  
  if (subLevel === 1) {
    const category = userInput[1];
    
    try {
      const prices = await fetchMarketPrices(category, phoneNumber);
      
      return {
        type: 'END',
        message: formatPricesMessage(prices, language)
      };
      
    } catch (error) {
      logger.error('Error fetching market prices:', error);
      return {
        type: 'END',
        message: getMenuText('prices_unavailable', language)
      };
    }
  }
};

/**
 * Submit veterinarian request to API
 */
const submitVetRequest = async (requestData) => {
  try {
    const response = await axios.post(`${API_BASE_URL}/api/vet-requests`, {
      ...requestData,
      source: 'ussd'
    });
    
    return response.data;
  } catch (error) {
    logger.error('Error submitting vet request to API:', error);
    throw error;
  }
};

/**
 * Fetch market prices from API
 */
const fetchMarketPrices = async (category, phoneNumber) => {
  try {
    const response = await axios.get(`${API_BASE_URL}/api/market-prices`, {
      params: { category, phoneNumber }
    });
    
    return response.data;
  } catch (error) {
    logger.error('Error fetching market prices from API:', error);
    throw error;
  }
};

/**
 * Session management functions
 */
const getSession = async (sessionId) => {
  try {
    const sessionData = await redisClient.get(`ussd_session:${sessionId}`);
    return sessionData ? JSON.parse(sessionData) : null;
  } catch (error) {
    logger.error('Error getting session:', error);
    return null;
  }
};

const createSession = async (sessionId, phoneNumber) => {
  const session = {
    sessionId,
    phoneNumber,
    createdAt: new Date().toISOString(),
    data: {}
  };
  
  await redisClient.setex(`ussd_session:${sessionId}`, SESSION_TIMEOUT, JSON.stringify(session));
  return session;
};

const updateSession = async (sessionId, sessionData) => {
  await redisClient.setex(`ussd_session:${sessionId}`, SESSION_TIMEOUT, JSON.stringify(sessionData));
};

const cleanupSession = async (sessionId) => {
  await redisClient.del(`ussd_session:${sessionId}`);
};

/**
 * Get user's preferred language
 */
const getUserLanguage = async (phoneNumber) => {
  try {
    const response = await axios.get(`${API_BASE_URL}/api/users/language`, {
      params: { phoneNumber }
    });
    return response.data.language;
  } catch (error) {
    return 'sw'; // Default to Swahili
  }
};

/**
 * Helper functions
 */
const getAnimalType = (choice) => {
  const types = ['cattle', 'goats', 'sheep', 'chickens', 'other'];
  return types[parseInt(choice) - 1] || 'other';
};

const getProblemType = (choice) => {
  const types = ['sick', 'breeding', 'vaccination', 'checkup', 'emergency'];
  return types[parseInt(choice) - 1] || 'general';
};

const formatPricesMessage = (prices, language) => {
  if (!prices || prices.length === 0) {
    return getMenuText('no_prices_available', language);
  }
  
  let message = getMenuText('current_prices', language) + '\n\n';
  
  prices.forEach(price => {
    message += `${price.product}: KSh ${price.price}/${price.unit}\n`;
  });
  
  message += `\n${getMenuText('prices_updated', language)}: ${prices[0].lastUpdated}`;
  
  return message;
};

module.exports = {
  processUSSDRequest,
  cleanupSession,
};

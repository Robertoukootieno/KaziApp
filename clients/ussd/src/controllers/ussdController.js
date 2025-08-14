const ussdService = require('../services/ussdService');
const logger = require('../utils/logger');
const { validateUSSDInput } = require('../utils/validation');

/**
 * Handle USSD requests from Africa's Talking or similar providers
 */
const handleUSSD = async (req, res) => {
  try {
    const { sessionId, serviceCode, phoneNumber, text } = req.body;
    
    // Validate input
    const validation = validateUSSDInput(req.body);
    if (!validation.isValid) {
      logger.error('Invalid USSD input:', validation.errors);
      return res.status(400).json({ error: 'Invalid input', details: validation.errors });
    }

    logger.info(`USSD request from ${phoneNumber}: ${text}`);

    // Process USSD request
    const response = await ussdService.processUSSDRequest({
      sessionId,
      serviceCode,
      phoneNumber,
      text: text || '',
    });

    // Format response for Africa's Talking
    const formattedResponse = formatUSSDResponse(response);
    
    logger.info(`USSD response to ${phoneNumber}:`, formattedResponse);
    
    res.set('Content-Type', 'text/plain');
    res.send(formattedResponse);
    
  } catch (error) {
    logger.error('Error handling USSD request:', error);
    res.set('Content-Type', 'text/plain');
    res.send('END Samahani, kuna tatizo. Jaribu tena baadaye.\n(Sorry, there is a problem. Please try again later.)');
  }
};

/**
 * Handle USSD callback for session completion
 */
const handleCallback = async (req, res) => {
  try {
    const { sessionId, phoneNumber, status } = req.body;
    
    logger.info(`USSD session ${sessionId} completed for ${phoneNumber} with status: ${status}`);
    
    // Clean up session data
    await ussdService.cleanupSession(sessionId);
    
    res.status(200).json({ status: 'received' });
    
  } catch (error) {
    logger.error('Error handling USSD callback:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

/**
 * Format USSD response according to Africa's Talking format
 */
const formatUSSDResponse = (response) => {
  const { type, message, options } = response;
  
  if (type === 'END') {
    return `END ${message}`;
  }
  
  if (type === 'CON') {
    let formattedMessage = `CON ${message}`;
    
    if (options && options.length > 0) {
      formattedMessage += '\n';
      options.forEach((option, index) => {
        formattedMessage += `\n${index + 1}. ${option.text}`;
      });
    }
    
    return formattedMessage;
  }
  
  return `END ${message}`;
};

module.exports = {
  handleUSSD,
  handleCallback,
};

const axios = require('axios');
const crypto = require('crypto');
const moment = require('moment');
const logger = require('../utils/logger');
const redisClient = require('../config/redis');

class MPesaService {
  constructor() {
    this.consumerKey = process.env.MPESA_CONSUMER_KEY;
    this.consumerSecret = process.env.MPESA_CONSUMER_SECRET;
    this.shortcode = process.env.MPESA_SHORTCODE;
    this.passkey = process.env.MPESA_PASSKEY;
    this.environment = process.env.MPESA_ENVIRONMENT || 'sandbox';
    
    // API URLs
    this.baseURL = this.environment === 'production' 
      ? 'https://api.safaricom.co.ke' 
      : 'https://sandbox.safaricom.co.ke';
    
    this.callbackURL = process.env.MPESA_CALLBACK_URL || 'https://api.kaziapp.com/api/payments/mpesa/callback';
    this.timeoutURL = process.env.MPESA_TIMEOUT_URL || 'https://api.kaziapp.com/api/payments/mpesa/timeout';
  }

  /**
   * Get OAuth access token
   */
  async getAccessToken() {
    try {
      // Check if token exists in cache
      const cachedToken = await redisClient.get('mpesa_access_token');
      if (cachedToken) {
        return cachedToken;
      }

      const auth = Buffer.from(`${this.consumerKey}:${this.consumerSecret}`).toString('base64');
      
      const response = await axios.get(`${this.baseURL}/oauth/v1/generate?grant_type=client_credentials`, {
        headers: {
          'Authorization': `Basic ${auth}`,
          'Content-Type': 'application/json',
        },
      });

      const { access_token, expires_in } = response.data;
      
      // Cache token with expiry (subtract 60 seconds for safety)
      await redisClient.setex('mpesa_access_token', expires_in - 60, access_token);
      
      return access_token;
    } catch (error) {
      logger.error('Error getting M-Pesa access token:', error.response?.data || error.message);
      throw new Error('Failed to get M-Pesa access token');
    }
  }

  /**
   * Generate password for STK Push
   */
  generatePassword() {
    const timestamp = moment().format('YYYYMMDDHHmmss');
    const password = Buffer.from(`${this.shortcode}${this.passkey}${timestamp}`).toString('base64');
    return { password, timestamp };
  }

  /**
   * Initiate STK Push (Lipa na M-Pesa Online)
   */
  async stkPush(phoneNumber, amount, accountReference, transactionDesc) {
    try {
      const accessToken = await this.getAccessToken();
      const { password, timestamp } = this.generatePassword();
      
      // Format phone number (ensure it starts with 254)
      const formattedPhone = this.formatPhoneNumber(phoneNumber);
      
      const requestBody = {
        BusinessShortCode: this.shortcode,
        Password: password,
        Timestamp: timestamp,
        TransactionType: 'CustomerPayBillOnline',
        Amount: Math.round(amount), // M-Pesa requires integer amounts
        PartyA: formattedPhone,
        PartyB: this.shortcode,
        PhoneNumber: formattedPhone,
        CallBackURL: this.callbackURL,
        AccountReference: accountReference,
        TransactionDesc: transactionDesc,
      };

      const response = await axios.post(
        `${this.baseURL}/mpesa/stkpush/v1/processrequest`,
        requestBody,
        {
          headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json',
          },
        }
      );

      logger.info('STK Push initiated:', {
        phoneNumber: formattedPhone,
        amount,
        checkoutRequestID: response.data.CheckoutRequestID,
      });

      return {
        success: true,
        checkoutRequestID: response.data.CheckoutRequestID,
        merchantRequestID: response.data.MerchantRequestID,
        responseCode: response.data.ResponseCode,
        responseDescription: response.data.ResponseDescription,
        customerMessage: response.data.CustomerMessage,
      };

    } catch (error) {
      logger.error('STK Push error:', error.response?.data || error.message);
      
      return {
        success: false,
        error: error.response?.data?.errorMessage || 'Failed to initiate payment',
        errorCode: error.response?.data?.errorCode,
      };
    }
  }

  /**
   * Query STK Push status
   */
  async stkPushQuery(checkoutRequestID) {
    try {
      const accessToken = await this.getAccessToken();
      const { password, timestamp } = this.generatePassword();

      const requestBody = {
        BusinessShortCode: this.shortcode,
        Password: password,
        Timestamp: timestamp,
        CheckoutRequestID: checkoutRequestID,
      };

      const response = await axios.post(
        `${this.baseURL}/mpesa/stkpushquery/v1/query`,
        requestBody,
        {
          headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json',
          },
        }
      );

      return {
        success: true,
        resultCode: response.data.ResultCode,
        resultDesc: response.data.ResultDesc,
        merchantRequestID: response.data.MerchantRequestID,
        checkoutRequestID: response.data.CheckoutRequestID,
      };

    } catch (error) {
      logger.error('STK Push query error:', error.response?.data || error.message);
      
      return {
        success: false,
        error: error.response?.data?.errorMessage || 'Failed to query payment status',
      };
    }
  }

  /**
   * B2C Payment (Business to Customer)
   */
  async b2cPayment(phoneNumber, amount, remarks, occasion) {
    try {
      const accessToken = await this.getAccessToken();
      const formattedPhone = this.formatPhoneNumber(phoneNumber);
      
      const requestBody = {
        InitiatorName: process.env.MPESA_INITIATOR_NAME,
        SecurityCredential: process.env.MPESA_SECURITY_CREDENTIAL,
        CommandID: 'BusinessPayment',
        Amount: Math.round(amount),
        PartyA: this.shortcode,
        PartyB: formattedPhone,
        Remarks: remarks,
        QueueTimeOutURL: this.timeoutURL,
        ResultURL: this.callbackURL,
        Occasion: occasion,
      };

      const response = await axios.post(
        `${this.baseURL}/mpesa/b2c/v1/paymentrequest`,
        requestBody,
        {
          headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json',
          },
        }
      );

      logger.info('B2C Payment initiated:', {
        phoneNumber: formattedPhone,
        amount,
        conversationID: response.data.ConversationID,
      });

      return {
        success: true,
        conversationID: response.data.ConversationID,
        originatorConversationID: response.data.OriginatorConversationID,
        responseCode: response.data.ResponseCode,
        responseDescription: response.data.ResponseDescription,
      };

    } catch (error) {
      logger.error('B2C Payment error:', error.response?.data || error.message);
      
      return {
        success: false,
        error: error.response?.data?.errorMessage || 'Failed to initiate B2C payment',
      };
    }
  }

  /**
   * Account Balance Query
   */
  async accountBalance() {
    try {
      const accessToken = await this.getAccessToken();
      
      const requestBody = {
        Initiator: process.env.MPESA_INITIATOR_NAME,
        SecurityCredential: process.env.MPESA_SECURITY_CREDENTIAL,
        CommandID: 'AccountBalance',
        PartyA: this.shortcode,
        IdentifierType: '4',
        Remarks: 'Account balance query',
        QueueTimeOutURL: this.timeoutURL,
        ResultURL: this.callbackURL,
      };

      const response = await axios.post(
        `${this.baseURL}/mpesa/accountbalance/v1/query`,
        requestBody,
        {
          headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json',
          },
        }
      );

      return {
        success: true,
        conversationID: response.data.ConversationID,
        originatorConversationID: response.data.OriginatorConversationID,
        responseCode: response.data.ResponseCode,
        responseDescription: response.data.ResponseDescription,
      };

    } catch (error) {
      logger.error('Account balance query error:', error.response?.data || error.message);
      
      return {
        success: false,
        error: error.response?.data?.errorMessage || 'Failed to query account balance',
      };
    }
  }

  /**
   * Transaction Status Query
   */
  async transactionStatus(transactionID) {
    try {
      const accessToken = await this.getAccessToken();
      
      const requestBody = {
        Initiator: process.env.MPESA_INITIATOR_NAME,
        SecurityCredential: process.env.MPESA_SECURITY_CREDENTIAL,
        CommandID: 'TransactionStatusQuery',
        TransactionID: transactionID,
        PartyA: this.shortcode,
        IdentifierType: '4',
        ResultURL: this.callbackURL,
        QueueTimeOutURL: this.timeoutURL,
        Remarks: 'Transaction status query',
        Occasion: 'Transaction status check',
      };

      const response = await axios.post(
        `${this.baseURL}/mpesa/transactionstatus/v1/query`,
        requestBody,
        {
          headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json',
          },
        }
      );

      return {
        success: true,
        conversationID: response.data.ConversationID,
        originatorConversationID: response.data.OriginatorConversationID,
        responseCode: response.data.ResponseCode,
        responseDescription: response.data.ResponseDescription,
      };

    } catch (error) {
      logger.error('Transaction status query error:', error.response?.data || error.message);
      
      return {
        success: false,
        error: error.response?.data?.errorMessage || 'Failed to query transaction status',
      };
    }
  }

  /**
   * Format phone number to M-Pesa format (254XXXXXXXXX)
   */
  formatPhoneNumber(phoneNumber) {
    // Remove any non-digit characters
    let cleaned = phoneNumber.replace(/\D/g, '');
    
    // Handle different formats
    if (cleaned.startsWith('254')) {
      return cleaned;
    } else if (cleaned.startsWith('0')) {
      return '254' + cleaned.substring(1);
    } else if (cleaned.length === 9) {
      return '254' + cleaned;
    }
    
    throw new Error('Invalid phone number format');
  }

  /**
   * Validate M-Pesa callback
   */
  validateCallback(callbackData) {
    // Basic validation - in production, you might want to add signature verification
    return callbackData && 
           callbackData.Body && 
           (callbackData.Body.stkCallback || callbackData.Body.CallbackMetadata);
  }

  /**
   * Process STK Push callback
   */
  processStkCallback(callbackData) {
    const stkCallback = callbackData.Body.stkCallback;
    
    if (stkCallback.ResultCode === 0) {
      // Payment successful
      const callbackMetadata = stkCallback.CallbackMetadata.Item;
      const paymentData = {};
      
      callbackMetadata.forEach(item => {
        switch (item.Name) {
          case 'Amount':
            paymentData.amount = item.Value;
            break;
          case 'MpesaReceiptNumber':
            paymentData.mpesaReceiptNumber = item.Value;
            break;
          case 'TransactionDate':
            paymentData.transactionDate = item.Value;
            break;
          case 'PhoneNumber':
            paymentData.phoneNumber = item.Value;
            break;
        }
      });
      
      return {
        success: true,
        merchantRequestID: stkCallback.MerchantRequestID,
        checkoutRequestID: stkCallback.CheckoutRequestID,
        resultCode: stkCallback.ResultCode,
        resultDesc: stkCallback.ResultDesc,
        paymentData,
      };
    } else {
      // Payment failed or cancelled
      return {
        success: false,
        merchantRequestID: stkCallback.MerchantRequestID,
        checkoutRequestID: stkCallback.CheckoutRequestID,
        resultCode: stkCallback.ResultCode,
        resultDesc: stkCallback.ResultDesc,
      };
    }
  }
}

module.exports = new MPesaService();

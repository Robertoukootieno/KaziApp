const axios = require('axios');
const logger = require('../utils/logger');

/**
 * Service client for communicating with backend microservices
 */
class ServiceClient {
  constructor() {
    this.baseURL = process.env.API_GATEWAY_URL || 'http://localhost:3000';
    this.timeout = 30000; // 30 seconds
    this.retryAttempts = 3;
    this.retryDelay = 1000; // 1 second
    
    this.client = axios.create({
      baseURL: this.baseURL,
      timeout: this.timeout,
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'KaziApp-Farmer-BFF/1.0.0',
        'X-Service': 'bff-farmer',
      },
    });

    this.setupInterceptors();
  }

  /**
   * Setup request and response interceptors
   */
  setupInterceptors() {
    // Request interceptor
    this.client.interceptors.request.use(
      (config) => {
        // Add correlation ID for tracing
        config.headers['X-Correlation-ID'] = require('uuid').v4();
        config.headers['X-Request-Timestamp'] = new Date().toISOString();
        
        logger.debug(`Making request to ${config.method?.toUpperCase()} ${config.url}`, {
          correlationId: config.headers['X-Correlation-ID'],
        });
        
        return config;
      },
      (error) => {
        logger.error('Request interceptor error:', error);
        return Promise.reject(error);
      }
    );

    // Response interceptor
    this.client.interceptors.response.use(
      (response) => {
        logger.debug(`Response received from ${response.config.url}`, {
          status: response.status,
          correlationId: response.config.headers['X-Correlation-ID'],
        });
        
        return response;
      },
      async (error) => {
        const originalRequest = error.config;
        
        // Log error details
        logger.error('Service request failed:', {
          url: originalRequest?.url,
          method: originalRequest?.method,
          status: error.response?.status,
          message: error.message,
          correlationId: originalRequest?.headers['X-Correlation-ID'],
        });

        // Retry logic for specific errors
        if (this.shouldRetry(error) && !originalRequest._retry) {
          originalRequest._retry = true;
          originalRequest._retryCount = (originalRequest._retryCount || 0) + 1;
          
          if (originalRequest._retryCount <= this.retryAttempts) {
            logger.info(`Retrying request (${originalRequest._retryCount}/${this.retryAttempts}):`, {
              url: originalRequest.url,
              correlationId: originalRequest.headers['X-Correlation-ID'],
            });
            
            // Wait before retrying
            await this.delay(this.retryDelay * originalRequest._retryCount);
            
            return this.client(originalRequest);
          }
        }

        return Promise.reject(error);
      }
    );
  }

  /**
   * Check if request should be retried
   */
  shouldRetry(error) {
    // Retry on network errors or 5xx server errors
    return !error.response || 
           error.code === 'ECONNRESET' ||
           error.code === 'ETIMEDOUT' ||
           (error.response.status >= 500 && error.response.status < 600);
  }

  /**
   * Delay utility for retries
   */
  delay(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  /**
   * GET request with authentication
   */
  async get(endpoint, params = {}, userContext = null) {
    try {
      const config = {
        params,
      };

      if (userContext) {
        config.headers = this.buildAuthHeaders(userContext);
      }

      const response = await this.client.get(`/api${endpoint}`, config);
      return response.data;
    } catch (error) {
      throw this.handleError(error, 'GET', endpoint);
    }
  }

  /**
   * POST request with authentication
   */
  async post(endpoint, data = {}, userContext = null) {
    try {
      const config = {};

      if (userContext) {
        config.headers = this.buildAuthHeaders(userContext);
      }

      const response = await this.client.post(`/api${endpoint}`, data, config);
      return response.data;
    } catch (error) {
      throw this.handleError(error, 'POST', endpoint);
    }
  }

  /**
   * PUT request with authentication
   */
  async put(endpoint, data = {}, userContext = null) {
    try {
      const config = {};

      if (userContext) {
        config.headers = this.buildAuthHeaders(userContext);
      }

      const response = await this.client.put(`/api${endpoint}`, data, config);
      return response.data;
    } catch (error) {
      throw this.handleError(error, 'PUT', endpoint);
    }
  }

  /**
   * DELETE request with authentication
   */
  async delete(endpoint, userContext = null) {
    try {
      const config = {};

      if (userContext) {
        config.headers = this.buildAuthHeaders(userContext);
      }

      const response = await this.client.delete(`/api${endpoint}`, config);
      return response.data;
    } catch (error) {
      throw this.handleError(error, 'DELETE', endpoint);
    }
  }

  /**
   * Build authentication headers from user context
   */
  buildAuthHeaders(userContext) {
    const headers = {};

    if (userContext.token) {
      headers['Authorization'] = `Bearer ${userContext.token}`;
    }

    if (userContext.userId) {
      headers['X-User-ID'] = userContext.userId;
    }

    if (userContext.userType) {
      headers['X-User-Type'] = userContext.userType;
    }

    if (userContext.phoneNumber) {
      headers['X-User-Phone'] = userContext.phoneNumber;
    }

    if (userContext.county) {
      headers['X-User-County'] = userContext.county;
    }

    return headers;
  }

  /**
   * Handle and transform errors
   */
  handleError(error, method, endpoint) {
    const errorInfo = {
      method,
      endpoint,
      timestamp: new Date().toISOString(),
    };

    if (error.response) {
      // Server responded with error status
      errorInfo.status = error.response.status;
      errorInfo.statusText = error.response.statusText;
      errorInfo.data = error.response.data;
      
      return new Error(`Service error: ${error.response.status} ${error.response.statusText}`);
    } else if (error.request) {
      // Request was made but no response received
      errorInfo.message = 'No response from service';
      return new Error('Service unavailable');
    } else {
      // Something else happened
      errorInfo.message = error.message;
      return new Error(`Request failed: ${error.message}`);
    }
  }

  /**
   * Health check for service connectivity
   */
  async healthCheck() {
    try {
      const response = await this.client.get('/health');
      return {
        healthy: response.status === 200,
        data: response.data,
      };
    } catch (error) {
      return {
        healthy: false,
        error: error.message,
      };
    }
  }

  /**
   * Close client connections
   */
  close() {
    // Clean up any persistent connections
    logger.info('Service client connections closed');
  }
}

const serviceClient = new ServiceClient();

module.exports = serviceClient;

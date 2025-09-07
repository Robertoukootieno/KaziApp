const { v4: uuidv4 } = require('uuid');
const crypto = require('crypto');
const logger = require('../utils/logger');

/**
 * Payment Processor - Handles payment processing, escrow, and wallet management
 * Integrates with M-Pesa and other payment providers
 */
class PaymentProcessor {
  constructor(redisClient, eventBus, config) {
    this.redis = redisClient;
    this.eventBus = eventBus;
    this.config = config;
    this.providers = new Map();
    this.escrowAccounts = new Map();
    
    // Initialize payment providers
    this.initializeProviders();
  }

  /**
   * Initialize payment providers
   */
  initializeProviders() {
    // M-Pesa provider
    this.providers.set('mpesa', {
      name: 'M-Pesa',
      type: 'mobile_money',
      currency: 'KES',
      fees: {
        percentage: 0.015, // 1.5%
        minimum: 10, // KES 10
        maximum: 500, // KES 500
      },
      limits: {
        daily: 300000, // KES 300,000
        transaction: 150000, // KES 150,000
      },
      processor: this.processMpesaPayment.bind(this),
    });

    // Bank transfer provider
    this.providers.set('bank_transfer', {
      name: 'Bank Transfer',
      type: 'bank',
      currency: 'KES',
      fees: {
        percentage: 0.01, // 1%
        minimum: 50, // KES 50
        maximum: 1000, // KES 1,000
      },
      limits: {
        daily: 1000000, // KES 1,000,000
        transaction: 500000, // KES 500,000
      },
      processor: this.processBankTransfer.bind(this),
    });

    // Card payment provider
    this.providers.set('card', {
      name: 'Card Payment',
      type: 'card',
      currency: 'KES',
      fees: {
        percentage: 0.025, // 2.5%
        minimum: 20, // KES 20
        maximum: 2000, // KES 2,000
      },
      limits: {
        daily: 2000000, // KES 2,000,000
        transaction: 1000000, // KES 1,000,000
      },
      processor: this.processCardPayment.bind(this),
    });
  }

  /**
   * Process payment
   */
  async processPayment(paymentRequest) {
    try {
      const paymentId = uuidv4();
      logger.info(`Processing payment: ${paymentId}`);

      // Validate payment request
      this.validatePaymentRequest(paymentRequest);

      // Get payment provider
      const provider = this.providers.get(paymentRequest.paymentMethod);
      if (!provider) {
        throw new Error(`Unsupported payment method: ${paymentRequest.paymentMethod}`);
      }

      // Check limits
      await this.checkPaymentLimits(paymentRequest, provider);

      // Calculate fees
      const fees = this.calculateFees(paymentRequest.amount, provider);

      // Create payment record
      const payment = {
        id: paymentId,
        orderId: paymentRequest.orderId,
        userId: paymentRequest.userId,
        amount: paymentRequest.amount,
        currency: paymentRequest.currency || 'KES',
        paymentMethod: paymentRequest.paymentMethod,
        provider: provider.name,
        fees,
        totalAmount: paymentRequest.amount + fees.total,
        status: 'processing',
        metadata: paymentRequest.metadata || {},
        createdAt: new Date().toISOString(),
      };

      // Store payment record
      await this.storePayment(payment);

      // Process with provider
      const result = await provider.processor(payment, paymentRequest);

      // Update payment status
      payment.status = result.success ? 'completed' : 'failed';
      payment.providerTransactionId = result.transactionId;
      payment.providerResponse = result.response;
      payment.completedAt = new Date().toISOString();

      // Update stored payment
      await this.storePayment(payment);

      // Publish payment event
      await this.publishPaymentEvent(payment, result.success ? 'PaymentCompleted' : 'PaymentFailed');

      // Handle escrow if needed
      if (result.success && paymentRequest.useEscrow) {
        await this.createEscrowAccount(payment);
      }

      logger.info(`Payment ${paymentId} ${result.success ? 'completed' : 'failed'}`);
      return {
        paymentId,
        status: payment.status,
        transactionId: result.transactionId,
        amount: payment.amount,
        fees: payment.fees,
        totalAmount: payment.totalAmount,
      };

    } catch (error) {
      logger.error('Payment processing error:', error);
      throw error;
    }
  }

  /**
   * Process M-Pesa payment
   */
  async processMpesaPayment(payment, request) {
    try {
      // Generate M-Pesa transaction
      const transactionId = this.generateMpesaTransactionId();
      
      // Simulate M-Pesa API call
      const mpesaResponse = await this.callMpesaAPI({
        amount: payment.totalAmount,
        phoneNumber: request.phoneNumber,
        accountReference: payment.orderId,
        transactionDesc: `KaziApp payment for order ${payment.orderId}`,
      });

      return {
        success: mpesaResponse.success,
        transactionId,
        response: mpesaResponse,
      };

    } catch (error) {
      logger.error('M-Pesa payment error:', error);
      return {
        success: false,
        error: error.message,
      };
    }
  }

  /**
   * Process bank transfer
   */
  async processBankTransfer(payment, request) {
    try {
      const transactionId = this.generateBankTransactionId();
      
      // Simulate bank API call
      const bankResponse = await this.callBankAPI({
        amount: payment.totalAmount,
        accountNumber: request.accountNumber,
        bankCode: request.bankCode,
        reference: payment.orderId,
      });

      return {
        success: bankResponse.success,
        transactionId,
        response: bankResponse,
      };

    } catch (error) {
      logger.error('Bank transfer error:', error);
      return {
        success: false,
        error: error.message,
      };
    }
  }

  /**
   * Process card payment
   */
  async processCardPayment(payment, request) {
    try {
      const transactionId = this.generateCardTransactionId();
      
      // Simulate card processor API call
      const cardResponse = await this.callCardProcessorAPI({
        amount: payment.totalAmount,
        cardToken: request.cardToken,
        cvv: request.cvv,
        reference: payment.orderId,
      });

      return {
        success: cardResponse.success,
        transactionId,
        response: cardResponse,
      };

    } catch (error) {
      logger.error('Card payment error:', error);
      return {
        success: false,
        error: error.message,
      };
    }
  }

  /**
   * Create escrow account
   */
  async createEscrowAccount(payment) {
    try {
      const escrowId = uuidv4();
      const escrow = {
        id: escrowId,
        paymentId: payment.id,
        orderId: payment.orderId,
        amount: payment.amount,
        currency: payment.currency,
        status: 'held',
        releaseConditions: {
          type: 'order_completion',
          autoRelease: true,
          autoReleaseDelay: 7 * 24 * 60 * 60 * 1000, // 7 days
        },
        createdAt: new Date().toISOString(),
      };

      // Store escrow account
      await this.storeEscrow(escrow);
      this.escrowAccounts.set(escrowId, escrow);

      // Publish escrow event
      await this.publishPaymentEvent(escrow, 'EscrowCreated');

      logger.info(`Escrow account created: ${escrowId} for payment ${payment.id}`);
      return escrowId;

    } catch (error) {
      logger.error('Escrow creation error:', error);
      throw error;
    }
  }

  /**
   * Release escrow funds
   */
  async releaseEscrow(escrowId, reason = 'order_completed') {
    try {
      const escrow = this.escrowAccounts.get(escrowId) || await this.getEscrow(escrowId);
      if (!escrow) {
        throw new Error(`Escrow account not found: ${escrowId}`);
      }

      if (escrow.status !== 'held') {
        throw new Error(`Escrow account ${escrowId} is not in held status`);
      }

      // Calculate commission
      const commission = this.calculateCommission(escrow.amount);
      const sellerAmount = escrow.amount - commission.total;

      // Process seller payment
      const sellerPayment = await this.processSellerPayment(escrow, sellerAmount);

      // Update escrow status
      escrow.status = 'released';
      escrow.releasedAt = new Date().toISOString();
      escrow.reason = reason;
      escrow.commission = commission;
      escrow.sellerAmount = sellerAmount;
      escrow.sellerPaymentId = sellerPayment.id;

      // Store updated escrow
      await this.storeEscrow(escrow);
      this.escrowAccounts.set(escrowId, escrow);

      // Publish escrow event
      await this.publishPaymentEvent(escrow, 'EscrowReleased');

      logger.info(`Escrow ${escrowId} released: ${sellerAmount} KES to seller`);
      return escrow;

    } catch (error) {
      logger.error('Escrow release error:', error);
      throw error;
    }
  }

  /**
   * Process refund
   */
  async processRefund(paymentId, amount, reason) {
    try {
      const refundId = uuidv4();
      const payment = await this.getPayment(paymentId);
      
      if (!payment) {
        throw new Error(`Payment not found: ${paymentId}`);
      }

      if (payment.status !== 'completed') {
        throw new Error(`Cannot refund payment with status: ${payment.status}`);
      }

      const refundAmount = amount || payment.amount;
      if (refundAmount > payment.amount) {
        throw new Error('Refund amount cannot exceed original payment amount');
      }

      // Create refund record
      const refund = {
        id: refundId,
        paymentId,
        orderId: payment.orderId,
        userId: payment.userId,
        amount: refundAmount,
        currency: payment.currency,
        reason,
        status: 'processing',
        createdAt: new Date().toISOString(),
      };

      // Store refund record
      await this.storeRefund(refund);

      // Process refund with provider
      const provider = this.providers.get(payment.paymentMethod);
      const result = await this.processProviderRefund(payment, refund, provider);

      // Update refund status
      refund.status = result.success ? 'completed' : 'failed';
      refund.providerTransactionId = result.transactionId;
      refund.completedAt = new Date().toISOString();

      // Store updated refund
      await this.storeRefund(refund);

      // Publish refund event
      await this.publishPaymentEvent(refund, result.success ? 'RefundCompleted' : 'RefundFailed');

      logger.info(`Refund ${refundId} ${result.success ? 'completed' : 'failed'}`);
      return refund;

    } catch (error) {
      logger.error('Refund processing error:', error);
      throw error;
    }
  }

  /**
   * Calculate fees
   */
  calculateFees(amount, provider) {
    const percentageFee = amount * provider.fees.percentage;
    const actualFee = Math.max(
      Math.min(percentageFee, provider.fees.maximum),
      provider.fees.minimum
    );

    return {
      percentage: provider.fees.percentage,
      amount: actualFee,
      total: actualFee,
    };
  }

  /**
   * Calculate commission
   */
  calculateCommission(amount) {
    const platformFee = amount * 0.05; // 5% platform commission
    const processingFee = amount * 0.01; // 1% processing fee
    
    return {
      platformFee,
      processingFee,
      total: platformFee + processingFee,
    };
  }

  /**
   * Validate payment request
   */
  validatePaymentRequest(request) {
    if (!request.orderId) throw new Error('Order ID is required');
    if (!request.userId) throw new Error('User ID is required');
    if (!request.amount || request.amount <= 0) throw new Error('Valid amount is required');
    if (!request.paymentMethod) throw new Error('Payment method is required');
  }

  /**
   * Check payment limits
   */
  async checkPaymentLimits(request, provider) {
    // Check transaction limit
    if (request.amount > provider.limits.transaction) {
      throw new Error(`Amount exceeds transaction limit of ${provider.limits.transaction}`);
    }

    // Check daily limit
    const dailyTotal = await this.getDailyPaymentTotal(request.userId, request.paymentMethod);
    if (dailyTotal + request.amount > provider.limits.daily) {
      throw new Error(`Amount exceeds daily limit of ${provider.limits.daily}`);
    }
  }

  // Mock API calls (would integrate with real providers)
  async callMpesaAPI(data) {
    // Simulate M-Pesa API call
    await new Promise(resolve => setTimeout(resolve, 2000));
    return { success: Math.random() > 0.1, responseCode: '0', description: 'Success' };
  }

  async callBankAPI(data) {
    // Simulate bank API call
    await new Promise(resolve => setTimeout(resolve, 3000));
    return { success: Math.random() > 0.05, status: 'completed' };
  }

  async callCardProcessorAPI(data) {
    // Simulate card processor API call
    await new Promise(resolve => setTimeout(resolve, 1500));
    return { success: Math.random() > 0.08, authCode: 'AUTH123' };
  }

  // Helper methods
  generateMpesaTransactionId() {
    return `MP${Date.now()}${Math.floor(Math.random() * 1000)}`;
  }

  generateBankTransactionId() {
    return `BT${Date.now()}${Math.floor(Math.random() * 1000)}`;
  }

  generateCardTransactionId() {
    return `CD${Date.now()}${Math.floor(Math.random() * 1000)}`;
  }

  async storePayment(payment) {
    const key = `payment:${payment.id}`;
    await this.redis.setex(key, 86400 * 30, JSON.stringify(payment)); // 30 days
  }

  async getPayment(paymentId) {
    const key = `payment:${paymentId}`;
    const data = await this.redis.get(key);
    return data ? JSON.parse(data) : null;
  }

  async storeEscrow(escrow) {
    const key = `escrow:${escrow.id}`;
    await this.redis.setex(key, 86400 * 90, JSON.stringify(escrow)); // 90 days
  }

  async getEscrow(escrowId) {
    const key = `escrow:${escrowId}`;
    const data = await this.redis.get(key);
    return data ? JSON.parse(data) : null;
  }

  async storeRefund(refund) {
    const key = `refund:${refund.id}`;
    await this.redis.setex(key, 86400 * 30, JSON.stringify(refund)); // 30 days
  }

  async getDailyPaymentTotal(userId, paymentMethod) {
    // Would query database for daily total
    return 0;
  }

  async processSellerPayment(escrow, amount) {
    // Would process payment to seller
    return { id: uuidv4(), amount, status: 'completed' };
  }

  async processProviderRefund(payment, refund, provider) {
    // Would process refund with payment provider
    return { success: true, transactionId: `REF${Date.now()}` };
  }

  async publishPaymentEvent(data, eventType) {
    await this.eventBus.publish('payment-events', eventType, data, {
      source: 'payments-service',
      timestamp: new Date().toISOString(),
    });
  }
}

module.exports = PaymentProcessor;

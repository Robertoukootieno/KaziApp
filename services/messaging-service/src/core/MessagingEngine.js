const { v4: uuidv4 } = require('uuid');
const logger = require('../utils/logger');

/**
 * Messaging Engine - Handles all communication channels
 * Push notifications, SMS, email, in-app chat with moderation
 */
class MessagingEngine {
  constructor(redisClient, eventBus, config) {
    this.redis = redisClient;
    this.eventBus = eventBus;
    this.config = config;
    this.channels = new Map();
    this.moderationRules = new Map();
    this.templates = new Map();
    
    // Initialize communication channels
    this.initializeChannels();
    this.initializeModerationRules();
    this.initializeTemplates();
  }

  /**
   * Initialize communication channels
   */
  initializeChannels() {
    // SMS Channel (Twilio/Africa's Talking)
    this.channels.set('sms', {
      name: 'SMS',
      provider: 'twilio',
      enabled: true,
      rateLimits: {
        perMinute: 10,
        perHour: 100,
        perDay: 500,
      },
      costs: {
        local: 2.5, // KES per SMS
        international: 15,
      },
      sender: this.sendSMS.bind(this),
    });

    // Email Channel
    this.channels.set('email', {
      name: 'Email',
      provider: 'smtp',
      enabled: true,
      rateLimits: {
        perMinute: 20,
        perHour: 200,
        perDay: 1000,
      },
      costs: {
        transactional: 0.5, // KES per email
      },
      sender: this.sendEmail.bind(this),
    });

    // Push Notifications (Firebase)
    this.channels.set('push', {
      name: 'Push Notification',
      provider: 'firebase',
      enabled: true,
      rateLimits: {
        perMinute: 100,
        perHour: 1000,
        perDay: 10000,
      },
      costs: {
        free: true,
      },
      sender: this.sendPushNotification.bind(this),
    });

    // In-App Chat
    this.channels.set('chat', {
      name: 'In-App Chat',
      provider: 'socket.io',
      enabled: true,
      rateLimits: {
        perMinute: 50,
        perHour: 500,
        perDay: 2000,
      },
      costs: {
        free: true,
      },
      sender: this.sendChatMessage.bind(this),
    });

    // WhatsApp Business (future integration)
    this.channels.set('whatsapp', {
      name: 'WhatsApp Business',
      provider: 'whatsapp_business',
      enabled: false,
      rateLimits: {
        perMinute: 5,
        perHour: 50,
        perDay: 200,
      },
      costs: {
        template: 5, // KES per template message
        session: 2, // KES per session message
      },
      sender: this.sendWhatsAppMessage.bind(this),
    });
  }

  /**
   * Initialize content moderation rules
   */
  initializeModerationRules() {
    // Spam detection
    this.moderationRules.set('spam', {
      enabled: true,
      patterns: [
        /\b(buy now|click here|limited time|act fast)\b/gi,
        /\b(free money|get rich|guaranteed income)\b/gi,
        /\b(viagra|casino|lottery|winner)\b/gi,
      ],
      action: 'flag',
      severity: 'medium',
    });

    // Profanity filter
    this.moderationRules.set('profanity', {
      enabled: true,
      patterns: [
        // Add appropriate patterns for local languages
        /\b(badword1|badword2)\b/gi,
      ],
      action: 'block',
      severity: 'high',
    });

    // Scam detection
    this.moderationRules.set('scam', {
      enabled: true,
      patterns: [
        /\b(send money|wire transfer|western union)\b/gi,
        /\b(prince|inheritance|lottery winner)\b/gi,
        /\b(urgent|confidential|secret)\b/gi,
      ],
      action: 'block',
      severity: 'critical',
    });

    // Personal information protection
    this.moderationRules.set('pii', {
      enabled: true,
      patterns: [
        /\b\d{4}[-\s]?\d{4}[-\s]?\d{4}[-\s]?\d{4}\b/g, // Credit card
        /\b\d{10,}\b/g, // Phone numbers
        /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b/g, // Email
      ],
      action: 'redact',
      severity: 'high',
    });
  }

  /**
   * Initialize message templates
   */
  initializeTemplates() {
    // Welcome message
    this.templates.set('welcome', {
      sms: {
        en: 'Welcome to KaziApp! Your agricultural journey starts here. Download the app: {app_link}',
        sw: 'Karibu KaziApp! Safari yako ya kilimo inaanza hapa. Pakua programu: {app_link}',
      },
      email: {
        subject: {
          en: 'Welcome to KaziApp - Your Agricultural Partner',
          sw: 'Karibu KaziApp - Mshirika wako wa Kilimo',
        },
        body: {
          en: 'Welcome to KaziApp! We\'re excited to help you grow your agricultural business.',
          sw: 'Karibu KaziApp! Tunafurahi kukusaidia kukuza biashara yako ya kilimo.',
        },
      },
      push: {
        title: {
          en: 'Welcome to KaziApp!',
          sw: 'Karibu KaziApp!',
        },
        body: {
          en: 'Start your agricultural journey today',
          sw: 'Anza safari yako ya kilimo leo',
        },
      },
    });

    // Order confirmation
    this.templates.set('order_confirmation', {
      sms: {
        en: 'Order #{order_number} confirmed! Total: KES {amount}. Delivery: {delivery_date}',
        sw: 'Oda #{order_number} imethibitishwa! Jumla: KES {amount}. Utoaji: {delivery_date}',
      },
      email: {
        subject: {
          en: 'Order Confirmation - #{order_number}',
          sw: 'Uthibitisho wa Oda - #{order_number}',
        },
        body: {
          en: 'Your order has been confirmed and will be delivered on {delivery_date}.',
          sw: 'Oda yako imethibitishwa na itatolewa tarehe {delivery_date}.',
        },
      },
      push: {
        title: {
          en: 'Order Confirmed',
          sw: 'Oda Imethibitishwa',
        },
        body: {
          en: 'Order #{order_number} - KES {amount}',
          sw: 'Oda #{order_number} - KES {amount}',
        },
      },
    });

    // Appointment reminder
    this.templates.set('appointment_reminder', {
      sms: {
        en: 'Reminder: Appointment with {provider_name} tomorrow at {time}. Location: {location}',
        sw: 'Ukumbusho: Miadi na {provider_name} kesho saa {time}. Mahali: {location}',
      },
      push: {
        title: {
          en: 'Appointment Reminder',
          sw: 'Ukumbusho wa Miadi',
        },
        body: {
          en: 'Tomorrow at {time} with {provider_name}',
          sw: 'Kesho saa {time} na {provider_name}',
        },
      },
    });
  }

  /**
   * Send message through appropriate channel
   */
  async sendMessage(messageRequest) {
    try {
      const messageId = uuidv4();
      logger.info(`Sending message: ${messageId}`);

      // Validate message request
      this.validateMessageRequest(messageRequest);

      // Apply content moderation
      const moderationResult = await this.moderateContent(messageRequest.content);
      if (moderationResult.blocked) {
        throw new Error(`Message blocked by moderation: ${moderationResult.reason}`);
      }

      // Get channel
      const channel = this.channels.get(messageRequest.channel);
      if (!channel || !channel.enabled) {
        throw new Error(`Channel not available: ${messageRequest.channel}`);
      }

      // Check rate limits
      await this.checkRateLimits(messageRequest.userId, messageRequest.channel, channel);

      // Process template if specified
      let content = messageRequest.content;
      if (messageRequest.template) {
        content = this.processTemplate(
          messageRequest.template,
          messageRequest.channel,
          messageRequest.language || 'en',
          messageRequest.variables || {}
        );
      }

      // Create message record
      const message = {
        id: messageId,
        userId: messageRequest.userId,
        channel: messageRequest.channel,
        content: moderationResult.content || content,
        originalContent: messageRequest.content,
        template: messageRequest.template,
        variables: messageRequest.variables,
        recipient: messageRequest.recipient,
        status: 'sending',
        moderationResult,
        metadata: messageRequest.metadata || {},
        createdAt: new Date().toISOString(),
      };

      // Store message record
      await this.storeMessage(message);

      // Send through channel
      const result = await channel.sender(message, messageRequest);

      // Update message status
      message.status = result.success ? 'sent' : 'failed';
      message.providerMessageId = result.messageId;
      message.providerResponse = result.response;
      message.sentAt = new Date().toISOString();
      message.cost = result.cost || 0;

      // Update stored message
      await this.storeMessage(message);

      // Update rate limit counters
      await this.updateRateLimitCounters(messageRequest.userId, messageRequest.channel);

      // Publish message event
      await this.publishMessageEvent(message, result.success ? 'MessageSent' : 'MessageFailed');

      logger.info(`Message ${messageId} ${result.success ? 'sent' : 'failed'} via ${messageRequest.channel}`);
      return {
        messageId,
        status: message.status,
        channel: messageRequest.channel,
        cost: message.cost,
      };

    } catch (error) {
      logger.error('Message sending error:', error);
      throw error;
    }
  }

  /**
   * Send SMS
   */
  async sendSMS(message, request) {
    try {
      // Simulate SMS API call (Twilio/Africa's Talking)
      const messageId = `SMS${Date.now()}${Math.floor(Math.random() * 1000)}`;
      
      // Mock SMS sending
      await new Promise(resolve => setTimeout(resolve, 1000));
      const success = Math.random() > 0.05; // 95% success rate

      return {
        success,
        messageId,
        response: { status: success ? 'sent' : 'failed' },
        cost: this.calculateSMSCost(message.content, request.recipient),
      };

    } catch (error) {
      logger.error('SMS sending error:', error);
      return { success: false, error: error.message };
    }
  }

  /**
   * Send Email
   */
  async sendEmail(message, request) {
    try {
      const messageId = `EMAIL${Date.now()}${Math.floor(Math.random() * 1000)}`;
      
      // Mock email sending
      await new Promise(resolve => setTimeout(resolve, 500));
      const success = Math.random() > 0.02; // 98% success rate

      return {
        success,
        messageId,
        response: { status: success ? 'sent' : 'failed' },
        cost: 0.5, // KES 0.5 per email
      };

    } catch (error) {
      logger.error('Email sending error:', error);
      return { success: false, error: error.message };
    }
  }

  /**
   * Send Push Notification
   */
  async sendPushNotification(message, request) {
    try {
      const messageId = `PUSH${Date.now()}${Math.floor(Math.random() * 1000)}`;
      
      // Mock push notification sending
      await new Promise(resolve => setTimeout(resolve, 200));
      const success = Math.random() > 0.01; // 99% success rate

      return {
        success,
        messageId,
        response: { status: success ? 'sent' : 'failed' },
        cost: 0, // Free
      };

    } catch (error) {
      logger.error('Push notification error:', error);
      return { success: false, error: error.message };
    }
  }

  /**
   * Send Chat Message
   */
  async sendChatMessage(message, request) {
    try {
      const messageId = `CHAT${Date.now()}${Math.floor(Math.random() * 1000)}`;
      
      // Emit through Socket.IO
      // this.io.to(request.recipient).emit('message', message);
      
      return {
        success: true,
        messageId,
        response: { status: 'delivered' },
        cost: 0, // Free
      };

    } catch (error) {
      logger.error('Chat message error:', error);
      return { success: false, error: error.message };
    }
  }

  /**
   * Send WhatsApp Message
   */
  async sendWhatsAppMessage(message, request) {
    try {
      const messageId = `WA${Date.now()}${Math.floor(Math.random() * 1000)}`;
      
      // Mock WhatsApp Business API call
      await new Promise(resolve => setTimeout(resolve, 1500));
      const success = Math.random() > 0.03; // 97% success rate

      return {
        success,
        messageId,
        response: { status: success ? 'sent' : 'failed' },
        cost: request.template ? 5 : 2, // Template vs session message
      };

    } catch (error) {
      logger.error('WhatsApp message error:', error);
      return { success: false, error: error.message };
    }
  }

  /**
   * Moderate content
   */
  async moderateContent(content) {
    const result = {
      blocked: false,
      flagged: false,
      redacted: false,
      content: content,
      violations: [],
    };

    for (const [ruleName, rule] of this.moderationRules) {
      if (!rule.enabled) continue;

      for (const pattern of rule.patterns) {
        if (pattern.test(content)) {
          const violation = {
            rule: ruleName,
            severity: rule.severity,
            action: rule.action,
          };

          result.violations.push(violation);

          switch (rule.action) {
            case 'block':
              result.blocked = true;
              result.reason = `Content violates ${ruleName} policy`;
              return result;

            case 'flag':
              result.flagged = true;
              break;

            case 'redact':
              result.redacted = true;
              result.content = content.replace(pattern, '[REDACTED]');
              break;
          }
        }
      }
    }

    return result;
  }

  /**
   * Process message template
   */
  processTemplate(templateName, channel, language, variables) {
    const template = this.templates.get(templateName);
    if (!template || !template[channel]) {
      throw new Error(`Template not found: ${templateName} for channel ${channel}`);
    }

    let content = template[channel][language] || template[channel]['en'];
    
    // Handle email templates
    if (channel === 'email') {
      const subject = template[channel].subject[language] || template[channel].subject['en'];
      const body = template[channel].body[language] || template[channel].body['en'];
      content = { subject, body };
    }

    // Handle push notification templates
    if (channel === 'push') {
      const title = template[channel].title[language] || template[channel].title['en'];
      const body = template[channel].body[language] || template[channel].body['en'];
      content = { title, body };
    }

    // Replace variables
    if (typeof content === 'string') {
      for (const [key, value] of Object.entries(variables)) {
        content = content.replace(new RegExp(`{${key}}`, 'g'), value);
      }
    } else if (typeof content === 'object') {
      for (const [field, text] of Object.entries(content)) {
        for (const [key, value] of Object.entries(variables)) {
          content[field] = text.replace(new RegExp(`{${key}}`, 'g'), value);
        }
      }
    }

    return content;
  }

  /**
   * Check rate limits
   */
  async checkRateLimits(userId, channel, channelConfig) {
    const limits = channelConfig.rateLimits;
    const now = Date.now();

    // Check per-minute limit
    const minuteKey = `rate_limit:${userId}:${channel}:${Math.floor(now / 60000)}`;
    const minuteCount = await this.redis.incr(minuteKey);
    await this.redis.expire(minuteKey, 60);

    if (minuteCount > limits.perMinute) {
      throw new Error(`Rate limit exceeded: ${limits.perMinute} messages per minute`);
    }

    // Check per-hour limit
    const hourKey = `rate_limit:${userId}:${channel}:${Math.floor(now / 3600000)}`;
    const hourCount = await this.redis.incr(hourKey);
    await this.redis.expire(hourKey, 3600);

    if (hourCount > limits.perHour) {
      throw new Error(`Rate limit exceeded: ${limits.perHour} messages per hour`);
    }

    // Check per-day limit
    const dayKey = `rate_limit:${userId}:${channel}:${Math.floor(now / 86400000)}`;
    const dayCount = await this.redis.incr(dayKey);
    await this.redis.expire(dayKey, 86400);

    if (dayCount > limits.perDay) {
      throw new Error(`Rate limit exceeded: ${limits.perDay} messages per day`);
    }
  }

  /**
   * Calculate SMS cost
   */
  calculateSMSCost(content, recipient) {
    const messageLength = content.length;
    const messageCount = Math.ceil(messageLength / 160); // SMS segments
    const isInternational = !recipient.startsWith('+254'); // Kenya country code
    
    const costPerMessage = isInternational ? 15 : 2.5; // KES
    return messageCount * costPerMessage;
  }

  /**
   * Validate message request
   */
  validateMessageRequest(request) {
    if (!request.userId) throw new Error('User ID is required');
    if (!request.channel) throw new Error('Channel is required');
    if (!request.recipient) throw new Error('Recipient is required');
    if (!request.content && !request.template) throw new Error('Content or template is required');
  }

  /**
   * Store message record
   */
  async storeMessage(message) {
    const key = `message:${message.id}`;
    await this.redis.setex(key, 86400 * 7, JSON.stringify(message)); // 7 days
  }

  /**
   * Update rate limit counters
   */
  async updateRateLimitCounters(userId, channel) {
    // Counters are already updated in checkRateLimits
    // This method can be used for additional tracking
  }

  /**
   * Publish message event
   */
  async publishMessageEvent(message, eventType) {
    await this.eventBus.publish('messaging-events', eventType, message, {
      source: 'messaging-service',
      timestamp: new Date().toISOString(),
    });
  }
}

module.exports = MessagingEngine;

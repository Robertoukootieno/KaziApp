const redis = require('redis');
const logger = require('./logger');

const redisConfig = {
  host: process.env.REDIS_HOST || 'localhost',
  port: process.env.REDIS_PORT || 6379,
  password: process.env.REDIS_PASSWORD || undefined,
  db: process.env.REDIS_DB || 0,
  retryDelayOnFailover: 100,
  enableReadyCheck: false,
  maxRetriesPerRequest: null,
  lazyConnect: true
};

// Create Redis client
const client = redis.createClient({
  socket: {
    host: redisConfig.host,
    port: redisConfig.port
  },
  password: redisConfig.password,
  database: redisConfig.db
});

// Redis event handlers
client.on('connect', () => {
  logger.info('✅ Redis client connected');
});

client.on('ready', () => {
  logger.info('✅ Redis client ready');
});

client.on('error', (err) => {
  logger.error('❌ Redis client error:', err.message);
});

client.on('end', () => {
  logger.info('🔌 Redis client disconnected');
});

// Connect to Redis
const connectRedis = async () => {
  try {
    await client.connect();
    logger.info('✅ Redis connection established successfully');
  } catch (error) {
    logger.error('❌ Unable to connect to Redis:', error.message);
    // Don't exit process - Redis is optional for basic functionality
  }
};

// Redis utility functions
const redisUtils = {
  // Set key with expiration
  setex: async (key, seconds, value) => {
    try {
      await client.setEx(key, seconds, JSON.stringify(value));
    } catch (error) {
      logger.error('Redis setex error:', error.message);
    }
  },

  // Get key
  get: async (key) => {
    try {
      const value = await client.get(key);
      return value ? JSON.parse(value) : null;
    } catch (error) {
      logger.error('Redis get error:', error.message);
      return null;
    }
  },

  // Delete key
  del: async (key) => {
    try {
      await client.del(key);
    } catch (error) {
      logger.error('Redis del error:', error.message);
    }
  },

  // Check if key exists
  exists: async (key) => {
    try {
      return await client.exists(key);
    } catch (error) {
      logger.error('Redis exists error:', error.message);
      return false;
    }
  },

  // Increment counter
  incr: async (key) => {
    try {
      return await client.incr(key);
    } catch (error) {
      logger.error('Redis incr error:', error.message);
      return 0;
    }
  },

  // Set expiration on key
  expire: async (key, seconds) => {
    try {
      await client.expire(key, seconds);
    } catch (error) {
      logger.error('Redis expire error:', error.message);
    }
  }
};

module.exports = {
  client,
  connectRedis,
  redisUtils
};

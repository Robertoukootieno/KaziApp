const redis = require('redis');
const logger = require('../utils/logger');

// Redis configuration
const redisConfig = {
  url: process.env.REDIS_URL || 'redis://localhost:6380',
  password: process.env.REDIS_PASSWORD || undefined,
  retryDelayOnFailover: 100,
  enableReadyCheck: true,
  maxRetriesPerRequest: 3,
  lazyConnect: true,
  keepAlive: 30000,
  connectTimeout: 10000,
  commandTimeout: 5000,
};

// Create Redis client
const client = redis.createClient(redisConfig);

// Error handling
client.on('error', (err) => {
  logger.error('Redis Client Error:', err);
});

client.on('connect', () => {
  logger.info('Redis client connected');
});

client.on('ready', () => {
  logger.info('Redis client ready');
});

client.on('end', () => {
  logger.info('Redis client disconnected');
});

client.on('reconnecting', () => {
  logger.info('Redis client reconnecting');
});

// Connect to Redis
(async () => {
  try {
    await client.connect();
  } catch (error) {
    logger.error('Failed to connect to Redis:', error);
  }
})();

module.exports = client;

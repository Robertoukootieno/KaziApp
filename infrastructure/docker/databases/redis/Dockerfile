# KaziApp Redis Cache
FROM redis:7-alpine

# Install additional tools
RUN apk add --no-cache \
    curl

# Copy Redis configuration
COPY redis.conf /usr/local/etc/redis/redis.conf

# Set proper permissions
RUN chmod 644 /usr/local/etc/redis/redis.conf

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD redis-cli ping

# Expose port
EXPOSE 6379

# Start Redis with custom configuration
CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]

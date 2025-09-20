# KaziApp MongoDB Database
FROM mongo:6-jammy

# Install additional tools
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create directories for initialization scripts
RUN mkdir -p /docker-entrypoint-initdb.d

# Copy initialization scripts
COPY init.js /docker-entrypoint-initdb.d/init.js

# Set proper permissions
RUN chmod -R 755 /docker-entrypoint-initdb.d/

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD mongosh --eval "db.adminCommand('ping')" --quiet

# Expose port
EXPOSE 27017

# Use the default mongo entrypoint
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mongod"]

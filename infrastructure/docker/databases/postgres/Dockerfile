# KaziApp PostgreSQL Database
FROM postgres:15-alpine

# Install additional extensions
RUN apk add --no-cache \
    postgresql-contrib \
    postgis \
    postgis-dev

# Set environment variables
ENV POSTGRES_INITDB_ARGS="--encoding=UTF-8 --lc-collate=C --lc-ctype=C"

# Create directories for initialization scripts
RUN mkdir -p /docker-entrypoint-initdb.d/migrations

# Copy initialization scripts
COPY init.sql /docker-entrypoint-initdb.d/01-init.sql
COPY migrations/ /docker-entrypoint-initdb.d/migrations/

# Set proper permissions
RUN chmod -R 755 /docker-entrypoint-initdb.d/

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD pg_isready -U $POSTGRES_USER -d $POSTGRES_DB

# Expose port
EXPOSE 5432

# Use the default postgres entrypoint
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["postgres"]

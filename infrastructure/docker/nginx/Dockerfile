# KaziApp Nginx Reverse Proxy
FROM nginx:alpine

# Install additional tools
RUN apk add --no-cache \
    curl \
    openssl

# Remove default nginx configuration
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Create SSL directory
RUN mkdir -p /etc/nginx/ssl

# Generate self-signed SSL certificate for development
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/kaziapp.key \
    -out /etc/nginx/ssl/kaziapp.crt \
    -subj "/C=KE/ST=Nairobi/L=Nairobi/O=KaziApp/OU=IT/CN=localhost"

# Set proper permissions
RUN chmod 600 /etc/nginx/ssl/kaziapp.key
RUN chmod 644 /etc/nginx/ssl/kaziapp.crt

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

# Expose ports
EXPOSE 80 443

# Start nginx
CMD ["nginx", "-g", "daemon off;"]

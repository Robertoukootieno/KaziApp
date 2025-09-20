# KaziApp AI Diagnostics Service
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Install system dependencies for AI/ML
RUN apk add --no-cache \
    python3 \
    py3-pip \
    make \
    g++ \
    curl \
    libstdc++ \
    openblas-dev

# Install Python dependencies for AI models
RUN pip3 install --no-cache-dir \
    tensorflow-cpu \
    opencv-python-headless \
    pillow \
    numpy

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production && npm cache clean --force

# Copy source code
COPY src/ ./src/

# Create directories for models and uploads
RUN mkdir -p /app/models /app/uploads

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S kaziapp -u 1001

# Change ownership of the app directory
RUN chown -R kaziapp:nodejs /app
USER kaziapp

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node src/utils/healthcheck.js

# Start the application
CMD ["node", "src/index.js"]

#!/bin/bash

# KaziApp Development Environment Startup Script
# This script starts the KaziApp platform in development mode

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker and try again."
    exit 1
fi

# Change to the docker directory
cd "$(dirname "$0")/.."

# Load environment variables
if [ -f .env ]; then
    print_status "Loading environment variables from .env file..."
    export $(cat .env | grep -v '^#' | xargs)
else
    print_warning ".env file not found. Creating from template..."
    cp .env.example .env
    print_status "Please edit .env file with your configuration and run this script again."
    exit 1
fi

print_status "Starting KaziApp Development Environment..."

# Stop any running containers
print_status "Stopping any existing containers..."
docker-compose down

# Start databases first
print_status "Starting databases..."
docker-compose up -d postgres mongodb redis

# Wait for databases to be ready
print_status "Waiting for databases to be ready..."
sleep 10

# Check database health
print_status "Checking database health..."
for i in {1..30}; do
    if docker-compose exec -T postgres pg_isready -U ${POSTGRES_USER:-kaziapp} > /dev/null 2>&1; then
        print_success "PostgreSQL is ready"
        break
    fi
    if [ $i -eq 30 ]; then
        print_error "PostgreSQL failed to start"
        exit 1
    fi
    sleep 2
done

for i in {1..30}; do
    if docker-compose exec -T mongodb mongosh --eval "db.adminCommand('ping')" > /dev/null 2>&1; then
        print_success "MongoDB is ready"
        break
    fi
    if [ $i -eq 30 ]; then
        print_error "MongoDB failed to start"
        exit 1
    fi
    sleep 2
done

for i in {1..30}; do
    if docker-compose exec -T redis redis-cli ping > /dev/null 2>&1; then
        print_success "Redis is ready"
        break
    fi
    if [ $i -eq 30 ]; then
        print_error "Redis failed to start"
        exit 1
    fi
    sleep 2
done

# Start core services
print_status "Starting core services..."
docker-compose up -d api-gateway user-service auth-service

# Wait for core services
sleep 5

# Start additional services
print_status "Starting additional services..."
services=(
    "communication"
    "ai-diagnostics"
    "marketplace"
    "farm-management"
    "payment-service"
    "notification"
    "community"
    "matching-service"
)

for service in "${services[@]}"; do
    if docker-compose config --services | grep -q "^${service}$"; then
        print_status "Starting ${service}..."
        docker-compose up -d "${service}" || print_warning "Failed to start ${service}"
    fi
done

# Start client applications
print_status "Starting client applications..."
docker-compose up -d web-client

# Start nginx reverse proxy
print_status "Starting nginx reverse proxy..."
docker-compose up -d nginx

# Display status
print_success "KaziApp Development Environment started successfully!"

print_status "Service Status:"
docker-compose ps

print_status "Available URLs:"
echo "  🌐 Web Application: https://localhost"
echo "  🔧 Admin Panel: https://localhost/admin"
echo "  🏪 Service Provider: https://localhost/provider"
echo "  📡 API Gateway: https://localhost/api"

print_status "Database Connections:"
echo "  🐘 PostgreSQL: localhost:${POSTGRES_PORT:-5432}"
echo "  🍃 MongoDB: localhost:${MONGODB_PORT:-27017}"
echo "  🔴 Redis: localhost:${REDIS_PORT:-6379}"

print_status "Useful Commands:"
echo "  📊 View logs: docker-compose logs -f [service-name]"
echo "  🔄 Restart service: docker-compose restart [service-name]"
echo "  🛑 Stop all: docker-compose down"
echo "  🧹 Clean up: ./scripts/cleanup.sh"

print_status "To follow all logs, run:"
echo "  docker-compose logs -f"

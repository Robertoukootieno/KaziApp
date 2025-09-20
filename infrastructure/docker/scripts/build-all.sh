#!/bin/bash

# KaziApp Docker Build All Services Script
# This script builds all Docker images for the KaziApp platform

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

# Check if docker-compose is available
if ! command -v docker-compose > /dev/null 2>&1; then
    print_error "docker-compose is not installed. Please install docker-compose and try again."
    exit 1
fi

print_status "Starting KaziApp Docker build process..."

# Change to the docker directory
cd "$(dirname "$0")/.."

# Load environment variables
if [ -f .env ]; then
    print_status "Loading environment variables from .env file..."
    export $(cat .env | grep -v '^#' | xargs)
else
    print_warning ".env file not found. Using default values."
    print_status "Consider copying .env.example to .env and configuring your environment."
fi

# Build all services
print_status "Building all Docker images..."

# Build databases
print_status "Building database images..."
docker-compose build postgres mongodb redis

# Build core services
print_status "Building core service images..."
docker-compose build api-gateway user-service auth-service communication ai-diagnostics marketplace

# Build additional services
print_status "Building additional service images..."
services=(
    "farm-management"
    "payment-service" 
    "notification"
    "community"
    "matching-service"
    "analytics-service"
    "booking-service"
    "catalog-service"
    "event-bus"
    "event-handlers"
    "media-service"
    "messaging-service"
    "offline-sync"
    "payments-service"
    "saga-orchestrator"
    "search-service"
)

for service in "${services[@]}"; do
    if docker-compose config --services | grep -q "^${service}$"; then
        print_status "Building ${service}..."
        docker-compose build "${service}" || print_warning "Failed to build ${service} (service may not exist yet)"
    else
        print_warning "Service ${service} not found in docker-compose.yml"
    fi
done

# Build client applications
print_status "Building client applications..."
clients=("web-client" "admin-client" "service-provider-client" "ussd-client")

for client in "${clients[@]}"; do
    if docker-compose config --services | grep -q "^${client}$"; then
        print_status "Building ${client}..."
        docker-compose build "${client}" || print_warning "Failed to build ${client} (service may not exist yet)"
    else
        print_warning "Client ${client} not found in docker-compose.yml"
    fi
done

# Build nginx
print_status "Building nginx reverse proxy..."
docker-compose build nginx

# Clean up dangling images
print_status "Cleaning up dangling images..."
docker image prune -f

# Display build summary
print_success "Docker build process completed!"
print_status "Built images:"
docker images | grep kaziapp

print_status "To start the services, run:"
echo "  ./scripts/start-dev.sh    # For development"
echo "  ./scripts/start-prod.sh   # For production"

print_status "To view service status, run:"
echo "  docker-compose ps"

print_status "To view logs, run:"
echo "  docker-compose logs -f [service-name]"

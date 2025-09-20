#!/bin/bash

# KaziApp Docker Health Check Script
# This script checks the health of all KaziApp services

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

print_status "KaziApp Health Check Report"
echo "=================================="

# Check container status
print_status "Container Status:"
docker-compose ps

echo
print_status "Service Health Checks:"

# Define services to check
services=(
    "postgres:5432"
    "mongodb:27017"
    "redis:6379"
    "api-gateway:3000"
    "user-service:3001"
    "auth-service:3002"
    "communication:3003"
    "ai-diagnostics:3004"
    "marketplace:3005"
    "farm-management:3006"
    "payment-service:3007"
    "notification:3008"
    "community:3009"
    "web-client:3010"
    "nginx:80"
)

healthy_count=0
total_count=0

for service_port in "${services[@]}"; do
    service=$(echo $service_port | cut -d: -f1)
    port=$(echo $service_port | cut -d: -f2)
    total_count=$((total_count + 1))
    
    # Check if container is running
    if docker-compose ps | grep -q "$service.*Up"; then
        # Check if port is responding
        if timeout 5 bash -c "</dev/tcp/localhost/$port" 2>/dev/null; then
            print_success "$service is healthy (port $port responding)"
            healthy_count=$((healthy_count + 1))
        else
            print_warning "$service is running but port $port is not responding"
        fi
    else
        print_error "$service is not running"
    fi
done

echo
print_status "Health Summary:"
echo "Healthy services: $healthy_count/$total_count"

if [ $healthy_count -eq $total_count ]; then
    print_success "All services are healthy! 🎉"
    exit 0
elif [ $healthy_count -gt 0 ]; then
    print_warning "Some services need attention"
    exit 1
else
    print_error "No services are healthy"
    exit 2
fi

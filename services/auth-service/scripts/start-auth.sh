#!/bin/bash

# KaziApp Keycloak Authentication Setup Script
# This script starts Keycloak and the authentication integration service

set -e

echo "🚀 Starting KaziApp Keycloak Authentication System..."

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

# Check if Docker Compose is available
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed. Please install Docker Compose and try again."
    exit 1
fi

# Navigate to auth service directory
cd "$(dirname "$0")/.."

print_status "Starting Keycloak and PostgreSQL containers..."

# Start Keycloak services
docker-compose up -d

print_status "Waiting for services to be ready..."

# Wait for PostgreSQL to be ready
print_status "Waiting for PostgreSQL to be ready..."
until docker-compose exec -T keycloak-db pg_isready -U keycloak > /dev/null 2>&1; do
    echo -n "."
    sleep 2
done
print_success "PostgreSQL is ready!"

# Wait for Keycloak to be ready
print_status "Waiting for Keycloak to be ready (this may take a few minutes)..."
KEYCLOAK_READY=false
ATTEMPTS=0
MAX_ATTEMPTS=60

while [ "$KEYCLOAK_READY" = false ] && [ $ATTEMPTS -lt $MAX_ATTEMPTS ]; do
    if curl -f http://localhost:8080/health/ready > /dev/null 2>&1; then
        KEYCLOAK_READY=true
        print_success "Keycloak is ready!"
    else
        echo -n "."
        sleep 5
        ATTEMPTS=$((ATTEMPTS + 1))
    fi
done

if [ "$KEYCLOAK_READY" = false ]; then
    print_error "Keycloak failed to start within the expected time."
    print_error "Please check the logs: docker-compose logs keycloak"
    exit 1
fi

# Import realm configuration
print_status "Importing KaziApp realm configuration..."

# Check if realm already exists
REALM_EXISTS=$(curl -s -o /dev/null -w "%{http_code}" \
    -H "Content-Type: application/json" \
    http://localhost:8080/realms/kaziapp)

if [ "$REALM_EXISTS" = "200" ]; then
    print_warning "KaziApp realm already exists. Skipping import."
else
    # Get admin access token
    ADMIN_TOKEN=$(curl -s -X POST \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "username=admin" \
        -d "password=admin_password" \
        -d "grant_type=password" \
        -d "client_id=admin-cli" \
        http://localhost:8080/realms/master/protocol/openid-connect/token | \
        jq -r '.access_token')

    if [ "$ADMIN_TOKEN" != "null" ] && [ -n "$ADMIN_TOKEN" ]; then
        # Import realm
        curl -s -X POST \
            -H "Authorization: Bearer $ADMIN_TOKEN" \
            -H "Content-Type: application/json" \
            -d @keycloak/realm-config/kaziapp-realm.json \
            http://localhost:8080/admin/realms

        if [ $? -eq 0 ]; then
            print_success "KaziApp realm imported successfully!"
        else
            print_warning "Failed to import realm automatically. You can import it manually through the Keycloak admin console."
        fi
    else
        print_warning "Failed to get admin token. You can import the realm manually through the Keycloak admin console."
    fi
fi

# Navigate to integration service
cd integration-service

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    print_status "Installing dependencies for auth integration service..."
    npm install
fi

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    print_status "Creating .env file for auth integration service..."
    cat > .env << EOF
NODE_ENV=development
PORT=3150

# Keycloak Configuration
KEYCLOAK_BASE_URL=http://localhost:8080
KEYCLOAK_REALM=kaziapp
KEYCLOAK_CLIENT_ID=kaziapp-backend-services
KEYCLOAK_CLIENT_SECRET=backend-services-secret-2024
KEYCLOAK_ADMIN_USERNAME=admin
KEYCLOAK_ADMIN_PASSWORD=admin_password

# Redis Configuration
REDIS_URL=redis://localhost:6380
REDIS_PASSWORD=

# CORS Configuration
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:3010,http://localhost:3011,http://localhost:3012,http://localhost:3002,http://localhost:8080

# Logging
LOG_LEVEL=info
EOF
    print_success ".env file created!"
fi

# Start the auth integration service
print_status "Starting KaziApp Auth Integration Service..."
npm run dev &
AUTH_SERVICE_PID=$!

# Wait a moment for the service to start
sleep 5

# Check if the service is running
if curl -f http://localhost:3150/health > /dev/null 2>&1; then
    print_success "Auth Integration Service is running on port 3150!"
else
    print_warning "Auth Integration Service may not be ready yet. Check the logs if needed."
fi

print_success "🎉 KaziApp Keycloak Authentication System is ready!"
echo ""
echo "📋 Service URLs:"
echo "   🔐 Keycloak Admin Console: http://localhost:8080/admin"
echo "   📱 Auth Integration Service: http://localhost:3150"
echo "   🗄️  PostgreSQL: localhost:5433"
echo "   🔴 Redis: localhost:6380"
echo ""
echo "🔑 Default Admin Credentials:"
echo "   Username: admin"
echo "   Password: admin_password"
echo ""
echo "📖 API Endpoints:"
echo "   POST /auth/login - User login"
echo "   POST /auth/register - User registration"
echo "   POST /auth/refresh - Token refresh"
echo "   POST /auth/logout - User logout"
echo "   GET /config - Client configuration"
echo ""
echo "🛑 To stop all services:"
echo "   docker-compose down"
echo "   kill $AUTH_SERVICE_PID"
echo ""
print_status "Press Ctrl+C to stop the auth integration service..."

# Keep the script running
wait $AUTH_SERVICE_PID
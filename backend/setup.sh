#!/bin/bash

# KaziApp Backend Setup Script
# This script sets up the complete backend environment

set -e

echo "🚀 KaziApp Backend Setup Starting..."
echo "======================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if Node.js is installed
check_node() {
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed. Please install Node.js v16 or higher."
        exit 1
    fi
    
    NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -lt 16 ]; then
        print_error "Node.js version $NODE_VERSION is too old. Please install Node.js v16 or higher."
        exit 1
    fi
    
    print_status "Node.js $(node -v) is installed"
}

# Check if PostgreSQL is installed
check_postgres() {
    if ! command -v psql &> /dev/null; then
        print_warning "PostgreSQL is not installed or not in PATH."
        print_info "Please install PostgreSQL and make sure it's running."
        print_info "On Ubuntu/Debian: sudo apt install postgresql postgresql-contrib"
        print_info "On macOS: brew install postgresql"
        print_info "On Windows: Download from https://www.postgresql.org/download/"
        exit 1
    fi
    
    print_status "PostgreSQL is installed"
}

# Install npm dependencies
install_dependencies() {
    print_info "Installing npm dependencies..."
    npm install
    print_status "Dependencies installed successfully"
}

# Setup environment file
setup_env() {
    if [ ! -f .env ]; then
        print_info "Creating .env file from .env.example..."
        cp .env.example .env
        print_status ".env file created"
        print_warning "Please edit .env file with your database credentials before continuing"
    else
        print_status ".env file already exists"
    fi
}

# Setup PostgreSQL database
setup_database() {
    print_info "Setting up PostgreSQL database..."
    
    # Read database config from .env
    DB_NAME=$(grep DB_NAME .env | cut -d '=' -f2)
    DB_USER=$(grep DB_USER .env | cut -d '=' -f2)
    DB_PASSWORD=$(grep DB_PASSWORD .env | cut -d '=' -f2)
    
    print_info "Database: $DB_NAME"
    print_info "User: $DB_USER"
    
    # Check if database exists
    if psql -lqt | cut -d \| -f 1 | grep -qw $DB_NAME; then
        print_status "Database $DB_NAME already exists"
    else
        print_info "Creating database and user..."
        
        # Create database and user
        sudo -u postgres psql << EOF
CREATE DATABASE $DB_NAME;
CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
ALTER USER $DB_USER CREATEDB;
\q
EOF
        
        print_status "Database and user created successfully"
    fi
}

# Run database migrations
run_migrations() {
    print_info "Running database migrations..."
    npm run migrate
    print_status "Database migrations completed"
}

# Seed initial data
seed_database() {
    print_info "Seeding initial data..."
    npm run seed
    print_status "Database seeded with initial data"
}

# Create uploads directory
setup_uploads() {
    print_info "Setting up uploads directory..."
    mkdir -p uploads/documents uploads/images
    chmod 755 uploads uploads/documents uploads/images
    print_status "Uploads directory created"
}

# Main setup function
main() {
    echo
    print_info "Checking system requirements..."
    check_node
    check_postgres
    
    echo
    print_info "Setting up project..."
    install_dependencies
    setup_env
    setup_uploads
    
    echo
    print_info "Setting up database..."
    
    # Ask user if they want to setup database automatically
    read -p "Do you want to setup the database automatically? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        setup_database
        run_migrations
        seed_database
    else
        print_warning "Skipping database setup. Please set up your database manually:"
        print_info "1. Create database: CREATE DATABASE kaziapp_db;"
        print_info "2. Create user: CREATE USER kaziapp_user WITH PASSWORD 'your_password';"
        print_info "3. Grant privileges: GRANT ALL PRIVILEGES ON DATABASE kaziapp_db TO kaziapp_user;"
        print_info "4. Run migrations: npm run migrate"
        print_info "5. Seed data: npm run seed"
    fi
    
    echo
    print_status "Setup completed successfully!"
    echo
    print_info "Next steps:"
    print_info "1. Review and update .env file if needed"
    print_info "2. Start the development server: npm run dev"
    print_info "3. Or start in production mode: npm start"
    echo
    print_info "Default admin login:"
    print_info "Email: admin@kaziapp.com"
    print_info "Password: admin123"
    echo
    print_info "Server will be available at: http://localhost:3000"
    print_info "API documentation: http://localhost:3000/api/health"
    echo
    print_warning "Remember to change the default admin password in production!"
    echo
}

# Run main function
main "$@"

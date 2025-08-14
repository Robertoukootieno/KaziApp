# KaziApp Setup Guide

This guide will help you set up the KaziApp development environment on your local machine.

## Prerequisites

Before you begin, ensure you have the following installed:

- **Node.js** (v18 or higher)
- **npm** (v8 or higher)
- **Docker** and **Docker Compose**
- **Flutter SDK** (for mobile development)
- **Git**

### Optional but Recommended
- **PostgreSQL** (for local database development)
- **Redis** (for caching and sessions)
- **MongoDB** (for unstructured data)

## Quick Start

### 1. Clone the Repository

```bash
git clone <repository-url>
cd KaziApp
```

### 2. Environment Setup

Copy the environment template and configure your settings:

```bash
cp .env.example .env
```

Edit the `.env` file with your specific configuration:

```bash
# Database Configuration
POSTGRES_DB=kaziapp
POSTGRES_USER=kaziapp
POSTGRES_PASSWORD=your_secure_password

# External API Keys (obtain from respective providers)
MPESA_CONSUMER_KEY=your_mpesa_consumer_key
MPESA_CONSUMER_SECRET=your_mpesa_consumer_secret
TWILIO_ACCOUNT_SID=your_twilio_sid
TWILIO_AUTH_TOKEN=your_twilio_token
WHATSAPP_API_TOKEN=your_whatsapp_token
```

### 3. Start with Docker (Recommended)

The easiest way to get started is using Docker Compose:

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

This will start:
- PostgreSQL database
- MongoDB
- Redis
- API Gateway
- All microservices
- Web client

### 4. Manual Setup (Alternative)

If you prefer to run services individually:

#### Install Dependencies

```bash
# Install root dependencies
npm install

# Install all service dependencies
npm run install:all
```

#### Start Databases

```bash
# Start PostgreSQL
docker run -d --name kaziapp-postgres \
  -e POSTGRES_DB=kaziapp \
  -e POSTGRES_USER=kaziapp \
  -e POSTGRES_PASSWORD=kaziapp_password \
  -p 5432:5432 postgres:15

# Start MongoDB
docker run -d --name kaziapp-mongodb \
  -e MONGO_INITDB_ROOT_USERNAME=kaziapp \
  -e MONGO_INITDB_ROOT_PASSWORD=kaziapp_password \
  -p 27017:27017 mongo:6

# Start Redis
docker run -d --name kaziapp-redis \
  -p 6379:6379 redis:7-alpine
```

#### Start Services

```bash
# Start API Gateway
cd services/api-gateway
npm run dev

# Start User Service (in new terminal)
cd services/user-service
npm run dev

# Start other services as needed...
```

### 5. Mobile App Setup

#### Flutter Setup

```bash
cd clients/mobile

# Get Flutter dependencies
flutter pub get

# Run on Android emulator/device
flutter run

# Run on iOS simulator (macOS only)
flutter run -d ios
```

### 6. Web App Setup

```bash
cd clients/web

# Install dependencies
npm install

# Start development server
npm run dev
```

The web app will be available at `http://localhost:3010`

### 7. USSD Gateway Setup

```bash
cd clients/ussd

# Install dependencies
npm install

# Start USSD gateway
npm run dev
```

## Service URLs

When running locally, services are available at:

- **API Gateway**: http://localhost:3000
- **Web App**: http://localhost:3010
- **USSD Gateway**: http://localhost:3011
- **User Service**: http://localhost:3001
- **Matching Service**: http://localhost:3002
- **Communication Service**: http://localhost:3003
- **AI Diagnostics**: http://localhost:3004
- **Marketplace**: http://localhost:3005
- **Farm Management**: http://localhost:3006
- **Payment Service**: http://localhost:3007
- **Notification Service**: http://localhost:3008
- **Community Service**: http://localhost:3009

## Database Setup

### PostgreSQL Initialization

The database will be automatically initialized with:
- Kenyan counties and sub-counties
- Required extensions (PostGIS, UUID)
- Enum types for user roles and statuses

### Running Migrations

```bash
cd services/user-service
npm run migrate
```

### Seeding Test Data

```bash
cd services/user-service
npm run seed
```

## Testing

### Run All Tests

```bash
npm run test
```

### Run Service-Specific Tests

```bash
cd services/user-service
npm test
```

### Run Web App Tests

```bash
cd clients/web
npm test
```

## Development Workflow

### 1. Code Style

We use ESLint and Prettier for code formatting:

```bash
# Lint all code
npm run lint

# Fix linting issues
npm run lint:fix

# Format code
npm run format
```

### 2. Git Workflow

```bash
# Create feature branch
git checkout -b feature/your-feature-name

# Make changes and commit
git add .
git commit -m "feat: add your feature description"

# Push and create PR
git push origin feature/your-feature-name
```

### 3. Environment Variables

Never commit sensitive environment variables. Use `.env.example` as a template.

## Troubleshooting

### Common Issues

1. **Port conflicts**: Make sure ports 3000-3011 are available
2. **Database connection**: Ensure PostgreSQL is running and credentials are correct
3. **Docker issues**: Try `docker-compose down -v` to reset volumes
4. **Flutter issues**: Run `flutter doctor` to check setup

### Getting Help

- Check the logs: `docker-compose logs service-name`
- View API documentation: http://localhost:3000/api-docs
- Check service health: http://localhost:3000/health

## Next Steps

1. Configure external API keys (M-Pesa, Twilio, etc.)
2. Set up Kenya Veterinary Board API integration
3. Configure SMS and WhatsApp providers
4. Set up monitoring and logging
5. Deploy to staging environment

## Production Deployment

See [DEPLOYMENT.md](./DEPLOYMENT.md) for production deployment instructions.

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for contribution guidelines.

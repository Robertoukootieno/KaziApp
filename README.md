

# KaziApp - Africa-First Agricultural Platform Ecosystem

KaziApp is a comprehensive agricultural platform designed specifically for African farmers and service providers, featuring offline capabilities, multi-language support, and integrated services including veterinary care, marketplace, and AI-powered diagnostics.

## 🌾 Platform Applications

### 📱 KaziApp Mkulima (Farmer App)
**Target Users**: Farmers, Agricultural Workers, Farm Managers
**Access**: http://localhost:3000
**Purpose**: Access agricultural services, products, and expertise

### 🏢 KaziApp Service Provider
**Target Users**: Veterinarians, Agrovets, Retailers, Machinery Providers, Feed Suppliers
**Access**: http://localhost:3001
**Purpose**: Connect with farmers and manage agricultural service business

### 🔧 KaziApp Admin Dashboard
**Target Users**: System Administrators, Platform Managers, Support Staff
**Access**: http://localhost:3002
**Purpose**: Monitor, manage, and administer the entire KaziApp platform

## 🌍 Africa-First Features

- **Offline Access**: USSD gateway for feature phones, SMS integration
- **Multi-language Support**: Kiswahili, Kikuyu, Luo, Kalenjin, Somali voice assistant
- **Mobile Money Integration**: M-Pesa payments, micro-credit, micro-insurance
- **Local Context**: Kenya Veterinary Board API, climate data, market trends
- **Low-bandwidth Optimized**: Works in rural areas with poor connectivity

## 🏗️ Architecture Overview

### 1. Client Layer
- **Mobile App**: Flutter (Android/iOS)
- **Web App**: React.js/Next.js
- **USSD Gateway**: Feature phone access
- **WhatsApp Integration**: Business API for messaging
- **Voice Assistant**: Multi-language support

### 2. API Gateway & Microservices
- **API Gateway**: NGINX/Kong
- **Core Services**: User management, vet matching, communication
- **Africa-Specific Services**: M-Pesa, offline sync, climate data
- **AI Services**: Disease detection, predictive analytics

### 3. Data Layer
- **PostgreSQL**: Structured data
- **MongoDB**: Unstructured data
- **Redis**: Caching and offline sync

### 4. AI/ML Layer
- **Disease Detection**: Animal and crop disease identification
- **Predictive Analytics**: Yield analysis, climate alerts
- **Offline Models**: TensorFlow Lite for basic recognition

## 🚀 Getting Started

### Prerequisites
- Node.js 18+
- Flutter SDK
- Docker & Docker Compose
- Kubernetes (for production)

### Development Setup

#### Option 1: Using New Docker Infrastructure (Recommended)
```bash
# Clone the repository
git clone <repository-url>
cd KaziApp

# Navigate to Docker infrastructure
cd infrastructure/docker

# Copy environment template
cp .env.example .env

# Edit environment variables
nano .env

# Start development environment
./scripts/start-dev.sh

# Check service health
./scripts/health-check.sh
```

#### Option 2: Traditional Setup
```bash
# Start databases only
docker-compose up -d

# Run mobile app
cd clients/mobile
flutter run

# Run web app
cd clients/web
npm run dev

# Run backend
cd backend
npm run dev
```

## 📁 Project Structure

```
KaziApp/
├── clients/                 # Client applications
│   ├── mobile/             # Flutter mobile app
│   ├── web/                # React.js web app
│   ├── admin/              # Admin dashboard
│   ├── service_provider/   # Service provider app
│   └── ussd/               # USSD gateway
├── services/               # Microservices
│   ├── api-gateway/        # API gateway
│   ├── user-service/       # User management
│   ├── auth-service/       # Authentication
│   ├── matchmaking-service/# Vet-farmer matching
│   ├── communication/      # Chat, voice, video
│   ├── ai-diagnostics/     # AI disease detection
│   ├── marketplace/        # Farmer-buyer marketplace
│   ├── payment-service/    # M-Pesa & payments
│   ├── notification/       # Push notifications
│   └── farm-management/    # Farm operations
│   ├── farm-management/    # Farm calculations & data
│   ├── payment-service/    # M-Pesa & payment processing
│   ├── notification/       # SMS, push, WhatsApp
│   └── community/          # Community hub & learning
├── infrastructure/         # DevOps & deployment
│   ├── kubernetes/         # K8s manifests
│   ├── docker/            # Docker configurations
│   └── monitoring/        # Prometheus, Grafana
├── ai-models/             # ML models & training
├── shared/                # Shared libraries
└── docs/                  # Documentation
```

## 🔧 Development

### Running Services
```bash
# Start all services
docker-compose up

# Start specific service
docker-compose up user-service

# View logs
docker-compose logs -f user-service
```

### Testing
```bash
# Run all tests
npm run test

# Run service-specific tests
cd services/user-service
npm test
```

## 🐳 Docker Infrastructure

The project now features a clean, well-structured Docker setup located in `infrastructure/docker/`:

### Directory Structure
```
infrastructure/docker/
├── .env.example              # Environment variables template
├── docker-compose.yml        # Main orchestration file
├── README.md                 # Docker documentation
├── scripts/                  # Utility scripts
│   ├── build-all.sh         # Build all services
│   ├── start-dev.sh         # Start development environment
│   ├── cleanup.sh           # Clean up containers/volumes
│   └── health-check.sh      # Monitor service health
├── databases/               # Database configurations
│   ├── postgres/           # PostgreSQL with PostGIS
│   ├── mongodb/            # MongoDB with validation
│   └── redis/              # Redis caching
├── services/               # Service Dockerfiles
├── clients/                # Client Dockerfiles
└── nginx/                  # Reverse proxy configuration
```

### Quick Docker Commands
```bash
# Start development environment
cd infrastructure/docker
./scripts/start-dev.sh

# Check service health
./scripts/health-check.sh

# Clean up everything
./scripts/cleanup.sh

# Build all services
./scripts/build-all.sh
```

## 🌐 Deployment

### Local Development
```bash
docker-compose up
```

### Production (Kubernetes)
```bash
kubectl apply -f infrastructure/kubernetes/
```

## 🚀 Running the Applications

### KaziApp Mkulima (Farmer App)
```bash
cd clients/mobile
flutter pub get
flutter run -d web-server --web-port=3000
```
**Access at**: http://localhost:3000

### KaziApp Service Provider
```bash
cd clients/service_provider
flutter pub get
flutter run -d web-server --web-port=3001
```
**Access at**: http://localhost:3001

### KaziApp Admin Dashboard
```bash
cd clients/admin
flutter pub get
flutter run -d web-server --web-port=3002
```
**Access at**: http://localhost:3002

**Note**: All three applications can run simultaneously for full platform testing.

## 📖 Documentation

- [API Documentation](docs/api/)
- [Architecture Guide](docs/architecture/)
- [Deployment Guide](docs/deployment/)
- [Contributing Guide](docs/contributing.md)

## 🤝 Contributing

Please read our [Contributing Guide](docs/contributing.md) for details on our code of conduct and the process for submitting pull requests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

For support, email support@kaziapp.com or join our Slack channel.

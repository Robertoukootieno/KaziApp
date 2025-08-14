# KaziApp - Africa-First Agricultural Platform

KaziApp is a comprehensive agricultural platform designed specifically for African farmers, featuring offline capabilities, multi-language support, and integrated services including veterinary care, marketplace, and AI-powered diagnostics.

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
```bash
# Clone the repository
git clone <repository-url>
cd KaziApp

# Install dependencies
npm run install:all

# Start development environment
docker-compose up -d

# Run mobile app
cd clients/mobile
flutter run

# Run web app
cd clients/web
npm run dev
```

## 📁 Project Structure

```
KaziApp/
├── clients/                 # Client applications
│   ├── mobile/             # Flutter mobile app
│   ├── web/                # React.js web app
│   └── ussd/               # USSD gateway
├── services/               # Microservices
│   ├── api-gateway/        # API gateway
│   ├── user-service/       # User & vet registration
│   ├── matching-service/   # Vet-farmer matching
│   ├── communication/      # Chat, voice, video
│   ├── ai-diagnostics/     # AI disease detection
│   ├── marketplace/        # Farmer-buyer marketplace
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

## 🌐 Deployment

### Local Development
```bash
docker-compose up
```

### Production (Kubernetes)
```bash
kubectl apply -f infrastructure/kubernetes/
```

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

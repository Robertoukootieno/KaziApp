# KaziApp Docker Infrastructure

This directory contains all Docker-related files and configurations for the KaziApp agricultural platform.

## Directory Structure

```
infrastructure/docker/
├── README.md                    # This file
├── docker-compose.yml          # Main orchestration file
├── docker-compose.dev.yml      # Development environment
├── docker-compose.prod.yml     # Production environment
├── docker-compose.test.yml     # Testing environment
├── .env.example                # Environment variables template
├── scripts/                    # Docker utility scripts
│   ├── build-all.sh           # Build all services
│   ├── start-dev.sh           # Start development environment
│   ├── start-prod.sh          # Start production environment
│   ├── cleanup.sh             # Clean up containers and volumes
│   └── health-check.sh        # Health check all services
├── services/                   # Service-specific Dockerfiles
│   ├── api-gateway/
│   ├── user-service/
│   ├── auth-service/
│   ├── communication/
│   ├── ai-diagnostics/
│   ├── marketplace/
│   ├── farm-management/
│   ├── payment-service/
│   ├── notification/
│   ├── community/
│   ├── matching-service/
│   ├── analytics-service/
│   ├── booking-service/
│   ├── catalog-service/
│   ├── event-bus/
│   ├── event-handlers/
│   ├── media-service/
│   ├── messaging-service/
│   ├── offline-sync/
│   ├── payments-service/
│   ├── saga-orchestrator/
│   ├── search-service/
│   └── bff-*/
├── clients/                    # Client application Dockerfiles
│   ├── web/
│   ├── mobile/
│   ├── admin/
│   ├── service-provider/
│   └── ussd/
├── databases/                  # Database configurations
│   ├── postgres/
│   │   ├── Dockerfile
│   │   ├── init.sql
│   │   └── migrations/
│   ├── mongodb/
│   │   ├── Dockerfile
│   │   └── init.js
│   └── redis/
│       └── redis.conf
├── nginx/                      # Reverse proxy configuration
│   ├── Dockerfile
│   ├── nginx.conf
│   └── ssl/
├── monitoring/                 # Monitoring stack
│   ├── prometheus/
│   ├── grafana/
│   └── jaeger/
└── volumes/                    # Volume configurations
    ├── postgres-data/
    ├── mongodb-data/
    ├── redis-data/
    └── uploads/
```

## Quick Start

### Development Environment
```bash
cd infrastructure/docker
./scripts/start-dev.sh
```

### Production Environment
```bash
cd infrastructure/docker
./scripts/start-prod.sh
```

### Build All Services
```bash
cd infrastructure/docker
./scripts/build-all.sh
```

## Environment Variables

Copy `.env.example` to `.env` and configure your environment variables:

```bash
cp .env.example .env
```

## Services and Ports

### Core Services
- API Gateway: 3000
- User Service: 3001
- Auth Service: 3002
- Communication: 3003
- AI Diagnostics: 3004
- Marketplace: 3005
- Farm Management: 3006
- Payment Service: 3007
- Notification: 3008
- Community: 3009

### Client Applications
- Web Client: 3010
- Admin Client: 3011
- Service Provider Client: 3012
- USSD Client: 3013

### Databases
- PostgreSQL: 5432
- MongoDB: 27017
- Redis: 6379

### Monitoring
- Prometheus: 9090
- Grafana: 3000
- Jaeger: 16686

## Health Checks

All services include health checks. Monitor service health:

```bash
./scripts/health-check.sh
```

## Scaling Services

Scale specific services:

```bash
docker-compose up -d --scale user-service=3
```

## Logs

View logs for all services:
```bash
docker-compose logs -f
```

View logs for specific service:
```bash
docker-compose logs -f user-service
```

## Cleanup

Clean up containers, networks, and volumes:
```bash
./scripts/cleanup.sh
```

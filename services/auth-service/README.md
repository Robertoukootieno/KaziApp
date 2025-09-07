# 🔐 KaziApp Authentication Service

## Overview

The KaziApp Authentication Service provides enterprise-grade authentication and authorization using Keycloak as the identity provider. This service handles user registration, login, token management, and role-based access control for all KaziApp client applications.

## 🏗️ Architecture

```
services/auth-service/
├── docker-compose.yml              # Keycloak + PostgreSQL + Redis
├── scripts/start-auth.sh          # Service startup script
├── keycloak/
│   ├── realm-config/
│   │   └── kaziapp-realm.json     # Keycloak realm configuration
│   └── themes/                    # Custom Keycloak themes (future)
├── integration-service/           # Node.js API service
│   ├── package.json
│   ├── src/
│   │   ├── core/KeycloakService.js
│   │   ├── routes/
│   │   │   ├── auth.js           # Authentication endpoints
│   │   │   ├── users.js          # User management
│   │   │   └── admin.js          # Admin operations
│   │   ├── utils/
│   │   └── config/
│   └── .env.example
└── legacy/                        # Legacy JWT implementation
    ├── package.json
    └── src/
```

## 🚀 Quick Start

### 1. Start the Authentication System

```bash
# From the KaziApp root directory
cd services/auth-service
./scripts/start-auth.sh
```

This will:
- Start Keycloak server (port 8080)
- Start PostgreSQL database (port 5433)
- Start Redis cache (port 6380)
- Import KaziApp realm configuration
- Start the integration service (port 3150)

### 2. Verify Services

```bash
# Check Keycloak
curl http://localhost:8080/health/ready

# Check Integration Service
curl http://localhost:3150/health

# Check all services
docker-compose ps
```

## 🔧 Configuration

### Environment Variables

Create `.env` file in `integration-service/`:

```env
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

# CORS Configuration
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:3010,http://localhost:3011,http://localhost:3012,http://localhost:3002
```

### Keycloak Clients

| Client ID | Type | Purpose | Redirect URIs |
|-----------|------|---------|---------------|
| `kaziapp-farmer-mobile` | Public | Farmer mobile app | `kaziapp://auth/callback` |
| `kaziapp-provider-mobile` | Public | Provider mobile app | `kaziapp-provider://auth/callback` |
| `kaziapp-admin-web` | Confidential | Admin dashboard | `http://localhost:3002/*` |
| `kaziapp-backend-services` | Service Account | Service-to-service | N/A |

## 📱 API Endpoints

### Authentication

```bash
POST /auth/login          # User login
POST /auth/register       # User registration
POST /auth/refresh        # Token refresh
POST /auth/logout         # User logout
POST /auth/verify-token   # Token validation
POST /auth/forgot-password # Password reset
POST /auth/resend-verification # Resend email verification
```

### User Management

```bash
GET  /users/profile       # Get current user profile
PUT  /users/profile       # Update user profile
POST /users/change-password # Change password
POST /users/verify-email  # Resend verification email
GET  /users/sessions      # List user sessions
DELETE /users/sessions/:id # Logout specific session
```

### Admin Operations

```bash
GET  /admin/users         # List all users
GET  /admin/users/:id     # Get user details
PUT  /admin/users/:id/enable # Enable/disable user
POST /admin/users/:id/reset-password # Reset user password
GET  /admin/stats         # System statistics
GET  /admin/sessions      # List all sessions
DELETE /admin/sessions/:id # Delete session
```

### Configuration

```bash
GET  /config              # Get client configuration
GET  /health              # Service health check
GET  /metrics             # Prometheus metrics
```

## 👥 User Roles & Groups

### Roles

- **farmer**: Agricultural producers
- **service_provider**: General service providers
- **veterinarian**: Animal health specialists (inherits service_provider)
- **agronomist**: Crop specialists (inherits service_provider)
- **buyer**: Marketplace buyers
- **vendor**: Input suppliers
- **admin**: System administrators
- **super_admin**: Super administrators (inherits all roles)

### Groups

- **Farmers**
  - Crop Farmers
  - Livestock Farmers
  - Mixed Farmers
- **Service Providers**
  - Veterinarians
  - Agronomists
  - Equipment Providers
- **Marketplace Users**
  - Buyers
  - Vendors
- **Administrators**
  - System Admins
  - Content Moderators

## 🔒 Security Features

- **JWT Tokens**: Secure, stateless authentication
- **Role-Based Access Control**: Granular permissions
- **Brute Force Protection**: Account lockout after failed attempts
- **Email Verification**: Automated verification workflows
- **Password Policies**: Configurable password requirements
- **Session Management**: Multi-session support with logout
- **Token Refresh**: Automatic token renewal
- **Audit Logging**: Complete authentication audit trail

## 🌍 Localization

- **English (en)**: Default language
- **Swahili (sw)**: Kenyan localization
- **Extensible**: Easy to add more languages

## 📊 Monitoring

### Health Checks

```bash
curl http://localhost:3150/health
curl http://localhost:8080/health/ready
```

### Metrics

```bash
curl http://localhost:3150/metrics
```

### Logs

```bash
# Integration service logs
cd integration-service
tail -f logs/combined.log

# Keycloak logs
docker-compose logs -f keycloak

# Database logs
docker-compose logs -f keycloak-db
```

## 🧪 Testing

### User Registration

```bash
curl -X POST http://localhost:3150/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "John",
    "lastName": "Farmer",
    "phoneNumber": "+254712345678",
    "email": "john.farmer@example.com",
    "password": "SecurePass123",
    "confirmPassword": "SecurePass123",
    "county": "Nairobi",
    "clientType": "farmer",
    "acceptTerms": true
  }'
```

### User Login

```bash
curl -X POST http://localhost:3150/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "+254712345678",
    "password": "SecurePass123",
    "clientType": "farmer"
  }'
```

## 🔧 Development

### Prerequisites

- Docker & Docker Compose
- Node.js 18+
- Redis CLI (optional, for debugging)

### Local Development

```bash
# Start infrastructure
docker-compose up -d keycloak-db redis keycloak

# Install dependencies
cd integration-service
npm install

# Start development server
npm run dev
```

### Database Access

```bash
# Connect to PostgreSQL
docker-compose exec keycloak-db psql -U keycloak -d keycloak

# Connect to Redis
redis-cli -p 6380
```

## 🚀 Deployment

### Production Considerations

1. **SSL/TLS**: Configure HTTPS for Keycloak
2. **Database**: Use managed PostgreSQL service
3. **Redis**: Use managed Redis service
4. **Secrets**: Use proper secret management
5. **Monitoring**: Set up comprehensive monitoring
6. **Backup**: Configure database backups

### Environment-Specific Configuration

- **Development**: `docker-compose.yml`
- **Staging**: `docker-compose.staging.yml`
- **Production**: `docker-compose.prod.yml`

## 🐛 Troubleshooting

### Common Issues

1. **Keycloak not starting**: Check PostgreSQL connection
2. **Integration service errors**: Verify Keycloak is ready
3. **Token validation fails**: Check client configuration
4. **Database connection issues**: Verify PostgreSQL status

### Reset Everything

```bash
# Stop all services and remove data
docker-compose down -v
docker volume prune -f

# Start fresh
./scripts/start-auth.sh
```

## 📚 Documentation

- [Keycloak Documentation](https://www.keycloak.org/documentation)
- [OAuth2/OpenID Connect Specs](https://oauth.net/2/)
- [JWT Tokens](https://jwt.io/)

## 🤝 Contributing

1. Follow the existing code structure
2. Add tests for new features
3. Update documentation
4. Follow security best practices

## 📄 License

This project is part of KaziApp and follows the same licensing terms.

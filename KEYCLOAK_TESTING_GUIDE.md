# 🔐 KaziApp Keycloak Authentication Testing Guide

## 🚀 Quick Start

### 1. Start the Authentication System

```bash
# Make sure you're in the KaziApp root directory
cd /path/to/KaziApp

# Start Keycloak and Auth Integration Service
./scripts/start-auth.sh
```

This script will:
- Start Keycloak with PostgreSQL database
- Import the KaziApp realm configuration
- Start the Auth Integration Service
- Set up all necessary configurations

### 2. Verify Services are Running

Check that all services are healthy:

```bash
# Check Keycloak
curl http://localhost:8080/health/ready

# Check Auth Integration Service
curl http://localhost:3150/health

# Check PostgreSQL
docker-compose -f services/auth-service/docker-compose.yml exec keycloak-db pg_isready -U keycloak

# Check Redis
redis-cli -p 6380 ping
```

## 🌐 Service URLs

| Service | URL | Purpose |
|---------|-----|---------|
| **Keycloak Admin Console** | http://localhost:8080/admin | Keycloak management |
| **Auth Integration Service** | http://localhost:3150 | API endpoints |
| **PostgreSQL** | localhost:5433 | Database |
| **Redis** | localhost:6380 | Session cache |

## 🔑 Default Credentials

### Keycloak Admin
- **Username:** `admin`
- **Password:** `admin_password`
- **URL:** http://localhost:8080/admin

### Database
- **Host:** localhost:5433
- **Database:** keycloak
- **Username:** keycloak
- **Password:** keycloak_password

## 📱 Testing with Mobile Apps

### 1. Update Mobile App Configuration

The mobile app will automatically connect to the auth service at `http://localhost:3150`.

### 2. Test User Registration

```bash
# Test farmer registration
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
    "preferredLanguage": "en",
    "clientType": "farmer",
    "acceptTerms": true
  }'
```

### 3. Test User Login

```bash
# Test login with phone number
curl -X POST http://localhost:3150/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "+254712345678",
    "password": "SecurePass123",
    "clientType": "farmer",
    "rememberMe": true
  }'
```

### 4. Test Token Refresh

```bash
# Use refresh token from login response
curl -X POST http://localhost:3150/auth/refresh \
  -H "Content-Type: application/json" \
  -d '{
    "refreshToken": "YOUR_REFRESH_TOKEN_HERE",
    "clientType": "farmer"
  }'
```

## 🧪 API Testing Examples

### Authentication Endpoints

#### Register New User
```bash
curl -X POST http://localhost:3150/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "Jane",
    "lastName": "Provider",
    "phoneNumber": "+254723456789",
    "email": "jane.provider@example.com",
    "password": "SecurePass123",
    "confirmPassword": "SecurePass123",
    "county": "Kiambu",
    "preferredLanguage": "sw",
    "clientType": "provider",
    "acceptTerms": true
  }'
```

#### Login User
```bash
curl -X POST http://localhost:3150/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "+254723456789",
    "password": "SecurePass123",
    "clientType": "provider"
  }'
```

#### Verify Token
```bash
curl -X POST http://localhost:3150/auth/verify-token \
  -H "Content-Type: application/json" \
  -d '{
    "token": "YOUR_ACCESS_TOKEN_HERE"
  }'
```

#### Logout User
```bash
curl -X POST http://localhost:3150/auth/logout \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN_HERE"
```

### User Management Endpoints

#### Get User Profile
```bash
curl -X GET http://localhost:3150/users/profile \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN_HERE"
```

#### Update User Profile
```bash
curl -X PUT http://localhost:3150/users/profile \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "Updated Name",
    "county": "Mombasa",
    "preferredLanguage": "sw"
  }'
```

### Admin Endpoints

#### Get All Users (Admin Only)
```bash
curl -X GET "http://localhost:3150/admin/users?page=1&limit=10" \
  -H "Authorization: Bearer YOUR_ADMIN_TOKEN_HERE"
```

#### Get System Statistics
```bash
curl -X GET http://localhost:3150/admin/stats \
  -H "Authorization: Bearer YOUR_ADMIN_TOKEN_HERE"
```

## 📱 Flutter Mobile App Testing

### 1. Update Dependencies

Make sure your `pubspec.yaml` includes the Keycloak dependencies:

```yaml
dependencies:
  openid_client: ^0.4.4
  jwt_decoder: ^2.0.1
  dio: ^5.3.2
```

### 2. Test Authentication Flow

```dart
// Initialize auth service
final authService = KeycloakAuthService();
await authService.initialize();

// Test login
final result = await authService.login('+254712345678', 'SecurePass123');
if (result.success) {
  print('Login successful: ${result.user?.fullName}');
} else {
  print('Login failed: ${result.error}');
}

// Test registration
final registration = UserRegistration(
  firstName: 'Test',
  lastName: 'User',
  phoneNumber: '+254734567890',
  password: 'SecurePass123',
  confirmPassword: 'SecurePass123',
  clientType: 'farmer',
);

final regResult = await authService.register(registration);
if (regResult.success) {
  print('Registration successful');
} else {
  print('Registration failed: ${regResult.error}');
}
```

## 🔧 Configuration

### Client Types and Roles

The system supports multiple client types with different roles:

| Client Type | Roles | Description |
|-------------|-------|-------------|
| **farmer** | `farmer` | Agricultural producers |
| **provider** | `service_provider` | General service providers |
| **veterinarian** | `veterinarian`, `service_provider` | Animal health specialists |
| **agronomist** | `agronomist`, `service_provider` | Crop specialists |
| **buyer** | `buyer` | Marketplace buyers |
| **vendor** | `vendor` | Input suppliers |
| **admin** | `admin` | System administrators |

### Keycloak Realm Configuration

The realm includes:
- **Multi-language support** (English/Swahili)
- **Role-based access control**
- **Group-based organization**
- **Email verification**
- **Password policies**
- **Brute force protection**

## 🐛 Troubleshooting

### Common Issues

#### 1. Keycloak Not Starting
```bash
# Check logs
docker-compose -f services/keycloak-auth/docker-compose.yml logs keycloak

# Restart services
docker-compose -f services/keycloak-auth/docker-compose.yml restart
```

#### 2. Auth Service Connection Issues
```bash
# Check if Keycloak is ready
curl http://localhost:8080/health/ready

# Check auth service logs
cd services/keycloak-auth/auth-integration-service
npm run dev
```

#### 3. Database Connection Issues
```bash
# Check PostgreSQL status
docker-compose -f services/keycloak-auth/docker-compose.yml exec keycloak-db pg_isready -U keycloak

# Restart database
docker-compose -f services/keycloak-auth/docker-compose.yml restart keycloak-db
```

#### 4. Redis Connection Issues
```bash
# Check Redis status
redis-cli -p 6380 ping

# Restart Redis
docker-compose -f services/keycloak-auth/docker-compose.yml restart redis
```

### Reset Everything

If you need to start fresh:

```bash
# Stop all services
docker-compose -f services/keycloak-auth/docker-compose.yml down -v

# Remove all data
docker volume prune -f

# Start again
./scripts/start-keycloak-auth.sh
```

## 📊 Monitoring

### Health Checks

```bash
# Overall system health
curl http://localhost:3150/health

# Keycloak health
curl http://localhost:8080/health/ready

# Metrics
curl http://localhost:3150/metrics
```

### Logs

```bash
# Keycloak logs
docker-compose -f services/keycloak-auth/docker-compose.yml logs -f keycloak

# Auth service logs
cd services/keycloak-auth/auth-integration-service
tail -f logs/combined.log

# Database logs
docker-compose -f services/keycloak-auth/docker-compose.yml logs -f keycloak-db
```

## 🎯 Next Steps

1. **Test with Mobile Apps**: Run the Flutter apps and test the authentication flow
2. **Create Test Users**: Use the Keycloak admin console to create test users
3. **Test Role-Based Access**: Verify different user types have appropriate permissions
4. **Integration Testing**: Test with other KaziApp services
5. **Performance Testing**: Load test the authentication endpoints

## 📞 Support

If you encounter issues:

1. Check the logs for error messages
2. Verify all services are running and healthy
3. Ensure network connectivity between services
4. Check the Keycloak admin console for user and realm status

The authentication system is now ready for testing with all KaziApp client applications! 🎉

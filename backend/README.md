# KaziApp Backend API

A complete Node.js/Express backend with PostgreSQL database integration for the KaziApp real-time service provider registration workflow.

## Features

- **Real-time Communication**: WebSocket support for instant notifications
- **Database Integration**: PostgreSQL with Sequelize ORM
- **Authentication & Authorization**: JWT-based auth with role-based permissions
- **File Upload**: Multer with image processing using Sharp
- **Caching**: Redis integration for performance optimization
- **Validation**: Comprehensive input validation with express-validator
- **Security**: Helmet, CORS, rate limiting, and secure file handling
- **Logging**: Winston-based structured logging
- **API Documentation**: RESTful API with proper error handling

## Quick Start

### Prerequisites

- Node.js (v16 or higher)
- PostgreSQL (v12 or higher)
- Redis (optional, for caching)

### Installation

1. **Clone and navigate to backend directory**
   ```bash
   cd backend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your database credentials
   ```

4. **Set up PostgreSQL database**
   ```sql
   -- Connect to PostgreSQL as superuser
   CREATE DATABASE kaziapp_db;
   CREATE USER kaziapp_user WITH PASSWORD 'kaziapp_password';
   GRANT ALL PRIVILEGES ON DATABASE kaziapp_db TO kaziapp_user;
   ```

5. **Run database migrations**
   ```bash
   npm run migrate
   ```

6. **Seed initial data**
   ```bash
   npm run seed
   ```

7. **Start the server**
   ```bash
   # Development mode with auto-reload
   npm run dev
   
   # Production mode
   npm start
   ```

The server will start on `http://localhost:3000`

## API Endpoints

### Authentication
- `POST /api/auth/login` - Admin login
- `POST /api/auth/logout` - Admin logout
- `POST /api/auth/refresh-token` - Refresh JWT token
- `GET /api/auth/profile` - Get current user profile
- `PUT /api/auth/profile` - Update user profile
- `PUT /api/auth/change-password` - Change password

### Service Provider Registration
- `POST /api/service-provider/register` - Submit registration (public)

### Admin Registration Management
- `GET /api/admin/registrations` - Get all registrations (with filters)
- `GET /api/admin/registrations/pending` - Get pending registrations
- `GET /api/admin/registrations/statistics` - Get registration statistics
- `GET /api/admin/registrations/:id` - Get registration by ID
- `POST /api/admin/registrations/:id/approve` - Approve registration
- `POST /api/admin/registrations/:id/reject` - Reject registration
- `POST /api/admin/registrations/:id/under-review` - Set under review
- `POST /api/admin/registrations/bulk/approve` - Bulk approve
- `POST /api/admin/registrations/bulk/reject` - Bulk reject

### Document Management
- `GET /api/admin/registrations/:registrationId/documents` - Get documents
- `POST /api/admin/registrations/:registrationId/documents/:documentId/verify` - Verify document

### System
- `GET /api/health` - Health check
- `GET /api/status` - System status

## WebSocket Events

### Admin Events
- `join-admin` - Join admin room for notifications
- `registration_submitted` - New registration submitted
- `registration_updated` - Registration status changed
- `document_updated` - Document verification status changed
- `system_notification` - System-wide notifications

### Service Provider Events
- `join-service-provider` - Join service provider room
- `registration_status_changed` - Registration status update
- `document_status_changed` - Document verification update

## Database Schema

### Tables
- `admin_users` - Admin user accounts
- `service_provider_registrations` - Registration submissions
- `registration_documents` - Uploaded documents

### Key Relationships
- Registration → Documents (One-to-Many)
- Admin User → Registrations (approval/rejection tracking)

## File Upload

Supports the following document types:
- Business License
- Business Logo
- ID Copy
- Tax Certificate
- Insurance Certificate
- Bank Statement

**File Limits:**
- Maximum size: 10MB per file
- Allowed types: Images (JPEG, PNG, GIF, WebP) and PDFs
- Automatic image optimization with Sharp

## Security Features

- **Authentication**: JWT tokens with refresh token support
- **Authorization**: Role-based access control (Super Admin, Admin, Moderator, Reviewer)
- **Rate Limiting**: Configurable request limits per IP
- **Input Validation**: Comprehensive validation with sanitization
- **File Security**: Type validation and secure storage
- **CORS**: Configurable cross-origin resource sharing
- **Helmet**: Security headers protection

## Environment Variables

Key configuration options:

```env
# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=kaziapp_db
DB_USER=kaziapp_user
DB_PASSWORD=your_password

# JWT
JWT_SECRET=your_jwt_secret
JWT_EXPIRES_IN=7d

# File Upload
MAX_FILE_SIZE=10485760
UPLOAD_DIR=uploads

# WebSocket
WS_CORS_ORIGINS=http://localhost:8091,http://localhost:8092
```

## Default Admin Account

After seeding, you can login with:
- **Email**: admin@kaziapp.com
- **Password**: admin123

**⚠️ Change the default password in production!**

## Development

```bash
# Run with auto-reload
npm run dev

# Run database migrations
npm run migrate

# Seed database with sample data
npm run seed

# Run tests
npm test

# Lint code
npm run lint

# Format code
npm run format
```

## Production Deployment

1. Set `NODE_ENV=production`
2. Configure production database
3. Set secure JWT secrets
4. Configure Redis for caching
5. Set up SSL/TLS
6. Configure reverse proxy (nginx)
7. Set up process manager (PM2)

## API Response Format

All API responses follow this format:

```json
{
  "success": true|false,
  "message": "Response message",
  "data": {}, // Response data (if applicable)
  "errors": [], // Validation errors (if applicable)
  "pagination": {} // Pagination info (for list endpoints)
}
```

## Error Handling

The API provides detailed error responses with appropriate HTTP status codes:

- `400` - Bad Request (validation errors)
- `401` - Unauthorized (authentication required)
- `403` - Forbidden (insufficient permissions)
- `404` - Not Found
- `429` - Too Many Requests (rate limit exceeded)
- `500` - Internal Server Error

## Logging

Structured logging with Winston:
- Console output in development
- File logging in production
- Error tracking and monitoring
- Request/response logging with Morgan

## Support

For issues and questions:
1. Check the logs in `logs/` directory
2. Verify database connection
3. Check environment variables
4. Review API documentation

## License

MIT License - see LICENSE file for details.

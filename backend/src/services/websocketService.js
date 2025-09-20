const { Server } = require('socket.io');
const jwt = require('jsonwebtoken');
const { AdminUser } = require('../models');
const logger = require('../config/logger');

class WebSocketService {
  constructor(server) {
    this.io = new Server(server, {
      cors: {
        origin: process.env.WS_CORS_ORIGINS?.split(',') || [
          "http://localhost:8091",
          "http://localhost:8092"
        ],
        methods: ["GET", "POST"],
        credentials: true
      },
      transports: ['websocket', 'polling']
    });

    this.setupMiddleware();
    this.setupEventHandlers();
  }

  setupMiddleware() {
    // Authentication middleware for admin connections
    this.io.use(async (socket, next) => {
      try {
        const token = socket.handshake.auth.token || socket.handshake.headers.authorization?.replace('Bearer ', '');
        
        if (!token) {
          // Allow anonymous connections for service provider notifications
          socket.isAuthenticated = false;
          return next();
        }

        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        const user = await AdminUser.findByPk(decoded.id, {
          attributes: { exclude: ['password', 'passwordResetToken', 'twoFactorSecret'] }
        });

        if (!user || !user.isActive) {
          return next(new Error('Authentication failed'));
        }

        socket.user = user;
        socket.isAuthenticated = true;
        next();
      } catch (error) {
        logger.error('WebSocket authentication error:', error);
        next(new Error('Authentication failed'));
      }
    });
  }

  setupEventHandlers() {
    this.io.on('connection', (socket) => {
      logger.info(`WebSocket connection established: ${socket.id}`);

      // Handle admin room joining
      socket.on('join-admin', () => {
        if (socket.isAuthenticated && socket.user) {
          socket.join('admin-room');
          logger.info(`Admin joined room: ${socket.user.email} (${socket.id})`);
          
          socket.emit('joined-admin', {
            success: true,
            message: 'Successfully joined admin room',
            user: {
              id: socket.user.id,
              name: socket.user.name,
              email: socket.user.email,
              role: socket.user.role
            }
          });
        } else {
          socket.emit('error', {
            message: 'Authentication required to join admin room'
          });
        }
      });

      // Handle service provider room joining
      socket.on('join-service-provider', (data) => {
        const { registrationId } = data;
        if (registrationId) {
          socket.join(`service-provider-${registrationId}`);
          logger.info(`Service provider joined room: ${registrationId} (${socket.id})`);
          
          socket.emit('joined-service-provider', {
            success: true,
            message: 'Successfully joined service provider room',
            registrationId
          });
        }
      });

      // Handle ping/pong for connection health
      socket.on('ping', () => {
        socket.emit('pong', { timestamp: Date.now() });
      });

      // Handle disconnection
      socket.on('disconnect', (reason) => {
        logger.info(`WebSocket disconnected: ${socket.id} - ${reason}`);
      });

      // Handle connection errors
      socket.on('error', (error) => {
        logger.error(`WebSocket error for ${socket.id}:`, error);
      });
    });
  }

  // Emit registration submitted notification to admins
  emitRegistrationSubmitted(registrationData) {
    this.io.to('admin-room').emit('registration_submitted', {
      type: 'registration_submitted',
      data: registrationData,
      timestamp: new Date().toISOString()
    });

    logger.info(`Registration submitted notification sent: ${registrationData.id}`);
  }

  // Emit registration updated notification
  emitRegistrationUpdated(type, registrationData) {
    // Notify admins
    this.io.to('admin-room').emit('registration_updated', {
      type,
      data: registrationData,
      timestamp: new Date().toISOString()
    });

    // Notify specific service provider
    this.io.to(`service-provider-${registrationData.id}`).emit('registration_status_changed', {
      type,
      data: {
        id: registrationData.id,
        status: registrationData.status,
        approvedAt: registrationData.approvedAt,
        rejectedAt: registrationData.rejectedAt,
        approvalNotes: registrationData.approvalNotes,
        rejectionReason: registrationData.rejectionReason
      },
      timestamp: new Date().toISOString()
    });

    logger.info(`Registration updated notification sent: ${registrationData.id} - ${type}`);
  }

  // Emit document verification notification
  emitDocumentUpdated(registrationId, documentData) {
    this.io.to('admin-room').emit('document_updated', {
      type: 'document_verified',
      data: {
        registrationId,
        document: documentData
      },
      timestamp: new Date().toISOString()
    });

    this.io.to(`service-provider-${registrationId}`).emit('document_status_changed', {
      type: 'document_verified',
      data: documentData,
      timestamp: new Date().toISOString()
    });

    logger.info(`Document updated notification sent: ${documentData.id}`);
  }

  // Emit system notification to all admins
  emitSystemNotification(message, type = 'info') {
    this.io.to('admin-room').emit('system_notification', {
      type: 'system_notification',
      level: type,
      message,
      timestamp: new Date().toISOString()
    });

    logger.info(`System notification sent: ${message}`);
  }

  // Get connected admin count
  getConnectedAdminCount() {
    const adminRoom = this.io.sockets.adapter.rooms.get('admin-room');
    return adminRoom ? adminRoom.size : 0;
  }

  // Get all connected clients count
  getConnectedClientsCount() {
    return this.io.engine.clientsCount;
  }

  // Broadcast to all connected clients
  broadcast(event, data) {
    this.io.emit(event, {
      ...data,
      timestamp: new Date().toISOString()
    });
  }

  // Get WebSocket statistics
  getStats() {
    return {
      connectedClients: this.getConnectedClientsCount(),
      connectedAdmins: this.getConnectedAdminCount(),
      rooms: Array.from(this.io.sockets.adapter.rooms.keys()),
      uptime: process.uptime()
    };
  }
}

module.exports = WebSocketService;

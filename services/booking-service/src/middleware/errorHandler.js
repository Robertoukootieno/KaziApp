const logger = require('../utils/logger');

/**
 * Global error handler middleware
 */
const errorHandler = (error, req, res, next) => {
  // Log the error
  logger.error('Unhandled error:', {
    error: error.message,
    stack: error.stack,
    url: req.url,
    method: req.method,
    ip: req.ip,
    userAgent: req.headers['user-agent'],
    correlationId: req.correlationId,
    userId: req.user?.id,
  });

  // Default error response
  let statusCode = 500;
  let message = 'Internal server error';
  let details = null;

  // Handle specific error types
  if (error.name === 'ValidationError') {
    // Mongoose validation error
    statusCode = 400;
    message = 'Validation failed';
    details = Object.values(error.errors).map(err => ({
      field: err.path,
      message: err.message,
      value: err.value,
    }));
  } else if (error.name === 'CastError') {
    // Mongoose cast error (invalid ObjectId, etc.)
    statusCode = 400;
    message = 'Invalid data format';
    details = {
      field: error.path,
      value: error.value,
      expectedType: error.kind,
    };
  } else if (error.code === 11000) {
    // MongoDB duplicate key error
    statusCode = 409;
    message = 'Duplicate entry';
    const field = Object.keys(error.keyPattern)[0];
    details = {
      field,
      message: `${field} already exists`,
    };
  } else if (error.name === 'JsonWebTokenError') {
    // JWT error
    statusCode = 401;
    message = 'Invalid token';
  } else if (error.name === 'TokenExpiredError') {
    // JWT expired
    statusCode = 401;
    message = 'Token expired';
  } else if (error.name === 'UnauthorizedError') {
    // Custom unauthorized error
    statusCode = 401;
    message = error.message || 'Unauthorized';
  } else if (error.name === 'ForbiddenError') {
    // Custom forbidden error
    statusCode = 403;
    message = error.message || 'Forbidden';
  } else if (error.name === 'NotFoundError') {
    // Custom not found error
    statusCode = 404;
    message = error.message || 'Resource not found';
  } else if (error.name === 'ConflictError') {
    // Custom conflict error
    statusCode = 409;
    message = error.message || 'Conflict';
  } else if (error.statusCode || error.status) {
    // Error with explicit status code
    statusCode = error.statusCode || error.status;
    message = error.message || message;
  }

  // Don't expose internal errors in production
  if (process.env.NODE_ENV === 'production' && statusCode === 500) {
    message = 'Internal server error';
    details = null;
  }

  // Send error response
  const errorResponse = {
    success: false,
    error: message,
    timestamp: new Date().toISOString(),
    correlationId: req.correlationId,
  };

  if (details) {
    errorResponse.details = details;
  }

  // Add stack trace in development
  if (process.env.NODE_ENV === 'development') {
    errorResponse.stack = error.stack;
  }

  res.status(statusCode).json(errorResponse);
};

/**
 * Custom error classes
 */
class AppError extends Error {
  constructor(message, statusCode = 500) {
    super(message);
    this.name = this.constructor.name;
    this.statusCode = statusCode;
    Error.captureStackTrace(this, this.constructor);
  }
}

class ValidationError extends AppError {
  constructor(message, details = null) {
    super(message, 400);
    this.details = details;
  }
}

class UnauthorizedError extends AppError {
  constructor(message = 'Unauthorized') {
    super(message, 401);
  }
}

class ForbiddenError extends AppError {
  constructor(message = 'Forbidden') {
    super(message, 403);
  }
}

class NotFoundError extends AppError {
  constructor(message = 'Resource not found') {
    super(message, 404);
  }
}

class ConflictError extends AppError {
  constructor(message = 'Conflict') {
    super(message, 409);
  }
}

class RateLimitError extends AppError {
  constructor(message = 'Too many requests') {
    super(message, 429);
  }
}

/**
 * Async error wrapper
 * Wraps async route handlers to catch errors automatically
 */
const asyncHandler = (fn) => {
  return (req, res, next) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
};

/**
 * 404 handler for undefined routes
 */
const notFoundHandler = (req, res, next) => {
  const error = new NotFoundError(`Route ${req.method} ${req.path} not found`);
  next(error);
};

module.exports = {
  errorHandler,
  AppError,
  ValidationError,
  UnauthorizedError,
  ForbiddenError,
  NotFoundError,
  ConflictError,
  RateLimitError,
  asyncHandler,
  notFoundHandler,
};

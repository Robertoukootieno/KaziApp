const mongoose = require('mongoose');

const BookingItemSchema = new mongoose.Schema({
  serviceId: {
    type: String,
    required: true,
  },
  serviceName: {
    type: String,
    required: true,
  },
  quantity: {
    type: Number,
    required: true,
    min: 1,
  },
  unitPrice: {
    type: Number,
    required: true,
    min: 0,
  },
  totalPrice: {
    type: Number,
    required: true,
    min: 0,
  },
  metadata: {
    type: mongoose.Schema.Types.Mixed,
    default: {},
  },
});

const BookingLocationSchema = new mongoose.Schema({
  type: {
    type: String,
    enum: ['Point'],
    required: true,
  },
  coordinates: {
    type: [Number],
    required: true,
    validate: {
      validator: function(v) {
        return v.length === 2;
      },
      message: 'Coordinates must be [longitude, latitude]',
    },
  },
  address: {
    type: String,
    required: true,
  },
  county: String,
  subCounty: String,
  ward: String,
  landmark: String,
});

const BookingSchema = new mongoose.Schema({
  // Core identifiers
  bookingId: {
    type: String,
    required: true,
    unique: true,
    index: true,
  },
  
  // Participants
  farmerId: {
    type: String,
    required: true,
    index: true,
  },
  providerId: {
    type: String,
    index: true,
  },
  
  // Farmer details
  farmerName: {
    type: String,
    required: true,
  },
  farmerPhone: {
    type: String,
    required: true,
  },
  farmerEmail: String,
  
  // Provider details (populated when matched)
  providerName: String,
  providerPhone: String,
  providerEmail: String,
  
  // Booking details
  title: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    required: true,
  },
  category: {
    type: String,
    required: true,
    enum: ['veterinary', 'crop_advisory', 'equipment_rental', 'labor', 'transport', 'other'],
  },
  
  // Scheduling
  requestedDate: {
    type: Date,
    required: true,
  },
  requestedTime: String,
  scheduledDate: Date,
  scheduledTime: String,
  estimatedDuration: {
    type: Number, // in minutes
    required: true,
  },
  
  // Location
  location: {
    type: BookingLocationSchema,
    required: true,
  },
  
  // Services/Items
  items: [BookingItemSchema],
  
  // Pricing
  totalAmount: {
    type: Number,
    required: true,
    min: 0,
  },
  currency: {
    type: String,
    default: 'KES',
  },
  
  // Status tracking
  status: {
    type: String,
    required: true,
    enum: [
      'pending',           // Just created, waiting for provider match
      'matched',           // Provider found, waiting for acceptance
      'accepted',          // Provider accepted, payment pending
      'confirmed',         // Payment completed, booking confirmed
      'in_progress',       // Service is being delivered
      'completed',         // Service completed, waiting for confirmation
      'cancelled_by_farmer',
      'cancelled_by_provider',
      'disputed',
      'resolved',
    ],
    default: 'pending',
    index: true,
  },
  
  // Payment tracking
  paymentStatus: {
    type: String,
    enum: ['pending', 'processing', 'completed', 'failed', 'refunded'],
    default: 'pending',
    index: true,
  },
  paymentMethod: String,
  paymentReference: String,
  escrowId: String,
  
  // Communication
  notes: String,
  farmerNotes: String,
  providerNotes: String,
  
  // Attachments
  attachments: [{
    type: String,
    url: String,
    filename: String,
    uploadedAt: Date,
  }],
  
  // Ratings & Reviews
  farmerRating: {
    type: Number,
    min: 1,
    max: 5,
  },
  providerRating: {
    type: Number,
    min: 1,
    max: 5,
  },
  farmerReview: String,
  providerReview: String,
  
  // Timestamps
  createdAt: {
    type: Date,
    default: Date.now,
    index: true,
  },
  updatedAt: {
    type: Date,
    default: Date.now,
  },
  matchedAt: Date,
  acceptedAt: Date,
  confirmedAt: Date,
  startedAt: Date,
  completedAt: Date,
  cancelledAt: Date,
  
  // Cancellation details
  cancellationReason: String,
  cancellationNotes: String,
  cancelledBy: String,
  
  // Metadata
  metadata: {
    type: mongoose.Schema.Types.Mixed,
    default: {},
  },
  
  // Tracking
  matchingAttempts: {
    type: Number,
    default: 0,
  },
  lastMatchingAttempt: Date,
  
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true },
});

// Indexes for performance
BookingSchema.index({ farmerId: 1, status: 1 });
BookingSchema.index({ providerId: 1, status: 1 });
BookingSchema.index({ status: 1, createdAt: -1 });
BookingSchema.index({ location: '2dsphere' });
BookingSchema.index({ category: 1, status: 1 });
BookingSchema.index({ requestedDate: 1, status: 1 });

// Virtual for total duration
BookingSchema.virtual('actualDuration').get(function() {
  if (this.startedAt && this.completedAt) {
    return Math.round((this.completedAt - this.startedAt) / (1000 * 60)); // in minutes
  }
  return null;
});

// Pre-save middleware
BookingSchema.pre('save', function(next) {
  this.updatedAt = new Date();
  next();
});

// Methods
BookingSchema.methods.canBeCancelled = function() {
  return ['pending', 'matched', 'accepted', 'confirmed'].includes(this.status);
};

BookingSchema.methods.canBeRescheduled = function() {
  return ['confirmed'].includes(this.status);
};

BookingSchema.methods.isActive = function() {
  return ['confirmed', 'in_progress'].includes(this.status);
};

BookingSchema.methods.isCompleted = function() {
  return ['completed', 'resolved'].includes(this.status);
};

BookingSchema.methods.isCancelled = function() {
  return this.status.startsWith('cancelled_');
};

// Static methods
BookingSchema.statics.findByFarmer = function(farmerId, options = {}) {
  const query = { farmerId };
  
  if (options.status) {
    query.status = options.status;
  }
  
  if (options.dateRange) {
    query.createdAt = {
      $gte: options.dateRange.start,
      $lte: options.dateRange.end,
    };
  }
  
  return this.find(query)
    .sort({ createdAt: -1 })
    .limit(options.limit || 50);
};

BookingSchema.statics.findByProvider = function(providerId, options = {}) {
  const query = { providerId };
  
  if (options.status) {
    query.status = options.status;
  }
  
  if (options.dateRange) {
    query.createdAt = {
      $gte: options.dateRange.start,
      $lte: options.dateRange.end,
    };
  }
  
  return this.find(query)
    .sort({ createdAt: -1 })
    .limit(options.limit || 50);
};

BookingSchema.statics.findPendingMatches = function(options = {}) {
  const query = { 
    status: 'pending',
    matchingAttempts: { $lt: options.maxAttempts || 5 },
  };
  
  if (options.olderThan) {
    query.createdAt = { $lt: options.olderThan };
  }
  
  return this.find(query).sort({ createdAt: 1 });
};

module.exports = mongoose.model('Booking', BookingSchema);

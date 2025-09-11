const mongoose = require('mongoose');

const AvailabilityScheduleSchema = new mongoose.Schema({
  0: { // Sunday
    isAvailable: { type: Boolean, default: false },
    startTime: String,
    endTime: String,
  },
  1: { // Monday
    isAvailable: { type: Boolean, default: true },
    startTime: { type: String, default: '08:00' },
    endTime: { type: String, default: '17:00' },
  },
  2: { // Tuesday
    isAvailable: { type: Boolean, default: true },
    startTime: { type: String, default: '08:00' },
    endTime: { type: String, default: '17:00' },
  },
  3: { // Wednesday
    isAvailable: { type: Boolean, default: true },
    startTime: { type: String, default: '08:00' },
    endTime: { type: String, default: '17:00' },
  },
  4: { // Thursday
    isAvailable: { type: Boolean, default: true },
    startTime: { type: String, default: '08:00' },
    endTime: { type: String, default: '17:00' },
  },
  5: { // Friday
    isAvailable: { type: Boolean, default: true },
    startTime: { type: String, default: '08:00' },
    endTime: { type: String, default: '17:00' },
  },
  6: { // Saturday
    isAvailable: { type: Boolean, default: true },
    startTime: { type: String, default: '08:00' },
    endTime: { type: String, default: '14:00' },
  },
});

const ServiceAreaSchema = new mongoose.Schema({
  type: {
    type: String,
    enum: ['Circle', 'Polygon'],
    required: true,
  },
  center: {
    type: {
      type: String,
      enum: ['Point'],
      required: true,
    },
    coordinates: {
      type: [Number],
      required: true,
    },
  },
  radius: {
    type: Number, // in meters
    required: function() { return this.type === 'Circle'; },
  },
  polygon: {
    type: {
      type: String,
      enum: ['Polygon'],
    },
    coordinates: {
      type: [[[Number]]], // GeoJSON Polygon format
    },
  },
  counties: [String],
  subCounties: [String],
});

const ProviderSchema = new mongoose.Schema({
  // Core identifiers
  providerId: {
    type: String,
    required: true,
    unique: true,
    index: true,
  },
  userId: {
    type: String,
    required: true,
    index: true,
  },
  
  // Basic information
  name: {
    type: String,
    required: true,
  },
  phone: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
  },
  
  // Location
  location: {
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
  },
  address: {
    type: String,
    required: true,
  },
  county: {
    type: String,
    required: true,
  },
  subCounty: String,
  ward: String,
  
  // Service areas
  serviceAreas: [ServiceAreaSchema],
  
  // Services and skills
  categories: [{
    type: String,
    enum: ['veterinary', 'crop_advisory', 'equipment_rental', 'labor', 'transport', 'other'],
    required: true,
  }],
  skills: [String],
  specializations: [String],
  
  // Availability
  availability: {
    schedule: AvailabilityScheduleSchema,
    isAvailable: {
      type: Boolean,
      default: true,
    },
    maxJobsPerDay: {
      type: Number,
      default: 5,
    },
    advanceBookingDays: {
      type: Number,
      default: 30,
    },
  },
  
  // Performance metrics
  rating: {
    type: Number,
    min: 0,
    max: 5,
    default: 0,
  },
  totalRatings: {
    type: Number,
    default: 0,
  },
  totalJobs: {
    type: Number,
    default: 0,
  },
  completedJobs: {
    type: Number,
    default: 0,
  },
  cancelledJobs: {
    type: Number,
    default: 0,
  },
  completionRate: {
    type: Number,
    min: 0,
    max: 100,
    default: 0,
  },
  averageResponseTime: {
    type: Number, // in minutes
    default: 0,
  },
  
  // Status
  isActive: {
    type: Boolean,
    default: true,
    index: true,
  },
  isAvailable: {
    type: Boolean,
    default: true,
    index: true,
  },
  isVerified: {
    type: Boolean,
    default: false,
  },
  
  // Verification documents
  documents: [{
    type: {
      type: String,
      enum: ['license', 'certificate', 'id', 'insurance', 'other'],
      required: true,
    },
    url: {
      type: String,
      required: true,
    },
    filename: String,
    uploadedAt: {
      type: Date,
      default: Date.now,
    },
    verifiedAt: Date,
    verifiedBy: String,
    status: {
      type: String,
      enum: ['pending', 'approved', 'rejected'],
      default: 'pending',
    },
  }],
  
  // Financial
  commissionRate: {
    type: Number,
    min: 0,
    max: 100,
    default: 10, // 10% commission
  },
  paymentMethods: [{
    type: String,
    enum: ['mpesa', 'bank', 'cash'],
    default: 'mpesa',
  }],
  
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
  lastActiveAt: {
    type: Date,
    default: Date.now,
  },
  
  // Metadata
  metadata: {
    type: mongoose.Schema.Types.Mixed,
    default: {},
  },
  
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true },
});

// Indexes for performance
ProviderSchema.index({ location: '2dsphere' });
ProviderSchema.index({ categories: 1, isActive: 1, isAvailable: 1 });
ProviderSchema.index({ skills: 1, isActive: 1 });
ProviderSchema.index({ county: 1, isActive: 1 });
ProviderSchema.index({ rating: -1, totalJobs: -1 });
ProviderSchema.index({ isActive: 1, isAvailable: 1, rating: -1 });

// Virtual for completion rate calculation
ProviderSchema.virtual('calculatedCompletionRate').get(function() {
  if (this.totalJobs === 0) return 0;
  return Math.round((this.completedJobs / this.totalJobs) * 100);
});

// Pre-save middleware
ProviderSchema.pre('save', function(next) {
  this.updatedAt = new Date();
  
  // Update completion rate
  if (this.totalJobs > 0) {
    this.completionRate = Math.round((this.completedJobs / this.totalJobs) * 100);
  }
  
  next();
});

// Methods
ProviderSchema.methods.updateRating = function(newRating) {
  const totalRatingPoints = (this.rating * this.totalRatings) + newRating;
  this.totalRatings += 1;
  this.rating = Math.round((totalRatingPoints / this.totalRatings) * 10) / 10; // Round to 1 decimal
};

ProviderSchema.methods.incrementJobCount = function() {
  this.totalJobs += 1;
};

ProviderSchema.methods.incrementCompletedJobs = function() {
  this.completedJobs += 1;
  this.completionRate = Math.round((this.completedJobs / this.totalJobs) * 100);
};

ProviderSchema.methods.incrementCancelledJobs = function() {
  this.cancelledJobs += 1;
};

ProviderSchema.methods.isAvailableOnDate = function(date) {
  if (!this.isActive || !this.isAvailable) {
    return false;
  }
  
  const dayOfWeek = date.getDay();
  const daySchedule = this.availability.schedule[dayOfWeek];
  
  return daySchedule && daySchedule.isAvailable;
};

ProviderSchema.methods.updateLastActive = function() {
  this.lastActiveAt = new Date();
  return this.save();
};

// Static methods
ProviderSchema.statics.findNearby = function(coordinates, maxDistance = 50000) {
  return this.find({
    location: {
      $near: {
        $geometry: {
          type: 'Point',
          coordinates: coordinates,
        },
        $maxDistance: maxDistance,
      },
    },
    isActive: true,
    isAvailable: true,
  });
};

ProviderSchema.statics.findByCategory = function(category, options = {}) {
  const query = {
    categories: category,
    isActive: true,
    isAvailable: true,
  };
  
  if (options.county) {
    query.county = options.county;
  }
  
  if (options.minRating) {
    query.rating = { $gte: options.minRating };
  }
  
  return this.find(query)
    .sort({ rating: -1, totalJobs: -1 })
    .limit(options.limit || 50);
};

ProviderSchema.statics.findTopRated = function(limit = 10) {
  return this.find({
    isActive: true,
    totalRatings: { $gte: 5 }, // At least 5 ratings
  })
  .sort({ rating: -1, totalRatings: -1 })
  .limit(limit);
};

module.exports = mongoose.model('Provider', ProviderSchema);

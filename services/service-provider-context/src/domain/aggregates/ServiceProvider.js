const { v4: uuidv4 } = require('uuid');
const AggregateRoot = require('../base/AggregateRoot');
const ServiceProviderRegisteredEvent = require('../events/ServiceProviderRegisteredEvent');
const ServiceOfferedEvent = require('../events/ServiceOfferedEvent');
const AppointmentScheduledEvent = require('../events/AppointmentScheduledEvent');
const ConsultationCompletedEvent = require('../events/ConsultationCompletedEvent');
const AvailabilityUpdatedEvent = require('../events/AvailabilityUpdatedEvent');

/**
 * Service Provider Aggregate - Core domain entity for veterinary and agricultural services
 * Encapsulates all business logic related to service provider operations
 */
class ServiceProvider extends AggregateRoot {
  constructor(id) {
    super(id);
    this.userId = null;
    this.providerType = null; // 'veterinarian', 'agronomist', 'equipment_rental', 'input_supplier'
    this.businessName = null;
    this.licenseNumber = null;
    this.licenseStatus = 'pending_verification';
    this.specializations = [];
    this.serviceAreas = []; // Counties/regions served
    this.services = new Map(); // serviceId -> ServiceInfo
    this.appointments = new Map(); // appointmentId -> AppointmentInfo
    this.consultations = new Map(); // consultationId -> ConsultationInfo
    this.availability = new Map(); // date -> AvailabilitySlots
    this.ratings = {
      average: 0,
      count: 0,
      breakdown: { 5: 0, 4: 0, 3: 0, 2: 0, 1: 0 }
    };
    this.status = 'active';
    this.verificationStatus = 'pending';
    this.createdAt = null;
    this.updatedAt = null;
  }

  /**
   * Register a new service provider
   */
  static register(userId, providerType, businessName, licenseNumber, specializations, serviceAreas, metadata = {}) {
    const providerId = uuidv4();
    const provider = new ServiceProvider(providerId);
    
    // Validate business rules
    provider.validateRegistration(userId, providerType, businessName, licenseNumber, specializations, serviceAreas);
    
    // Apply domain event
    const event = new ServiceProviderRegisteredEvent({
      providerId,
      userId,
      providerType,
      businessName,
      licenseNumber,
      specializations,
      serviceAreas,
      registeredAt: new Date().toISOString(),
    }, metadata);
    
    provider.applyEvent(event);
    return provider;
  }

  /**
   * Add a new service offering
   */
  offerService(serviceName, description, price, duration, serviceType, metadata = {}) {
    // Validate business rules
    this.validateServiceOffering(serviceName, price, duration, serviceType);
    
    const serviceId = uuidv4();
    const event = new ServiceOfferedEvent({
      providerId: this.id,
      serviceId,
      serviceName,
      description,
      price,
      duration,
      serviceType,
      status: 'active',
    }, metadata);
    
    this.applyEvent(event);
    return serviceId;
  }

  /**
   * Schedule an appointment
   */
  scheduleAppointment(farmerId, serviceId, scheduledDate, scheduledTime, location, notes, metadata = {}) {
    // Validate business rules
    this.validateAppointmentScheduling(serviceId, scheduledDate, scheduledTime);
    
    const appointmentId = uuidv4();
    const event = new AppointmentScheduledEvent({
      providerId: this.id,
      appointmentId,
      farmerId,
      serviceId,
      scheduledDate,
      scheduledTime,
      location,
      notes,
      status: 'scheduled',
    }, metadata);
    
    this.applyEvent(event);
    return appointmentId;
  }

  /**
   * Complete a consultation
   */
  completeConsultation(appointmentId, diagnosis, treatment, recommendations, followUpRequired, metadata = {}) {
    // Validate business rules
    this.validateConsultationCompletion(appointmentId);
    
    const consultationId = uuidv4();
    const event = new ConsultationCompletedEvent({
      providerId: this.id,
      consultationId,
      appointmentId,
      diagnosis,
      treatment,
      recommendations,
      followUpRequired,
      completedAt: new Date().toISOString(),
    }, metadata);
    
    this.applyEvent(event);
    return consultationId;
  }

  /**
   * Update availability schedule
   */
  updateAvailability(date, timeSlots, metadata = {}) {
    // Validate business rules
    this.validateAvailabilityUpdate(date, timeSlots);
    
    const event = new AvailabilityUpdatedEvent({
      providerId: this.id,
      date,
      timeSlots,
      updatedAt: new Date().toISOString(),
    }, metadata);
    
    this.applyEvent(event);
  }

  /**
   * Calculate provider performance metrics
   */
  calculatePerformanceMetrics() {
    const totalAppointments = this.appointments.size;
    const completedConsultations = this.consultations.size;
    const completionRate = totalAppointments > 0 ? (completedConsultations / totalAppointments) * 100 : 0;
    
    // Calculate average response time
    const responseTimes = Array.from(this.appointments.values())
      .filter(apt => apt.status === 'completed')
      .map(apt => {
        const scheduled = new Date(apt.scheduledDate);
        const completed = new Date(apt.completedAt);
        return completed - scheduled;
      });
    
    const avgResponseTime = responseTimes.length > 0 
      ? responseTimes.reduce((sum, time) => sum + time, 0) / responseTimes.length 
      : 0;

    return {
      totalAppointments,
      completedConsultations,
      completionRate,
      averageRating: this.ratings.average,
      totalRatings: this.ratings.count,
      averageResponseTime: avgResponseTime,
      activeServices: Array.from(this.services.values()).filter(s => s.status === 'active').length,
    };
  }

  /**
   * Get provider summary
   */
  getSummary() {
    return {
      id: this.id,
      userId: this.userId,
      providerType: this.providerType,
      businessName: this.businessName,
      licenseNumber: this.licenseNumber,
      licenseStatus: this.licenseStatus,
      specializations: this.specializations,
      serviceAreas: this.serviceAreas,
      status: this.status,
      verificationStatus: this.verificationStatus,
      totalServices: this.services.size,
      totalAppointments: this.appointments.size,
      totalConsultations: this.consultations.size,
      ratings: this.ratings,
      performance: this.calculatePerformanceMetrics(),
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
    };
  }

  // Event Handlers
  onServiceProviderRegistered(event) {
    this.userId = event.eventData.userId;
    this.providerType = event.eventData.providerType;
    this.businessName = event.eventData.businessName;
    this.licenseNumber = event.eventData.licenseNumber;
    this.specializations = event.eventData.specializations;
    this.serviceAreas = event.eventData.serviceAreas;
    this.status = 'active';
    this.verificationStatus = 'pending';
    this.createdAt = event.eventData.registeredAt;
    this.updatedAt = event.eventData.registeredAt;
  }

  onServiceOffered(event) {
    const serviceData = event.eventData;
    this.services.set(serviceData.serviceId, {
      id: serviceData.serviceId,
      name: serviceData.serviceName,
      description: serviceData.description,
      price: serviceData.price,
      duration: serviceData.duration,
      serviceType: serviceData.serviceType,
      status: serviceData.status,
    });
    this.updatedAt = new Date().toISOString();
  }

  onAppointmentScheduled(event) {
    const appointmentData = event.eventData;
    this.appointments.set(appointmentData.appointmentId, {
      id: appointmentData.appointmentId,
      farmerId: appointmentData.farmerId,
      serviceId: appointmentData.serviceId,
      scheduledDate: appointmentData.scheduledDate,
      scheduledTime: appointmentData.scheduledTime,
      location: appointmentData.location,
      notes: appointmentData.notes,
      status: appointmentData.status,
    });
    this.updatedAt = new Date().toISOString();
  }

  onConsultationCompleted(event) {
    const consultationData = event.eventData;
    this.consultations.set(consultationData.consultationId, {
      id: consultationData.consultationId,
      appointmentId: consultationData.appointmentId,
      diagnosis: consultationData.diagnosis,
      treatment: consultationData.treatment,
      recommendations: consultationData.recommendations,
      followUpRequired: consultationData.followUpRequired,
      completedAt: consultationData.completedAt,
    });

    // Update appointment status
    const appointment = this.appointments.get(consultationData.appointmentId);
    if (appointment) {
      appointment.status = 'completed';
      appointment.completedAt = consultationData.completedAt;
    }

    this.updatedAt = new Date().toISOString();
  }

  onAvailabilityUpdated(event) {
    const availabilityData = event.eventData;
    this.availability.set(availabilityData.date, {
      date: availabilityData.date,
      timeSlots: availabilityData.timeSlots,
      updatedAt: availabilityData.updatedAt,
    });
    this.updatedAt = new Date().toISOString();
  }

  // Business Rule Validations
  validateRegistration(userId, providerType, businessName, licenseNumber, specializations, serviceAreas) {
    if (!userId) throw new Error('User ID is required');
    if (!['veterinarian', 'agronomist', 'equipment_rental', 'input_supplier'].includes(providerType)) {
      throw new Error('Invalid provider type');
    }
    if (!businessName || businessName.trim().length < 2) {
      throw new Error('Business name must be at least 2 characters');
    }
    if (providerType === 'veterinarian' && !licenseNumber) {
      throw new Error('License number is required for veterinarians');
    }
    if (!Array.isArray(specializations) || specializations.length === 0) {
      throw new Error('At least one specialization is required');
    }
    if (!Array.isArray(serviceAreas) || serviceAreas.length === 0) {
      throw new Error('At least one service area is required');
    }
  }

  validateServiceOffering(serviceName, price, duration, serviceType) {
    if (!serviceName || serviceName.trim().length < 2) {
      throw new Error('Service name must be at least 2 characters');
    }
    if (price < 0) throw new Error('Service price cannot be negative');
    if (duration <= 0) throw new Error('Service duration must be greater than 0');
    if (!serviceType) throw new Error('Service type is required');
  }

  validateAppointmentScheduling(serviceId, scheduledDate, scheduledTime) {
    if (!this.services.has(serviceId)) {
      throw new Error('Service not found');
    }
    
    const service = this.services.get(serviceId);
    if (service.status !== 'active') {
      throw new Error('Service is not active');
    }

    const appointmentDateTime = new Date(`${scheduledDate}T${scheduledTime}`);
    if (appointmentDateTime <= new Date()) {
      throw new Error('Appointment must be scheduled in the future');
    }

    // Check availability
    const availability = this.availability.get(scheduledDate);
    if (!availability || !availability.timeSlots.includes(scheduledTime)) {
      throw new Error('Provider is not available at the requested time');
    }
  }

  validateConsultationCompletion(appointmentId) {
    if (!this.appointments.has(appointmentId)) {
      throw new Error('Appointment not found');
    }
    
    const appointment = this.appointments.get(appointmentId);
    if (appointment.status !== 'scheduled') {
      throw new Error('Appointment is not in scheduled status');
    }
  }

  validateAvailabilityUpdate(date, timeSlots) {
    if (!date) throw new Error('Date is required');
    if (!Array.isArray(timeSlots)) throw new Error('Time slots must be an array');
    
    const appointmentDate = new Date(date);
    if (appointmentDate < new Date().setHours(0, 0, 0, 0)) {
      throw new Error('Cannot set availability for past dates');
    }
  }
}

module.exports = ServiceProvider;

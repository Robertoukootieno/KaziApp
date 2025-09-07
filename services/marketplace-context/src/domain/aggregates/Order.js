const { v4: uuidv4 } = require('uuid');
const AggregateRoot = require('../base/AggregateRoot');
const OrderPlacedEvent = require('../events/OrderPlacedEvent');
const OrderConfirmedEvent = require('../events/OrderConfirmedEvent');
const OrderShippedEvent = require('../events/OrderShippedEvent');
const OrderDeliveredEvent = require('../events/OrderDeliveredEvent');
const OrderCancelledEvent = require('../events/OrderCancelledEvent');
const PaymentProcessedEvent = require('../events/PaymentProcessedEvent');

/**
 * Order Aggregate - Core domain entity for marketplace orders
 * Encapsulates all business logic related to order management
 */
class Order extends AggregateRoot {
  constructor(id) {
    super(id);
    this.buyerId = null;
    this.buyerType = null; // 'farmer', 'vendor', 'restaurant', 'individual'
    this.sellerId = null;
    this.sellerType = null;
    this.orderNumber = null;
    this.items = []; // Array of order items
    this.subtotal = 0;
    this.deliveryFee = 0;
    this.serviceFee = 0;
    this.tax = 0;
    this.discount = 0;
    this.total = 0;
    this.currency = 'KES';
    this.status = 'pending'; // 'pending', 'confirmed', 'shipped', 'delivered', 'cancelled'
    this.paymentStatus = 'pending'; // 'pending', 'paid', 'failed', 'refunded'
    this.paymentMethod = null;
    this.deliveryAddress = null;
    this.deliveryInstructions = null;
    this.estimatedDeliveryDate = null;
    this.actualDeliveryDate = null;
    this.notes = null;
    this.timeline = []; // Order status timeline
    this.createdAt = null;
    this.updatedAt = null;
  }

  /**
   * Place a new order
   */
  static place(buyerId, buyerType, sellerId, sellerType, orderData, metadata = {}) {
    const orderId = uuidv4();
    const order = new Order(orderId);
    
    // Generate order number
    const orderNumber = order.generateOrderNumber();
    
    // Validate business rules
    order.validateOrderPlacement(buyerId, buyerType, sellerId, sellerType, orderData);
    
    // Calculate totals
    const calculations = order.calculateOrderTotals(orderData.items, orderData.deliveryFee);
    
    // Apply domain event
    const event = new OrderPlacedEvent({
      orderId,
      orderNumber,
      buyerId,
      buyerType,
      sellerId,
      sellerType,
      items: orderData.items,
      subtotal: calculations.subtotal,
      deliveryFee: orderData.deliveryFee || 0,
      serviceFee: calculations.serviceFee,
      tax: calculations.tax,
      discount: orderData.discount || 0,
      total: calculations.total,
      currency: orderData.currency || 'KES',
      deliveryAddress: orderData.deliveryAddress,
      deliveryInstructions: orderData.deliveryInstructions,
      estimatedDeliveryDate: orderData.estimatedDeliveryDate,
      notes: orderData.notes,
      placedAt: new Date().toISOString(),
    }, metadata);
    
    order.applyEvent(event);
    return order;
  }

  /**
   * Confirm order (seller accepts)
   */
  confirmOrder(estimatedDeliveryDate, notes, metadata = {}) {
    // Validate business rules
    this.validateOrderConfirmation();
    
    const event = new OrderConfirmedEvent({
      orderId: this.id,
      estimatedDeliveryDate,
      notes,
      confirmedAt: new Date().toISOString(),
    }, metadata);
    
    this.applyEvent(event);
  }

  /**
   * Ship order
   */
  shipOrder(trackingNumber, carrier, shippedDate, metadata = {}) {
    // Validate business rules
    this.validateOrderShipment();
    
    const event = new OrderShippedEvent({
      orderId: this.id,
      trackingNumber,
      carrier,
      shippedDate: shippedDate || new Date().toISOString(),
    }, metadata);
    
    this.applyEvent(event);
  }

  /**
   * Mark order as delivered
   */
  deliverOrder(deliveredDate, deliveredBy, receivedBy, metadata = {}) {
    // Validate business rules
    this.validateOrderDelivery();
    
    const event = new OrderDeliveredEvent({
      orderId: this.id,
      deliveredDate: deliveredDate || new Date().toISOString(),
      deliveredBy,
      receivedBy,
    }, metadata);
    
    this.applyEvent(event);
  }

  /**
   * Cancel order
   */
  cancelOrder(reason, cancelledBy, metadata = {}) {
    // Validate business rules
    this.validateOrderCancellation();
    
    const event = new OrderCancelledEvent({
      orderId: this.id,
      reason,
      cancelledBy,
      cancelledAt: new Date().toISOString(),
    }, metadata);
    
    this.applyEvent(event);
  }

  /**
   * Process payment
   */
  processPayment(paymentMethod, transactionId, amount, metadata = {}) {
    // Validate business rules
    this.validatePaymentProcessing(amount);
    
    const event = new PaymentProcessedEvent({
      orderId: this.id,
      paymentMethod,
      transactionId,
      amount,
      processedAt: new Date().toISOString(),
    }, metadata);
    
    this.applyEvent(event);
  }

  /**
   * Calculate order totals
   */
  calculateOrderTotals(items, deliveryFee = 0) {
    const subtotal = items.reduce((sum, item) => sum + (item.price * item.quantity), 0);
    const serviceFee = subtotal * 0.025; // 2.5% service fee
    const tax = subtotal * 0.16; // 16% VAT
    const total = subtotal + deliveryFee + serviceFee + tax;
    
    return {
      subtotal,
      serviceFee,
      tax,
      total,
    };
  }

  /**
   * Generate unique order number
   */
  generateOrderNumber() {
    const timestamp = Date.now().toString();
    const random = Math.floor(Math.random() * 1000).toString().padStart(3, '0');
    return `KZ${timestamp.slice(-6)}${random}`;
  }

  /**
   * Check if order can be cancelled
   */
  canBeCancelled() {
    return ['pending', 'confirmed'].includes(this.status);
  }

  /**
   * Check if order is in progress
   */
  isInProgress() {
    return ['confirmed', 'shipped'].includes(this.status);
  }

  /**
   * Get order summary
   */
  getSummary() {
    return {
      id: this.id,
      orderNumber: this.orderNumber,
      buyerId: this.buyerId,
      buyerType: this.buyerType,
      sellerId: this.sellerId,
      sellerType: this.sellerType,
      items: this.items,
      subtotal: this.subtotal,
      deliveryFee: this.deliveryFee,
      serviceFee: this.serviceFee,
      tax: this.tax,
      discount: this.discount,
      total: this.total,
      currency: this.currency,
      status: this.status,
      paymentStatus: this.paymentStatus,
      paymentMethod: this.paymentMethod,
      deliveryAddress: this.deliveryAddress,
      deliveryInstructions: this.deliveryInstructions,
      estimatedDeliveryDate: this.estimatedDeliveryDate,
      actualDeliveryDate: this.actualDeliveryDate,
      notes: this.notes,
      timeline: this.timeline,
      canBeCancelled: this.canBeCancelled(),
      isInProgress: this.isInProgress(),
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
    };
  }

  // Event Handlers
  onOrderPlaced(event) {
    const data = event.eventData;
    this.buyerId = data.buyerId;
    this.buyerType = data.buyerType;
    this.sellerId = data.sellerId;
    this.sellerType = data.sellerType;
    this.orderNumber = data.orderNumber;
    this.items = data.items;
    this.subtotal = data.subtotal;
    this.deliveryFee = data.deliveryFee;
    this.serviceFee = data.serviceFee;
    this.tax = data.tax;
    this.discount = data.discount;
    this.total = data.total;
    this.currency = data.currency;
    this.status = 'pending';
    this.paymentStatus = 'pending';
    this.deliveryAddress = data.deliveryAddress;
    this.deliveryInstructions = data.deliveryInstructions;
    this.estimatedDeliveryDate = data.estimatedDeliveryDate;
    this.notes = data.notes;
    this.timeline = [{
      status: 'pending',
      timestamp: data.placedAt,
      description: 'Order placed',
    }];
    this.createdAt = data.placedAt;
    this.updatedAt = data.placedAt;
  }

  onOrderConfirmed(event) {
    const data = event.eventData;
    this.status = 'confirmed';
    this.estimatedDeliveryDate = data.estimatedDeliveryDate;
    this.timeline.push({
      status: 'confirmed',
      timestamp: data.confirmedAt,
      description: 'Order confirmed by seller',
      notes: data.notes,
    });
    this.updatedAt = data.confirmedAt;
  }

  onOrderShipped(event) {
    const data = event.eventData;
    this.status = 'shipped';
    this.timeline.push({
      status: 'shipped',
      timestamp: data.shippedDate,
      description: 'Order shipped',
      trackingNumber: data.trackingNumber,
      carrier: data.carrier,
    });
    this.updatedAt = data.shippedDate;
  }

  onOrderDelivered(event) {
    const data = event.eventData;
    this.status = 'delivered';
    this.actualDeliveryDate = data.deliveredDate;
    this.timeline.push({
      status: 'delivered',
      timestamp: data.deliveredDate,
      description: 'Order delivered',
      deliveredBy: data.deliveredBy,
      receivedBy: data.receivedBy,
    });
    this.updatedAt = data.deliveredDate;
  }

  onOrderCancelled(event) {
    const data = event.eventData;
    this.status = 'cancelled';
    this.timeline.push({
      status: 'cancelled',
      timestamp: data.cancelledAt,
      description: 'Order cancelled',
      reason: data.reason,
      cancelledBy: data.cancelledBy,
    });
    this.updatedAt = data.cancelledAt;
  }

  onPaymentProcessed(event) {
    const data = event.eventData;
    this.paymentStatus = 'paid';
    this.paymentMethod = data.paymentMethod;
    this.timeline.push({
      status: 'payment_processed',
      timestamp: data.processedAt,
      description: 'Payment processed',
      transactionId: data.transactionId,
      amount: data.amount,
    });
    this.updatedAt = data.processedAt;
  }

  // Business Rule Validations
  validateOrderPlacement(buyerId, buyerType, sellerId, sellerType, orderData) {
    if (!buyerId) throw new Error('Buyer ID is required');
    if (!sellerId) throw new Error('Seller ID is required');
    if (buyerId === sellerId) throw new Error('Buyer and seller cannot be the same');
    if (!['farmer', 'vendor', 'restaurant', 'individual'].includes(buyerType)) {
      throw new Error('Invalid buyer type');
    }
    if (!['farmer', 'vendor', 'cooperative'].includes(sellerType)) {
      throw new Error('Invalid seller type');
    }
    if (!orderData.items || orderData.items.length === 0) {
      throw new Error('Order must contain at least one item');
    }
    if (!orderData.deliveryAddress) throw new Error('Delivery address is required');
  }

  validateOrderConfirmation() {
    if (this.status !== 'pending') {
      throw new Error('Only pending orders can be confirmed');
    }
  }

  validateOrderShipment() {
    if (this.status !== 'confirmed') {
      throw new Error('Only confirmed orders can be shipped');
    }
  }

  validateOrderDelivery() {
    if (this.status !== 'shipped') {
      throw new Error('Only shipped orders can be delivered');
    }
  }

  validateOrderCancellation() {
    if (!this.canBeCancelled()) {
      throw new Error('Order cannot be cancelled in current status');
    }
  }

  validatePaymentProcessing(amount) {
    if (this.paymentStatus === 'paid') {
      throw new Error('Order is already paid');
    }
    if (amount !== this.total) {
      throw new Error('Payment amount must match order total');
    }
  }
}

module.exports = Order;

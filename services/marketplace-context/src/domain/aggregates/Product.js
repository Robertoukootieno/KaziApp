const { v4: uuidv4 } = require('uuid');
const AggregateRoot = require('../base/AggregateRoot');
const ProductListedEvent = require('../events/ProductListedEvent');
const ProductUpdatedEvent = require('../events/ProductUpdatedEvent');
const ProductPriceChangedEvent = require('../events/ProductPriceChangedEvent');
const ProductStockUpdatedEvent = require('../events/ProductStockUpdatedEvent');
const ProductDeactivatedEvent = require('../events/ProductDeactivatedEvent');

/**
 * Product Aggregate - Core domain entity for marketplace products
 * Encapsulates all business logic related to product management
 */
class Product extends AggregateRoot {
  constructor(id) {
    super(id);
    this.sellerId = null;
    this.sellerType = null; // 'farmer', 'vendor', 'cooperative'
    this.name = null;
    this.description = null;
    this.category = null;
    this.subcategory = null;
    this.productType = null; // 'produce', 'livestock', 'equipment', 'inputs', 'processed'
    this.price = 0;
    this.currency = 'KES';
    this.unit = null; // 'kg', 'piece', 'liter', 'bag', etc.
    this.minimumOrder = 1;
    this.stock = {
      quantity: 0,
      reserved: 0,
      available: 0,
    };
    this.quality = {
      grade: null, // 'A', 'B', 'C'
      certifications: [],
      organic: false,
    };
    this.location = {
      county: null,
      subCounty: null,
      coordinates: null,
    };
    this.images = [];
    this.specifications = {};
    this.harvestDate = null;
    this.expiryDate = null;
    this.status = 'active'; // 'active', 'inactive', 'out_of_stock', 'expired'
    this.visibility = 'public'; // 'public', 'private', 'restricted'
    this.tags = [];
    this.createdAt = null;
    this.updatedAt = null;
  }

  /**
   * List a new product
   */
  static list(sellerId, sellerType, productData, metadata = {}) {
    const productId = uuidv4();
    const product = new Product(productId);
    
    // Validate business rules
    product.validateProductListing(sellerId, sellerType, productData);
    
    // Apply domain event
    const event = new ProductListedEvent({
      productId,
      sellerId,
      sellerType,
      ...productData,
      listedAt: new Date().toISOString(),
    }, metadata);
    
    product.applyEvent(event);
    return product;
  }

  /**
   * Update product information
   */
  updateProduct(updates, metadata = {}) {
    // Validate business rules
    this.validateProductUpdate(updates);
    
    const event = new ProductUpdatedEvent({
      productId: this.id,
      updates,
      updatedAt: new Date().toISOString(),
    }, metadata);
    
    this.applyEvent(event);
  }

  /**
   * Change product price
   */
  changePrice(newPrice, reason, metadata = {}) {
    // Validate business rules
    this.validatePriceChange(newPrice);
    
    const event = new ProductPriceChangedEvent({
      productId: this.id,
      oldPrice: this.price,
      newPrice,
      reason,
      changedAt: new Date().toISOString(),
    }, metadata);
    
    this.applyEvent(event);
  }

  /**
   * Update stock quantity
   */
  updateStock(quantity, operation, reason, metadata = {}) {
    // Validate business rules
    this.validateStockUpdate(quantity, operation);
    
    const event = new ProductStockUpdatedEvent({
      productId: this.id,
      oldQuantity: this.stock.quantity,
      newQuantity: operation === 'add' ? this.stock.quantity + quantity : quantity,
      operation, // 'add', 'subtract', 'set'
      reason,
      updatedAt: new Date().toISOString(),
    }, metadata);
    
    this.applyEvent(event);
  }

  /**
   * Reserve stock for an order
   */
  reserveStock(quantity, orderId, metadata = {}) {
    if (this.stock.available < quantity) {
      throw new Error('Insufficient stock available for reservation');
    }
    
    this.stock.reserved += quantity;
    this.stock.available -= quantity;
    this.updatedAt = new Date().toISOString();
    
    // This could be a separate event if needed for audit
    return true;
  }

  /**
   * Release reserved stock
   */
  releaseStock(quantity, orderId, metadata = {}) {
    if (this.stock.reserved < quantity) {
      throw new Error('Cannot release more stock than reserved');
    }
    
    this.stock.reserved -= quantity;
    this.stock.available += quantity;
    this.updatedAt = new Date().toISOString();
    
    return true;
  }

  /**
   * Deactivate product
   */
  deactivate(reason, metadata = {}) {
    if (this.status === 'inactive') {
      throw new Error('Product is already inactive');
    }
    
    const event = new ProductDeactivatedEvent({
      productId: this.id,
      reason,
      deactivatedAt: new Date().toISOString(),
    }, metadata);
    
    this.applyEvent(event);
  }

  /**
   * Check if product is available for purchase
   */
  isAvailable(requestedQuantity = 1) {
    return this.status === 'active' && 
           this.stock.available >= requestedQuantity &&
           (!this.expiryDate || new Date(this.expiryDate) > new Date());
  }

  /**
   * Calculate product freshness score (for produce)
   */
  calculateFreshnessScore() {
    if (!this.harvestDate || this.productType !== 'produce') {
      return null;
    }
    
    const daysSinceHarvest = Math.floor(
      (new Date() - new Date(this.harvestDate)) / (1000 * 60 * 60 * 24)
    );
    
    // Simple freshness scoring (0-100)
    if (daysSinceHarvest <= 1) return 100;
    if (daysSinceHarvest <= 3) return 90;
    if (daysSinceHarvest <= 7) return 75;
    if (daysSinceHarvest <= 14) return 50;
    return 25;
  }

  /**
   * Get product summary
   */
  getSummary() {
    return {
      id: this.id,
      sellerId: this.sellerId,
      sellerType: this.sellerType,
      name: this.name,
      description: this.description,
      category: this.category,
      subcategory: this.subcategory,
      productType: this.productType,
      price: this.price,
      currency: this.currency,
      unit: this.unit,
      minimumOrder: this.minimumOrder,
      stock: this.stock,
      quality: this.quality,
      location: this.location,
      images: this.images,
      specifications: this.specifications,
      harvestDate: this.harvestDate,
      expiryDate: this.expiryDate,
      status: this.status,
      visibility: this.visibility,
      tags: this.tags,
      freshnessScore: this.calculateFreshnessScore(),
      isAvailable: this.isAvailable(),
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
    };
  }

  // Event Handlers
  onProductListed(event) {
    const data = event.eventData;
    this.sellerId = data.sellerId;
    this.sellerType = data.sellerType;
    this.name = data.name;
    this.description = data.description;
    this.category = data.category;
    this.subcategory = data.subcategory;
    this.productType = data.productType;
    this.price = data.price;
    this.currency = data.currency || 'KES';
    this.unit = data.unit;
    this.minimumOrder = data.minimumOrder || 1;
    this.stock = {
      quantity: data.quantity || 0,
      reserved: 0,
      available: data.quantity || 0,
    };
    this.quality = data.quality || {};
    this.location = data.location || {};
    this.images = data.images || [];
    this.specifications = data.specifications || {};
    this.harvestDate = data.harvestDate;
    this.expiryDate = data.expiryDate;
    this.status = 'active';
    this.visibility = data.visibility || 'public';
    this.tags = data.tags || [];
    this.createdAt = data.listedAt;
    this.updatedAt = data.listedAt;
  }

  onProductUpdated(event) {
    const updates = event.eventData.updates;
    Object.assign(this, updates);
    this.updatedAt = event.eventData.updatedAt;
  }

  onProductPriceChanged(event) {
    this.price = event.eventData.newPrice;
    this.updatedAt = event.eventData.changedAt;
  }

  onProductStockUpdated(event) {
    const data = event.eventData;
    this.stock.quantity = data.newQuantity;
    this.stock.available = data.newQuantity - this.stock.reserved;
    
    // Update status based on stock
    if (this.stock.quantity === 0) {
      this.status = 'out_of_stock';
    } else if (this.status === 'out_of_stock') {
      this.status = 'active';
    }
    
    this.updatedAt = data.updatedAt;
  }

  onProductDeactivated(event) {
    this.status = 'inactive';
    this.updatedAt = event.eventData.deactivatedAt;
  }

  // Business Rule Validations
  validateProductListing(sellerId, sellerType, productData) {
    if (!sellerId) throw new Error('Seller ID is required');
    if (!['farmer', 'vendor', 'cooperative'].includes(sellerType)) {
      throw new Error('Invalid seller type');
    }
    if (!productData.name || productData.name.trim().length < 2) {
      throw new Error('Product name must be at least 2 characters');
    }
    if (!productData.category) throw new Error('Product category is required');
    if (!productData.productType) throw new Error('Product type is required');
    if (productData.price < 0) throw new Error('Product price cannot be negative');
    if (!productData.unit) throw new Error('Product unit is required');
    if (productData.quantity < 0) throw new Error('Stock quantity cannot be negative');
  }

  validateProductUpdate(updates) {
    if (updates.price !== undefined && updates.price < 0) {
      throw new Error('Product price cannot be negative');
    }
    if (updates.quantity !== undefined && updates.quantity < 0) {
      throw new Error('Stock quantity cannot be negative');
    }
  }

  validatePriceChange(newPrice) {
    if (newPrice < 0) throw new Error('Product price cannot be negative');
    if (newPrice === this.price) throw new Error('New price must be different from current price');
  }

  validateStockUpdate(quantity, operation) {
    if (quantity < 0) throw new Error('Quantity cannot be negative');
    if (!['add', 'subtract', 'set'].includes(operation)) {
      throw new Error('Invalid stock operation');
    }
    if (operation === 'subtract' && quantity > this.stock.quantity) {
      throw new Error('Cannot subtract more stock than available');
    }
  }
}

module.exports = Product;

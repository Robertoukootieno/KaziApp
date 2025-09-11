import 'package:flutter/material.dart';
import '../models/marketplace_models.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  State<ProductManagementScreen> createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  ProductCategory? _selectedCategory;
  
  // Mock data
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Maize Seeds - Hybrid 614',
      description: 'High-yield hybrid maize seeds suitable for all seasons. Drought resistant variety with excellent germination rate.',
      category: ProductCategory.seeds,
      status: ProductStatus.active,
      price: 450.0,
      discountPrice: 400.0,
      unit: 'kg',
      stockQuantity: 150,
      minStockLevel: 20,
      brand: 'Kenya Seed',
      manufacturer: 'Kenya Seed Company',
      imageUrls: ['assets/images/maize_seeds.jpg'],
      tags: ['hybrid', 'high-yield', 'drought-resistant', 'maize'],
      specifications: {
        'variety': 'Hybrid 614',
        'maturity': '120 days',
        'yield': '25-30 bags/acre',
        'planting_season': 'Long & Short rains'
      },
      weight: 1.0,
      dimensions: '30x20x5 cm',
      isFeatured: true,
      rating: 4.5,
      reviewCount: 23,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Product(
      id: '2',
      name: 'NPK Fertilizer 17:17:17',
      description: 'Balanced NPK fertilizer for optimal crop growth and development. Suitable for all crop types.',
      category: ProductCategory.fertilizers,
      status: ProductStatus.active,
      price: 3200.0,
      unit: '50kg bag',
      stockQuantity: 45,
      minStockLevel: 10,
      brand: 'Yara',
      manufacturer: 'Yara International',
      imageUrls: ['assets/images/npk_fertilizer.jpg'],
      tags: ['balanced', 'npk', 'crop-nutrition', 'fertilizer'],
      specifications: {
        'N': '17%',
        'P': '17%',
        'K': '17%',
        'application_rate': '50-100kg/acre'
      },
      weight: 50.0,
      dimensions: '80x50x15 cm',
      isFeatured: false,
      rating: 4.2,
      reviewCount: 18,
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Product(
      id: '3',
      name: 'Dairy Meal 16% Protein',
      description: 'High-quality dairy meal for improved milk production in dairy cattle.',
      category: ProductCategory.animalFeed,
      status: ProductStatus.active,
      price: 2800.0,
      unit: '70kg bag',
      stockQuantity: 8,
      minStockLevel: 15,
      brand: 'Unga Feeds',
      manufacturer: 'Unga Group',
      imageUrls: ['assets/images/dairy_meal.jpg'],
      tags: ['dairy', 'cattle-feed', 'protein', 'milk-production'],
      specifications: {
        'protein': '16%',
        'fiber': '12%',
        'fat': '3%',
        'feeding_rate': '3-5kg/cow/day'
      },
      weight: 70.0,
      dimensions: '90x60x20 cm',
      isFeatured: true,
      rating: 4.7,
      reviewCount: 31,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Product(
      id: '4',
      name: 'Tomato Seeds - Anna F1',
      description: 'Determinate tomato variety with excellent disease resistance and high yield potential.',
      category: ProductCategory.seeds,
      status: ProductStatus.outOfStock,
      price: 1200.0,
      unit: '10g packet',
      stockQuantity: 0,
      minStockLevel: 5,
      brand: 'East African Seeds',
      manufacturer: 'East African Seeds',
      imageUrls: ['assets/images/tomato_seeds.jpg'],
      tags: ['tomato', 'f1-hybrid', 'disease-resistant', 'determinate'],
      specifications: {
        'variety': 'Anna F1',
        'maturity': '75-80 days',
        'fruit_weight': '80-100g',
        'yield': '40-50 tons/ha'
      },
      weight: 0.01,
      dimensions: '10x8x1 cm',
      isFeatured: false,
      rating: 4.3,
      reviewCount: 12,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Product Management'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All Products'),
            Tab(text: 'Active'),
            Tab(text: 'Low Stock'),
            Tab(text: 'Out of Stock'),
            Tab(text: 'Categories'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('All Categories'),
                        selected: _selectedCategory == null,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = null;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      ...ProductCategory.values.map((category) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category.displayName),
                          selected: _selectedCategory == category,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = selected ? category : null;
                            });
                          },
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProductList(_getFilteredProducts()),
                _buildProductList(_getProductsByStatus(ProductStatus.active)),
                _buildProductList(_getLowStockProducts()),
                _buildProductList(_getProductsByStatus(ProductStatus.outOfStock)),
                _buildCategoriesView(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProductDialog,
        backgroundColor: const Color(0xFF1976D2),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  List<Product> _getFilteredProducts() {
    List<Product> filtered = _products;
    
    // Filter by search query
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((product) =>
          product.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          product.description.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          product.tags.any((tag) => tag.toLowerCase().contains(_searchController.text.toLowerCase()))).toList();
    }
    
    // Filter by category
    if (_selectedCategory != null) {
      filtered = filtered.where((product) => product.category == _selectedCategory).toList();
    }
    
    return filtered;
  }

  List<Product> _getProductsByStatus(ProductStatus status) {
    return _getFilteredProducts().where((product) => product.status == status).toList();
  }

  List<Product> _getLowStockProducts() {
    return _getFilteredProducts().where((product) => product.isLowStock && !product.isOutOfStock).toList();
  }

  Widget _buildProductList(List<Product> products) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Products will appear here',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showProductDetails(product),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image Placeholder
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: product.category.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      product.category.icon,
                      color: product.category.color,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: product.status.color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                product.status.displayName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: product.status.color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${product.brand} • ${product.category.displayName}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Price and Stock Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (product.isOnSale) ...[
                            Text(
                              'KSh ${product.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            'KSh ${product.effectivePrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1976D2),
                            ),
                          ),
                          Text(
                            ' /${product.unit}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      if (product.isOnSale)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Stock: ${product.stockQuantity} ${product.unit}',
                        style: TextStyle(
                          fontSize: 14,
                          color: product.isLowStock ? Colors.red : Colors.grey.shade600,
                          fontWeight: product.isLowStock ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      if (product.isLowStock)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'LOW STOCK',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              
              // Rating and Reviews
              const SizedBox(height: 8),
              Row(
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < product.rating.floor() ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 16,
                      );
                    }),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${product.rating} (${product.reviewCount} reviews)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const Spacer(),
                  if (product.isFeatured)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'FEATURED',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesView() {
    final categories = ProductCategory.values;
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final categoryProducts = _products.where((p) => p.category == category).toList();
        
        if (categoryProducts.isEmpty) return const SizedBox.shrink();
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: Icon(category.icon, color: category.color),
            title: Text(
              category.displayName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${categoryProducts.length} products'),
            children: categoryProducts.map((product) => ListTile(
              title: Text(product.name),
              subtitle: Text('${product.brand} • KSh ${product.effectivePrice.toStringAsFixed(0)}/${product.unit}'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: product.status.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  product.status.displayName,
                  style: TextStyle(
                    fontSize: 12,
                    color: product.status.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              onTap: () => _showProductDetails(product),
            )).toList(),
          ),
        );
      },
    );
  }

  void _showProductDetails(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Brand: ${product.brand}'),
              Text('Category: ${product.category.displayName}'),
              Text('Status: ${product.status.displayName}'),
              Text('Price: KSh ${product.effectivePrice.toStringAsFixed(0)}/${product.unit}'),
              Text('Stock: ${product.stockQuantity} ${product.unit}'),
              Text('Rating: ${product.rating} (${product.reviewCount} reviews)'),
              const SizedBox(height: 8),
              const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(product.description),
              const SizedBox(height: 8),
              const Text('Specifications:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...product.specifications.entries.map((spec) => 
                Text('• ${spec.key}: ${spec.value}')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showEditProductDialog(product);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Product'),
        content: const Text('Add new product feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showEditProductDialog(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${product.name}'),
        content: const Text('Edit product feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

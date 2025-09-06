import 'package:flutter/material.dart';

class TreatmentPurchaseScreen extends StatefulWidget {
  const TreatmentPurchaseScreen({super.key});

  @override
  State<TreatmentPurchaseScreen> createState() => _TreatmentPurchaseScreenState();
}

class _TreatmentPurchaseScreenState extends State<TreatmentPurchaseScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedLocation = 'All';
  
  final List<String> _categories = [
    'All', 'Antibiotics', 'Vaccines', 'Dewormers', 'Vitamins', 'Antiseptics', 'Feed Supplements'
  ];
  
  final List<String> _locations = [
    'All', 'Nairobi', 'Nakuru', 'Eldoret', 'Mombasa', 'Kisumu', 'Thika'
  ];

  final List<TreatmentProduct> _products = [
    TreatmentProduct(
      id: '1',
      name: 'Oxytetracycline Injectable',
      category: 'Antibiotics',
      price: 850,
      description: 'Broad-spectrum antibiotic for cattle, goats, and sheep',
      supplier: 'VetCare Supplies',
      location: 'Nakuru',
      distance: 5.2,
      rating: 4.8,
      inStock: true,
      image: 'assets/images/oxytetracycline.jpg',
      dosage: '1ml per 10kg body weight',
      withdrawalPeriod: '28 days',
    ),
    TreatmentProduct(
      id: '2',
      name: 'Newcastle Disease Vaccine',
      category: 'Vaccines',
      price: 320,
      description: 'Live vaccine for protection against Newcastle disease in poultry',
      supplier: 'Poultry Health Ltd',
      location: 'Eldoret',
      distance: 12.8,
      rating: 4.9,
      inStock: true,
      image: 'assets/images/newcastle_vaccine.jpg',
      dosage: '0.5ml per bird',
      withdrawalPeriod: 'None',
    ),
    TreatmentProduct(
      id: '3',
      name: 'Albendazole Dewormer',
      category: 'Dewormers',
      price: 420,
      description: 'Effective dewormer for internal parasites in livestock',
      supplier: 'Farm Health Solutions',
      location: 'Nairobi',
      distance: 25.5,
      rating: 4.6,
      inStock: false,
      image: 'assets/images/albendazole.jpg',
      dosage: '7.5mg per kg body weight',
      withdrawalPeriod: '14 days',
    ),
    TreatmentProduct(
      id: '4',
      name: 'Vitamin B Complex',
      category: 'Vitamins',
      price: 280,
      description: 'Essential vitamins for improved animal health and productivity',
      supplier: 'Livestock Nutrition Co.',
      location: 'Nakuru',
      distance: 3.1,
      rating: 4.7,
      inStock: true,
      image: 'assets/images/vitamin_b.jpg',
      dosage: '2ml per 50kg body weight',
      withdrawalPeriod: 'None',
    ),
    TreatmentProduct(
      id: '5',
      name: 'Iodine Antiseptic',
      category: 'Antiseptics',
      price: 150,
      description: 'Antiseptic solution for wound cleaning and disinfection',
      supplier: 'Medical Supplies Kenya',
      location: 'Thika',
      distance: 18.3,
      rating: 4.5,
      inStock: true,
      image: 'assets/images/iodine.jpg',
      dosage: 'Apply topically as needed',
      withdrawalPeriod: 'None',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<TreatmentProduct> get _filteredProducts {
    return _products.where((product) {
      final matchesSearch = _searchController.text.isEmpty ||
          product.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          product.category.toLowerCase().contains(_searchController.text.toLowerCase());
      
      final matchesCategory = _selectedCategory == 'All' || product.category == _selectedCategory;
      final matchesLocation = _selectedLocation == 'All' || product.location == _selectedLocation;
      
      return matchesSearch && matchesCategory && matchesLocation;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Treatment'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Products', icon: Icon(Icons.medical_services)),
            Tab(text: 'Cart', icon: Icon(Icons.shopping_cart)),
            Tab(text: 'Orders', icon: Icon(Icons.receipt)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProductsTab(),
          _buildCartTab(),
          _buildOrdersTab(),
        ],
      ),
    );
  }

  Widget _buildProductsTab() {
    return Column(
      children: [
        // Search and Filters
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search treatments...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2E7D32)),
                  ),
                ),
                onChanged: (value) => setState(() {}),
              ),
              
              const SizedBox(height: 12),
              
              // Filters
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: _categories.map((category) {
                        return DropdownMenuItem(value: category, child: Text(category));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedLocation,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: _locations.map((location) {
                        return DropdownMenuItem(value: location, child: Text(location));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedLocation = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Products List
        Expanded(
          child: _filteredProducts.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No products found',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text('Try adjusting your search criteria'),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = _filteredProducts[index];
                    return _buildProductCard(product);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildProductCard(TreatmentProduct product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.medical_services, size: 30, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        product.category,
                        style: const TextStyle(
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          Text('${product.rating}'),
                          const SizedBox(width: 16),
                          Icon(
                            product.inStock ? Icons.check_circle : Icons.cancel,
                            size: 16,
                            color: product.inStock ? Colors.green : Colors.red,
                          ),
                          Text(
                            product.inStock ? 'In Stock' : 'Out of Stock',
                            style: TextStyle(
                              color: product.inStock ? Colors.green : Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'KSh ${product.price}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    Text(
                      '${product.distance}km away',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Text(
              product.description,
              style: const TextStyle(fontSize: 14),
            ),
            
            const SizedBox(height: 8),
            
            Row(
              children: [
                const Icon(Icons.store, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  product.supplier,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  product.location,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dosage: ${product.dosage}', style: const TextStyle(fontSize: 12)),
                  Text('Withdrawal: ${product.withdrawalPeriod}', style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showDeliveryOptions(product),
                    icon: const Icon(Icons.local_shipping),
                    label: const Text('Delivery'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2E7D32),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: product.inStock ? () => _addToCart(product) : null,
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Add to Cart'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text('Add products to your cart to see them here'),
        ],
      ),
    );
  }

  Widget _buildOrdersTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No orders yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text('Your order history will appear here'),
        ],
      ),
    );
  }

  void _showDeliveryOptions(TreatmentProduct product) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Delivery Options for ${product.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            if (product.distance <= 10) ...[
              ListTile(
                leading: const Icon(Icons.directions_walk, color: Color(0xFF2E7D32)),
                title: const Text('Self Pickup'),
                subtitle: Text('Free - ${product.distance}km away'),
                trailing: const Text('Free'),
                onTap: () {
                  Navigator.pop(context);
                  _showPickupDetails(product);
                },
              ),
              const Divider(),
            ],
            
            ListTile(
              leading: const Icon(Icons.local_shipping, color: Color(0xFF2E7D32)),
              title: const Text('Home Delivery'),
              subtitle: Text('Delivered within 2-4 hours to ${product.location}'),
              trailing: const Text('KSh 200'),
              onTap: () {
                Navigator.pop(context);
                _showDeliveryDetails(product);
              },
            ),
            
            const Divider(),
            
            ListTile(
              leading: const Icon(Icons.motorcycle, color: Color(0xFF2E7D32)),
              title: const Text('Express Delivery'),
              subtitle: const Text('Delivered within 1 hour'),
              trailing: const Text('KSh 500'),
              onTap: () {
                Navigator.pop(context);
                _showExpressDelivery(product);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPickupDetails(TreatmentProduct product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Self Pickup'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pickup Location: ${product.supplier}'),
            Text('Address: ${product.location}'),
            Text('Distance: ${product.distance}km'),
            const SizedBox(height: 8),
            const Text('Store Hours: 8:00 AM - 6:00 PM'),
            const Text('Phone: +254 712 345 678'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _addToCart(product);
            },
            child: const Text('Confirm Pickup'),
          ),
        ],
      ),
    );
  }

  void _showDeliveryDetails(TreatmentProduct product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Home Delivery'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Delivery Fee: KSh 200'),
            Text('Estimated Time: 2-4 hours'),
            SizedBox(height: 8),
            Text('Please ensure someone is available to receive the delivery.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _addToCart(product);
            },
            child: const Text('Confirm Delivery'),
          ),
        ],
      ),
    );
  }

  void _showExpressDelivery(TreatmentProduct product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Express Delivery'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Express Fee: KSh 500'),
            Text('Estimated Time: Within 1 hour'),
            SizedBox(height: 8),
            Text('Perfect for urgent treatments!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _addToCart(product);
            },
            child: const Text('Confirm Express'),
          ),
        ],
      ),
    );
  }

  void _addToCart(TreatmentProduct product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart!'),
        backgroundColor: const Color(0xFF2E7D32),
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () {
            _tabController.animateTo(1);
          },
        ),
      ),
    );
  }
}

class TreatmentProduct {
  final String id;
  final String name;
  final String category;
  final int price;
  final String description;
  final String supplier;
  final String location;
  final double distance;
  final double rating;
  final bool inStock;
  final String image;
  final String dosage;
  final String withdrawalPeriod;

  TreatmentProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.supplier,
    required this.location,
    required this.distance,
    required this.rating,
    required this.inStock,
    required this.image,
    required this.dosage,
    required this.withdrawalPeriod,
  });
}

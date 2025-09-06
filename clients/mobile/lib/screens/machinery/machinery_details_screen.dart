import 'package:flutter/material.dart';
import 'machinery_services_screen.dart';
import 'machinery_booking_screen.dart';

class MachineryDetailsScreen extends StatefulWidget {
  final MachineryItem machinery;

  const MachineryDetailsScreen({super.key, required this.machinery});

  @override
  State<MachineryDetailsScreen> createState() => _MachineryDetailsScreenState();
}

class _MachineryDetailsScreenState extends State<MachineryDetailsScreen> {
  bool _isFavorite = false;
  final int _selectedImageIndex = 0;

  final List<String> _sampleImages = [
    'assets/images/machinery_1.jpg',
    'assets/images/machinery_2.jpg',
    'assets/images/machinery_3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.agriculture, size: 120, color: Colors.grey),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.machinery.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: widget.machinery.availability ? Colors.green : Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.machinery.availability ? 'Available' : 'Booked',
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            Text(
                              '${widget.machinery.rating} (4.2k reviews)',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_isFavorite ? 'Added to favorites' : 'Removed from favorites'),
                    ),
                  );
                },
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  _showShareOptions(context);
                },
                icon: const Icon(Icons.share),
              ),
            ],
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Info
                  _buildQuickInfo(),
                  
                  const SizedBox(height: 24),
                  
                  // Pricing
                  _buildPricingSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Description
                  _buildDescriptionSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Specifications
                  _buildSpecificationsSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Available Services
                  _buildServicesSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Location & Contact
                  _buildLocationSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Reviews
                  _buildReviewsSection(),
                  
                  const SizedBox(height: 100), // Space for floating button
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: widget.machinery.availability
          ? FloatingActionButton.extended(
              heroTag: "machinery_details_fab",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MachineryBookingScreen(machinery: widget.machinery),
                  ),
                );
              },
              backgroundColor: const Color(0xFF2E7D32),
              icon: const Icon(Icons.book_online),
              label: const Text('Book Now'),
            )
          : null,
    );
  }

  Widget _buildQuickInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const Icon(Icons.category, color: Color(0xFF2E7D32)),
                const SizedBox(height: 4),
                Text(
                  widget.machinery.category,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('Category', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Icon(Icons.location_on, color: Color(0xFF2E7D32)),
                const SizedBox(height: 4),
                Text(
                  widget.machinery.location,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('Location', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Icon(Icons.build, color: Color(0xFF2E7D32)),
                const SizedBox(height: 4),
                Text(
                  '${widget.machinery.specifications.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('Features', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Icon(Icons.handyman, color: Color(0xFF2E7D32)),
                const SizedBox(height: 4),
                Text(
                  '${widget.machinery.availableServices.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('Services', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pricing',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              if (widget.machinery.hourlyRate > 0) ...[
                Expanded(
                  child: _buildPriceCard(
                    'Hourly',
                    'KSh ${widget.machinery.hourlyRate}',
                    '/hour',
                    Icons.access_time,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: _buildPriceCard(
                  'Daily',
                  'KSh ${widget.machinery.dailyRate}',
                  '/day',
                  Icons.today,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          _buildPriceCard(
            'Monthly Lease',
            'KSh ${widget.machinery.monthlyRate}',
            '/month',
            Icons.calendar_month,
            isFullWidth: true,
          ),
          
          const SizedBox(height: 12),
          
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.info, color: Color(0xFF2E7D32), size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Prices include basic maintenance. Additional services available.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF2E7D32)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCard(String title, String price, String period, IconData icon, {bool isFullWidth = false}) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF2E7D32)),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Text(
            price,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          Text(
            period,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            widget.machinery.description,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecificationsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Specifications',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...widget.machinery.specifications.map((spec) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 16),
                const SizedBox(width: 8),
                Text(spec),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Services',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.machinery.availableServices.map((service) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.3)),
              ),
              child: Text(
                service,
                style: const TextStyle(
                  color: Color(0xFF2E7D32),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Location & Contact',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          
          ListTile(
            leading: const Icon(Icons.location_on, color: Color(0xFF2E7D32)),
            title: Text(widget.machinery.location),
            subtitle: const Text('Machinery location'),
            contentPadding: EdgeInsets.zero,
          ),
          
          ListTile(
            leading: const Icon(Icons.phone, color: Color(0xFF2E7D32)),
            title: const Text('+254 700 MACHINERY'),
            subtitle: const Text('Contact for booking'),
            contentPadding: EdgeInsets.zero,
            onTap: () {
              // TODO: Implement call functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Calling +254 700 MACHINERY...')),
              );
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.directions, color: Color(0xFF2E7D32)),
            title: const Text('Get Directions'),
            subtitle: const Text('Navigate to machinery location'),
            contentPadding: EdgeInsets.zero,
            onTap: () {
              // TODO: Implement directions
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening directions...')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Reviews',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  Text('${widget.machinery.rating}'),
                  const Text(' (4.2k reviews)', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Sample reviews
          _buildReviewItem('John M.', 5, 'Excellent tractor! Very reliable and the operator was professional.'),
          _buildReviewItem('Mary K.', 4, 'Good service, delivered on time. Would recommend.'),
          _buildReviewItem('Peter N.', 5, 'Perfect for my farm work. Great value for money.'),
          
          const SizedBox(height: 12),
          
          TextButton(
            onPressed: () {
              // TODO: Show all reviews
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All reviews coming soon!')),
              );
            },
            child: const Text('View All Reviews'),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String name, int rating, String comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFF2E7D32),
                child: Text(
                  name[0],
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Row(
                children: List.generate(5, (index) => Icon(
                  Icons.star,
                  size: 14,
                  color: index < rating ? Colors.amber : Colors.grey[300],
                )),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            comment,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Share Machinery',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(Icons.message, 'SMS', () {}),
                _buildShareOption(Icons.share, 'WhatsApp', () {}),
                _buildShareOption(Icons.link, 'Copy Link', () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF2E7D32)),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

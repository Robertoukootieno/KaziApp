import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/services.dart';

class ServicesManagementScreen extends StatefulWidget {
  const ServicesManagementScreen({super.key});

  @override
  State<ServicesManagementScreen> createState() => _ServicesManagementScreenState();
}

class _ServicesManagementScreenState extends State<ServicesManagementScreen>
    with SingleTickerProviderStateMixin {
  final ServiceManagementService _serviceService = ServiceManagementService();

  late TabController _tabController;
  List<Service> _services = [];
  List<Service> _filteredServices = [];
  bool _isLoading = true;
  String _searchQuery = '';
  ServiceCategory? _selectedCategory;
  bool? _activeFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadServices();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadServices() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final services = await _serviceService.getServices();
      setState(() {
        _services = services;
        _filteredServices = services;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading services: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _filterServices() {
    setState(() {
      _filteredServices = _services.where((service) {
        // Search filter
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          if (!service.name.toLowerCase().contains(query) &&
              !service.description.toLowerCase().contains(query) &&
              !service.tags.any((tag) => tag.toLowerCase().contains(query))) {
            return false;
          }
        }

        // Category filter
        if (_selectedCategory != null && service.category != _selectedCategory) {
          return false;
        }

        // Active filter
        if (_activeFilter != null && service.isActive != _activeFilter) {
          return false;
        }

        return true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services Management'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.list), text: 'All Services'),
            Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
            Tab(icon: Icon(Icons.category), text: 'Categories'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _showFilterDialog,
            icon: const Icon(Icons.filter_list),
          ),
          IconButton(
            onPressed: _loadServices,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildServicesTab(),
          _buildAnalyticsTab(),
          _buildCategoriesTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "services_fab",
        onPressed: () => _showAddServiceDialog(),
        backgroundColor: const Color(0xFF2E7D32),
        icon: const Icon(Icons.add),
        label: const Text('Add Service'),
      ),
    );
  }

  Widget _buildServicesTab() {
    return Column(
      children: [
        // Search Bar
        Container(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search services...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
              _filterServices();
            },
          ),
        ),

        // Services List
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredServices.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _loadServices,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredServices.length,
                        itemBuilder: (context, index) {
                          final service = _filteredServices[index];
                          return _buildServiceCard(service);
                        },
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.business_center_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No services found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first service to get started',
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddServiceDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Add Service'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Service service) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showServiceDetails(service),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      service.category.icon,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          service.category.displayName,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'KSh ${service.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      Text(
                        service.pricingType.unit,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                service.description,
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: service.isActive
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      service.isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        color: service.isActive ? Colors.green : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: service.isAvailable
                          ? Colors.blue.withValues(alpha: 0.1)
                          : Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      service.isAvailable ? 'Available' : 'Unavailable',
                      style: TextStyle(
                        color: service.isAvailable ? Colors.blue : Colors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleServiceAction(service, value),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: service.isActive ? 'deactivate' : 'activate',
                        child: Row(
                          children: [
                            Icon(
                              service.isActive ? Icons.pause : Icons.play_arrow,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(service.isActive ? 'Deactivate' : 'Activate'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Service Analytics',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text('Coming soon...'),
        ],
      ),
    );
  }

  Widget _buildCategoriesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ServiceCategory.values.length,
      itemBuilder: (context, index) {
        final category = ServiceCategory.values[index];
        final categoryServices = _services.where((s) => s.category == category).toList();

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                category.icon,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            title: Text(category.displayName),
            subtitle: Text('${categoryServices.length} services'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              setState(() {
                _selectedCategory = category;
                _tabController.animateTo(0);
              });
              _filterServices();
            },
          ),
        );
      },
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Services'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<ServiceCategory?>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<ServiceCategory?>(
                  value: null,
                  child: Text('All Categories'),
                ),
                ...ServiceCategory.values.map((category) {
                  return DropdownMenuItem<ServiceCategory?>(
                    value: category,
                    child: Text(category.displayName),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<bool?>(
              initialValue: _activeFilter,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem<bool?>(
                  value: null,
                  child: Text('All Services'),
                ),
                DropdownMenuItem<bool?>(
                  value: true,
                  child: Text('Active Only'),
                ),
                DropdownMenuItem<bool?>(
                  value: false,
                  child: Text('Inactive Only'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _activeFilter = value;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedCategory = null;
                _activeFilter = null;
              });
              _filterServices();
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
          ElevatedButton(
            onPressed: () {
              _filterServices();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showAddServiceDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditServiceScreen(
          onSave: (service) {
            setState(() {
              _services.add(service);
            });
            _filterServices();
          },
        ),
      ),
    );
  }

  void _showServiceDetails(Service service) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceDetailsScreen(service: service),
      ),
    );
  }

  void _handleServiceAction(Service service, String action) async {
    switch (action) {
      case 'edit':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddEditServiceScreen(
              service: service,
              onSave: (updatedService) {
                setState(() {
                  final index = _services.indexWhere((s) => s.id == service.id);
                  if (index != -1) {
                    _services[index] = updatedService;
                  }
                });
                _filterServices();
              },
            ),
          ),
        );
        break;
      case 'activate':
      case 'deactivate':
        final success = await _serviceService.toggleServiceStatus(
          service.id,
          action == 'activate',
        );
        if (success) {
          _loadServices();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Service ${action}d successfully'),
                backgroundColor: const Color(0xFF2E7D32),
              ),
            );
          }
        }
        break;
      case 'delete':
        _showDeleteConfirmation(service);
        break;
    }
  }

  void _showDeleteConfirmation(Service service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Service'),
        content: Text('Are you sure you want to delete "${service.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await _serviceService.deleteService(service.id);
              if (success) {
                setState(() {
                  _services.removeWhere((s) => s.id == service.id);
                });
                _filterServices();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Service deleted successfully'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// Placeholder screens - these would be implemented separately
class AddEditServiceScreen extends StatelessWidget {
  final Service? service;
  final Function(Service) onSave;

  const AddEditServiceScreen({
    super.key,
    this.service,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(service == null ? 'Add Service' : 'Edit Service'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Add/Edit Service Form - To be implemented'),
      ),
    );
  }
}

class ServiceDetailsScreen extends StatelessWidget {
  final Service service;

  const ServiceDetailsScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(service.name),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Service Details - To be implemented'),
      ),
    );
  }
}

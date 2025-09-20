import 'package:flutter/material.dart';
import '../../../../shared/models/service_provider_registration.dart';
import '../../providers/registration_providers.dart';

class RegistrationFiltersWidget extends StatefulWidget {
  final RegistrationFilters filters;
  final Function(RegistrationFilters) onFiltersChanged;

  const RegistrationFiltersWidget({
    super.key,
    required this.filters,
    required this.onFiltersChanged,
  });

  @override
  State<RegistrationFiltersWidget> createState() => _RegistrationFiltersWidgetState();
}

class _RegistrationFiltersWidgetState extends State<RegistrationFiltersWidget> {
  late TextEditingController _searchController;
  RegistrationStatus? _selectedStatus;
  String? _selectedServiceType;

  final List<String> _serviceTypes = [
    'veterinarian',
    'machinery_provider',
    'input_supplier',
    'transport_service',
    'financial_service',
    'consultant',
    'other',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.filters.searchQuery);
    _selectedStatus = widget.filters.status;
    _selectedServiceType = widget.filters.serviceType;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Search field
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name, email, or business...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _updateFilters();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (_) => _updateFilters(),
                ),
              ),
              const SizedBox(width: 16),
              
              // Status filter
              Expanded(
                child: DropdownButtonFormField<RegistrationStatus?>(
                  value: _selectedStatus,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  items: [
                    const DropdownMenuItem<RegistrationStatus?>(
                      value: null,
                      child: Text('All Statuses'),
                    ),
                    ...RegistrationStatus.values.map(
                      (status) => DropdownMenuItem<RegistrationStatus?>(
                        value: status,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(status.icon, size: 16, color: status.color),
                            const SizedBox(width: 8),
                            Text(status.displayName),
                          ],
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                    });
                    _updateFilters();
                  },
                ),
              ),
              const SizedBox(width: 16),
              
              // Service type filter
              Expanded(
                child: DropdownButtonFormField<String?>(
                  value: _selectedServiceType,
                  decoration: InputDecoration(
                    labelText: 'Service Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('All Types'),
                    ),
                    ..._serviceTypes.map(
                      (type) => DropdownMenuItem<String?>(
                        value: type,
                        child: Text(_formatServiceType(type)),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedServiceType = value;
                    });
                    _updateFilters();
                  },
                ),
              ),
              const SizedBox(width: 16),
              
              // Clear filters button
              OutlinedButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear'),
              ),
            ],
          ),
          
          // Active filters display
          if (_hasActiveFilters()) ...[
            const SizedBox(height: 12),
            _buildActiveFilters(),
          ],
        ],
      ),
    );
  }

  Widget _buildActiveFilters() {
    final activeFilters = <Widget>[];

    if (_searchController.text.isNotEmpty) {
      activeFilters.add(
        _buildFilterChip(
          'Search: "${_searchController.text}"',
          () {
            _searchController.clear();
            _updateFilters();
          },
        ),
      );
    }

    if (_selectedStatus != null) {
      activeFilters.add(
        _buildFilterChip(
          'Status: ${_selectedStatus!.displayName}',
          () {
            setState(() {
              _selectedStatus = null;
            });
            _updateFilters();
          },
        ),
      );
    }

    if (_selectedServiceType != null) {
      activeFilters.add(
        _buildFilterChip(
          'Type: ${_formatServiceType(_selectedServiceType!)}',
          () {
            setState(() {
              _selectedServiceType = null;
            });
            _updateFilters();
          },
        ),
      );
    }

    return Row(
      children: [
        const Text(
          'Active filters:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 8),
        ...activeFilters.map((filter) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: filter,
            )),
      ],
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: onRemove,
      backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
      deleteIconColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(color: Theme.of(context).primaryColor),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  String _formatServiceType(String serviceType) {
    switch (serviceType) {
      case 'veterinarian':
        return 'Veterinarian';
      case 'machinery_provider':
        return 'Machinery Provider';
      case 'input_supplier':
        return 'Input Supplier';
      case 'transport_service':
        return 'Transport Service';
      case 'financial_service':
        return 'Financial Service';
      case 'consultant':
        return 'Consultant';
      case 'other':
        return 'Other';
      default:
        return serviceType;
    }
  }

  bool _hasActiveFilters() {
    return _searchController.text.isNotEmpty ||
        _selectedStatus != null ||
        _selectedServiceType != null;
  }

  void _updateFilters() {
    final newFilters = RegistrationFilters(
      searchQuery: _searchController.text.trim().isEmpty 
          ? null 
          : _searchController.text.trim(),
      status: _selectedStatus,
      serviceType: _selectedServiceType,
      page: 1, // Reset to first page when filters change
      limit: widget.filters.limit,
    );
    
    widget.onFiltersChanged(newFilters);
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedStatus = null;
      _selectedServiceType = null;
    });
    _updateFilters();
  }
}

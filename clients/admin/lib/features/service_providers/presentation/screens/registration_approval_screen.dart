import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/models/service_provider_registration.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/responsive_data_table.dart';
import '../../../../shared/services/websocket_service.dart';
import '../../providers/registration_providers.dart';
import '../widgets/registration_details_dialog.dart';
import '../widgets/registration_filters_widget.dart';
import '../widgets/bulk_actions_widget.dart';
import '../widgets/registration_stats_widget.dart';

class RegistrationApprovalScreen extends ConsumerStatefulWidget {
  const RegistrationApprovalScreen({super.key});

  @override
  ConsumerState<RegistrationApprovalScreen> createState() => _RegistrationApprovalScreenState();
}

class _RegistrationApprovalScreenState extends ConsumerState<RegistrationApprovalScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<String> _tabs = [
    'Pending Review',
    'All Registrations',
    'Approved',
    'Rejected',
    'Statistics',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildTabs(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPendingRegistrationsTab(),
                _buildAllRegistrationsTab(),
                _buildApprovedRegistrationsTab(),
                _buildRejectedRegistrationsTab(),
                _buildStatisticsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.how_to_reg, size: 32, color: Color(0xFF1976D2)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Registration Approvals',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Review and approve service provider registrations',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const Spacer(),
          // Real-time connection indicator
          Consumer(
            builder: (context, ref, child) {
              final connectionState = ref.watch(webSocketConnectionProvider);
              return connectionState.when(
                data: (state) => _buildConnectionIndicator(state),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              );
            },
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionIndicator(WebSocketConnectionState state) {
    Color color;
    IconData icon;
    String tooltip;

    switch (state) {
      case WebSocketConnectionState.connected:
        color = Colors.green;
        icon = Icons.wifi;
        tooltip = 'Real-time updates active';
        break;
      case WebSocketConnectionState.connecting:
        color = Colors.orange;
        icon = Icons.wifi_protected_setup;
        tooltip = 'Connecting...';
        break;
      case WebSocketConnectionState.disconnected:
        color = Colors.grey;
        icon = Icons.wifi_off;
        tooltip = 'Real-time updates disabled';
        break;
      case WebSocketConnectionState.error:
        color = Colors.red;
        icon = Icons.error;
        tooltip = 'Connection error';
        break;
    }

    return Tooltip(
      message: tooltip,
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        labelColor: const Color(0xFF1976D2),
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: const Color(0xFF1976D2),
      ),
    );
  }

  Widget _buildPendingRegistrationsTab() {
    return Consumer(
      builder: (context, ref, child) {
        final pendingRegistrationsAsync = ref.watch(pendingRegistrationsProvider);
        final selectedRegistrations = ref.watch(selectedRegistrationsProvider);

        return pendingRegistrationsAsync.when(
          data: (registrations) => Column(
            children: [
              if (selectedRegistrations.isNotEmpty)
                BulkActionsWidget(
                  selectedCount: selectedRegistrations.length,
                  onBulkApprove: () => _handleBulkApprove(selectedRegistrations.toList()),
                  onBulkReject: () => _handleBulkReject(selectedRegistrations.toList()),
                ),
              Expanded(
                child: _buildRegistrationsTable(
                  registrations,
                  showStatusFilter: false,
                ),
              ),
            ],
          ),
          loading: () => const LoadingWidget(),
          error: (error, stack) => CustomErrorWidget(
            error: error.toString(),
            onRetry: () => ref.refresh(pendingRegistrationsProvider),
          ),
        );
      },
    );
  }

  Widget _buildAllRegistrationsTab() {
    return Consumer(
      builder: (context, ref, child) {
        final filters = ref.watch(registrationFiltersProvider);
        final registrationsAsync = ref.watch(registrationsProvider(filters));

        return registrationsAsync.when(
          data: (registrations) => Column(
            children: [
              RegistrationFiltersWidget(
                filters: filters,
                onFiltersChanged: (newFilters) {
                  final notifier = ref.read(registrationFiltersProvider.notifier);
                  notifier.updateStatus(newFilters.status);
                  notifier.updateServiceType(newFilters.serviceType);
                  notifier.updateSearchQuery(newFilters.searchQuery);
                  notifier.updatePage(newFilters.page);
                  notifier.updateLimit(newFilters.limit);
                },
              ),
              Expanded(
                child: _buildRegistrationsTable(registrations),
              ),
            ],
          ),
          loading: () => const LoadingWidget(),
          error: (error, stack) => CustomErrorWidget(
            error: error.toString(),
            onRetry: () => ref.refresh(registrationsProvider(filters)),
          ),
        );
      },
    );
  }

  Widget _buildApprovedRegistrationsTab() {
    return Consumer(
      builder: (context, ref, child) {
        final filters = ref.watch(registrationFiltersProvider).copyWith(
          status: RegistrationStatus.approved,
        );
        final registrationsAsync = ref.watch(registrationsProvider(filters));

        return registrationsAsync.when(
          data: (registrations) => _buildRegistrationsTable(
            registrations,
            showStatusFilter: false,
          ),
          loading: () => const LoadingWidget(),
          error: (error, stack) => CustomErrorWidget(
            error: error.toString(),
            onRetry: () => ref.refresh(registrationsProvider(filters)),
          ),
        );
      },
    );
  }

  Widget _buildRejectedRegistrationsTab() {
    return Consumer(
      builder: (context, ref, child) {
        final filters = ref.watch(registrationFiltersProvider).copyWith(
          status: RegistrationStatus.rejected,
        );
        final registrationsAsync = ref.watch(registrationsProvider(filters));

        return registrationsAsync.when(
          data: (registrations) => _buildRegistrationsTable(
            registrations,
            showStatusFilter: false,
          ),
          loading: () => const LoadingWidget(),
          error: (error, stack) => CustomErrorWidget(
            error: error.toString(),
            onRetry: () => ref.refresh(registrationsProvider(filters)),
          ),
        );
      },
    );
  }

  Widget _buildStatisticsTab() {
    return const RegistrationStatsWidget();
  }

  Widget _buildRegistrationsTable(
    List<ServiceProviderRegistration> registrations, {
    bool showStatusFilter = true,
  }) {
    if (registrations.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No registrations found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ResponsiveDataTable(
      columns: _buildTableColumns(),
      rows: registrations.map((registration) => _buildTableRow(registration)).toList(),
      minWidth: 1200,
    );
  }

  List<DataColumn2> _buildTableColumns() {
    return const [
      DataColumn2(label: Text(''), size: ColumnSize.S), // Checkbox
      DataColumn2(label: Text('Service Provider'), size: ColumnSize.L),
      DataColumn2(label: Text('Business'), size: ColumnSize.L),
      DataColumn2(label: Text('Service Type'), size: ColumnSize.M),
      DataColumn2(label: Text('Status'), size: ColumnSize.S),
      DataColumn2(label: Text('Submitted'), size: ColumnSize.M),
      DataColumn2(label: Text('Actions'), size: ColumnSize.M),
    ];
  }

  DataRow2 _buildTableRow(ServiceProviderRegistration registration) {
    return DataRow2(
      cells: [
        DataCell(
          Consumer(
            builder: (context, ref, child) {
              final selectedRegistrations = ref.watch(selectedRegistrationsProvider);
              return Checkbox(
                value: selectedRegistrations.contains(registration.id),
                onChanged: (value) {
                  ref.read(selectedRegistrationsProvider.notifier)
                      .toggleSelection(registration.id);
                },
              );
            },
          ),
        ),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${registration.firstName} ${registration.lastName}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                registration.email,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                registration.businessName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                '${registration.county}, ${registration.subCounty}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        DataCell(Text(registration.serviceType)),
        DataCell(_buildStatusChip(registration.status)),
        DataCell(Text(_formatDate(registration.submittedAt))),
        DataCell(_buildActionButtons(registration)),
      ],
    );
  }

  Widget _buildStatusChip(RegistrationStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: status.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 12, color: status.color),
          const SizedBox(width: 4),
          Text(
            status.displayName,
            style: TextStyle(
              fontSize: 11,
              color: status.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ServiceProviderRegistration registration) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.visibility, size: 18),
          onPressed: () => _viewRegistrationDetails(registration),
          tooltip: 'View Details',
        ),
        if (registration.status == RegistrationStatus.pending) ...[
          IconButton(
            icon: const Icon(Icons.check, size: 18, color: Colors.green),
            onPressed: () => _approveRegistration(registration.id),
            tooltip: 'Approve',
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18, color: Colors.red),
            onPressed: () => _rejectRegistration(registration.id),
            tooltip: 'Reject',
          ),
        ],
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _viewRegistrationDetails(ServiceProviderRegistration registration) {
    showDialog(
      context: context,
      builder: (context) => RegistrationDetailsDialog(registration: registration),
    );
  }

  void _approveRegistration(String registrationId) async {
    try {
      await ref.read(registrationActionsProvider).approveRegistration(registrationId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration approved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to approve registration: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _rejectRegistration(String registrationId) {
    // Show rejection dialog
    // Implementation will be added in the next part
  }

  void _handleBulkApprove(List<String> registrationIds) async {
    // Implementation will be added in the next part
  }

  void _handleBulkReject(List<String> registrationIds) {
    // Implementation will be added in the next part
  }

  void _refreshData() {
    ref.invalidate(pendingRegistrationsProvider);
    ref.invalidate(registrationsProvider);
    ref.invalidate(registrationStatisticsProvider);
  }
}

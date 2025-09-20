import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/security/permission_manager.dart';
import '../../../../shared/models/admin_user.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../providers/system_providers.dart';
import '../widgets/feature_flags_widget.dart';
import '../widgets/environment_settings_widget.dart';
import '../widgets/api_configuration_widget.dart';
import '../widgets/third_party_integrations_widget.dart';
import '../widgets/deployment_controls_widget.dart';
import '../widgets/backup_restore_widget.dart';

class SystemConfigurationScreen extends ConsumerStatefulWidget {
  const SystemConfigurationScreen({super.key});

  @override
  ConsumerState<SystemConfigurationScreen> createState() =>
      _SystemConfigurationScreenState();
}

class _SystemConfigurationScreenState
    extends ConsumerState<SystemConfigurationScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _hasUnsavedChanges = false;

  final List<String> _tabs = [
    'Feature Flags',
    'Environment Settings',
    'API Configuration',
    'Third-party Integrations',
    'Deployment Controls',
    'Backup & Restore',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    ref.read(featureFlagsProvider.notifier).loadFeatureFlags();
    ref.read(environmentSettingsProvider.notifier).loadSettings();
    ref.read(apiConfigurationProvider.notifier).loadConfiguration();
    ref.read(thirdPartyIntegrationsProvider.notifier).loadIntegrations();
    ref.read(deploymentStatusProvider.notifier).loadStatus();
    ref.read(backupStatusProvider.notifier).loadBackupStatus();
  }

  @override
  Widget build(BuildContext context) {
    final permissionManager = ref.watch(permissionManagerProvider);
    
    // Check permissions
    if (!permissionManager.checkCategoryAccess(PermissionCategory.systemConfiguration).granted) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('Access Denied'),
              Text('You don\'t have permission to access system configuration.'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildSystemStatusBar(),
          _buildTabs(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFeatureFlagsTab(),
                _buildEnvironmentSettingsTab(),
                _buildApiConfigurationTab(),
                _buildThirdPartyIntegrationsTab(),
                _buildDeploymentControlsTab(),
                _buildBackupRestoreTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: _hasUnsavedChanges ? _buildUnsavedChangesBar() : null,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.settings, size: 32, color: Color(0xFF455A64)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'System Configuration & Settings',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Manage system-wide settings, feature flags, and configurations',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const Spacer(),
          if (_hasUnsavedChanges) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning, size: 16, color: Colors.orange),
                  SizedBox(width: 4),
                  Text(
                    'Unsaved Changes',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
          ],
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh Data',
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _viewConfigurationHistory,
            tooltip: 'Configuration History',
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _openHelp,
            tooltip: 'Help',
          ),
        ],
      ),
    );
  }

  Widget _buildSystemStatusBar() {
    final environmentAsync = ref.watch(environmentSettingsProvider);
    
    return environmentAsync.when(
      data: (environment) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _getEnvironmentColor(environment.currentEnvironment).withOpacity(0.1),
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.circle,
              size: 12,
              color: _getEnvironmentColor(environment.currentEnvironment),
            ),
            const SizedBox(width: 8),
            Text(
              'Environment: ${environment.currentEnvironment.toUpperCase()}',
              style: TextStyle(
                color: _getEnvironmentColor(environment.currentEnvironment),
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 24),
            Icon(
              Icons.memory,
              size: 12,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              'Version: ${environment.appVersion}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            const Spacer(),
            Text(
              'Last Updated: ${_formatDateTime(environment.lastUpdated)}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      loading: () => const SizedBox(height: 32),
      error: (_, __) => const SizedBox(height: 32),
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
        labelColor: const Color(0xFF455A64),
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: const Color(0xFF455A64),
      ),
    );
  }

  Widget _buildFeatureFlagsTab() {
    return FeatureFlagsWidget(
      onChanged: () => setState(() => _hasUnsavedChanges = true),
    );
  }

  Widget _buildEnvironmentSettingsTab() {
    return EnvironmentSettingsWidget(
      onChanged: () => setState(() => _hasUnsavedChanges = true),
    );
  }

  Widget _buildApiConfigurationTab() {
    return ApiConfigurationWidget(
      onChanged: () => setState(() => _hasUnsavedChanges = true),
    );
  }

  Widget _buildThirdPartyIntegrationsTab() {
    return ThirdPartyIntegrationsWidget(
      onChanged: () => setState(() => _hasUnsavedChanges = true),
    );
  }

  Widget _buildDeploymentControlsTab() {
    return const DeploymentControlsWidget();
  }

  Widget _buildBackupRestoreTab() {
    return const BackupRestoreWidget();
  }

  Widget? _buildFloatingActionButton() {
    final currentTab = _tabController.index;
    final permissionManager = ref.watch(permissionManagerProvider);
    
    switch (currentTab) {
      case 0: // Feature Flags
        if (permissionManager.checkPermission(Permission.systemConfigurationUpdate).granted) {
          return FloatingActionButton.extended(
            onPressed: _createFeatureFlag,
            icon: const Icon(Icons.flag),
            label: const Text('New Feature Flag'),
          );
        }
        break;
      case 2: // API Configuration
        if (permissionManager.checkPermission(Permission.systemConfigurationUpdate).granted) {
          return FloatingActionButton.extended(
            onPressed: _addApiEndpoint,
            icon: const Icon(Icons.api),
            label: const Text('Add Endpoint'),
          );
        }
        break;
      case 3: // Third-party Integrations
        if (permissionManager.checkPermission(Permission.systemConfigurationUpdate).granted) {
          return FloatingActionButton.extended(
            onPressed: _addIntegration,
            icon: const Icon(Icons.integration_instructions),
            label: const Text('Add Integration'),
          );
        }
        break;
      case 5: // Backup & Restore
        return FloatingActionButton.extended(
          onPressed: _createBackup,
          icon: const Icon(Icons.backup),
          label: const Text('Create Backup'),
        );
    }
    return null;
  }

  Widget _buildUnsavedChangesBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        border: Border(
          top: BorderSide(color: Colors.orange.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning, color: Colors.orange),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'You have unsaved changes. Save them before leaving.',
              style: TextStyle(color: Colors.orange),
            ),
          ),
          TextButton(
            onPressed: _discardChanges,
            child: const Text('Discard'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _saveChanges,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  Color _getEnvironmentColor(String environment) {
    switch (environment.toLowerCase()) {
      case 'production':
        return Colors.red;
      case 'staging':
        return Colors.orange;
      case 'development':
        return Colors.green;
      case 'testing':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // Action handlers
  void _refreshData() {
    _loadInitialData();
  }

  void _viewConfigurationHistory() {
    // TODO: Implement configuration history
  }

  void _openHelp() {
    // TODO: Implement help
  }

  void _createFeatureFlag() {
    // TODO: Implement create feature flag
  }

  void _addApiEndpoint() {
    // TODO: Implement add API endpoint
  }

  void _addIntegration() {
    // TODO: Implement add integration
  }

  void _createBackup() {
    // TODO: Implement create backup
  }

  void _saveChanges() async {
    try {
      // Save all pending changes
      await _performSaveOperations();
      
      setState(() {
        _hasUnsavedChanges = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Configuration saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save configuration: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _discardChanges() {
    setState(() {
      _hasUnsavedChanges = false;
    });
    _loadInitialData(); // Reload original data
  }

  Future<void> _performSaveOperations() async {
    // This would save all pending changes across different tabs
    // Implementation would depend on the specific changes made
    
    // Example operations:
    // - Save feature flag changes
    // - Save environment settings
    // - Save API configuration
    // - Save integration settings
    
    await Future.delayed(const Duration(seconds: 1)); // Simulate save operation
  }
}

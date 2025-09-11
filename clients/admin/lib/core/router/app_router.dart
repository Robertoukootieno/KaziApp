import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_constants.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/users/presentation/screens/users_screen.dart';
import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../../features/access_control/presentation/screens/access_control_screen.dart';
import '../../features/service_providers/presentation/screens/service_provider_management_screen.dart';
import '../../shared/widgets/admin_layout.dart';

// Router Provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppConstants.loginRoute,
    routes: [
      // Auth Routes
      GoRoute(
        path: AppConstants.loginRoute,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      
      // Main App Shell with Navigation
      ShellRoute(
        builder: (context, state, child) {
          return AdminLayout(child: child);
        },
        routes: [
          // Dashboard
          GoRoute(
            path: AppConstants.dashboardRoute,
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          
          // Users Management
          GoRoute(
            path: AppConstants.usersRoute,
            name: 'users',
            builder: (context, state) => const UsersScreen(),
            routes: [
              GoRoute(
                path: '/farmers',
                name: 'farmers',
                builder: (context, state) => const UsersScreen(userType: 'farmer'),
              ),
              GoRoute(
                path: '/service-providers',
                name: 'service-providers',
                builder: (context, state) => const UsersScreen(userType: 'service_provider'),
              ),
              GoRoute(
                path: '/veterinarians',
                name: 'veterinarians',
                builder: (context, state) => const UsersScreen(userType: 'veterinarian'),
              ),
              GoRoute(
                path: '/buyers',
                name: 'buyers',
                builder: (context, state) => const UsersScreen(userType: 'buyer'),
              ),
              GoRoute(
                path: '/vendors',
                name: 'vendors',
                builder: (context, state) => const UsersScreen(userType: 'vendor'),
              ),
            ],
          ),
          
          // Analytics
          GoRoute(
            path: AppConstants.analyticsRoute,
            name: 'analytics',
            builder: (context, state) => const AnalyticsScreen(),
          ),

          // Access Control
          GoRoute(
            path: '/access-control',
            name: 'access-control',
            builder: (context, state) => const AccessControlScreen(),
          ),

          // Service Provider Management
          GoRoute(
            path: '/service-provider-management',
            name: 'service-provider-management',
            builder: (context, state) => const ServiceProviderManagementScreen(),
          ),
          
          // Settings
          GoRoute(
            path: AppConstants.settingsRoute,
            name: 'settings',
            builder: (context, state) => const Scaffold(
              body: Center(
                child: Text('Settings Screen - Coming Soon'),
              ),
            ),
          ),
          
          // Profile
          GoRoute(
            path: AppConstants.profileRoute,
            name: 'profile',
            builder: (context, state) => const Scaffold(
              body: Center(
                child: Text('Profile Screen - Coming Soon'),
              ),
            ),
          ),
        ],
      ),
    ],
    
    // Error handling
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppConstants.dashboardRoute),
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    ),
    
    // Redirect logic
    redirect: (context, state) {
      // TODO: Add authentication check here
      // For now, allow all routes
      return null;
    },
  );
});

// Navigation Helper
class AppNavigation {
  static void goToDashboard(BuildContext context) {
    context.go(AppConstants.dashboardRoute);
  }
  
  static void goToUsers(BuildContext context) {
    context.go(AppConstants.usersRoute);
  }
  
  static void goToFarmers(BuildContext context) {
    context.go('${AppConstants.usersRoute}/farmers');
  }
  
  static void goToServiceProviders(BuildContext context) {
    context.go('${AppConstants.usersRoute}/service-providers');
  }
  
  static void goToVeterinarians(BuildContext context) {
    context.go('${AppConstants.usersRoute}/veterinarians');
  }
  
  static void goToBuyers(BuildContext context) {
    context.go('${AppConstants.usersRoute}/buyers');
  }
  
  static void goToVendors(BuildContext context) {
    context.go('${AppConstants.usersRoute}/vendors');
  }
  
  static void goToAnalytics(BuildContext context) {
    context.go(AppConstants.analyticsRoute);
  }

  static void goToAccessControl(BuildContext context) {
    context.go('/access-control');
  }

  static void goToServiceProviderManagement(BuildContext context) {
    context.go('/service-provider-management');
  }

  static void goToSettings(BuildContext context) {
    context.go(AppConstants.settingsRoute);
  }
  
  static void goToProfile(BuildContext context) {
    context.go(AppConstants.profileRoute);
  }
  
  static void goToLogin(BuildContext context) {
    context.go(AppConstants.loginRoute);
  }
}

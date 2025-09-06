import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

class AdminLayout extends StatefulWidget {
  final Widget child;

  const AdminLayout({
    super.key,
    required this.child,
  });

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  int _selectedIndex = 0;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.dashboard,
      label: 'Dashboard',
      route: AppConstants.dashboardRoute,
    ),
    NavigationItem(
      icon: Icons.people,
      label: 'Users',
      route: AppConstants.usersRoute,
    ),
    NavigationItem(
      icon: Icons.analytics,
      label: 'Analytics',
      route: AppConstants.analyticsRoute,
    ),
    NavigationItem(
      icon: Icons.settings,
      label: 'Settings',
      route: AppConstants.settingsRoute,
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    final location = GoRouterState.of(context).uri.path;
    for (int i = 0; i < _navigationItems.length; i++) {
      if (location.startsWith(_navigationItems[i].route)) {
        setState(() {
          _selectedIndex = i;
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= AppConstants.desktopBreakpoint;
    final isTablet = MediaQuery.of(context).size.width >= AppConstants.tabletBreakpoint;

    if (isDesktop) {
      return _buildDesktopLayout();
    } else if (isTablet) {
      return _buildTabletLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          // Navigation Rail
          NavigationRail(
            extended: true,
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onDestinationSelected,
            leading: _buildLogo(),
            trailing: _buildUserMenu(),
            destinations: _navigationItems
                .map((item) => NavigationRailDestination(
                      icon: Icon(item.icon),
                      label: Text(item.label),
                    ))
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Main Content
          Expanded(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(child: widget.child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      body: Row(
        children: [
          // Navigation Rail (collapsed)
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onDestinationSelected,
            leading: _buildLogo(compact: true),
            destinations: _navigationItems
                .map((item) => NavigationRailDestination(
                      icon: Icon(item.icon),
                      label: Text(item.label),
                    ))
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Main Content
          Expanded(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(child: widget.child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onDestinationSelected,
        items: _navigationItems
            .map((item) => BottomNavigationBarItem(
                  icon: Icon(item.icon),
                  label: item.label,
                ))
            .toList(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(_navigationItems[_selectedIndex].label),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            // TODO: Show notifications
          },
        ),
        const SizedBox(width: 8),
        _buildUserMenu(),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildLogo({bool compact = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: compact
          ? const Icon(
              Icons.agriculture,
              size: 32,
              color: AppTheme.primarySwatch,
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.agriculture,
                  size: 32,
                  color: AppTheme.primarySwatch,
                ),
                const SizedBox(height: 8),
                Text(
                  'KaziApp',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primarySwatch,
                      ),
                ),
                Text(
                  'Admin',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
              ],
            ),
    );
  }

  Widget _buildUserMenu() {
    return PopupMenuButton<String>(
      icon: const CircleAvatar(
        radius: 16,
        child: Icon(Icons.person, size: 20),
      ),
      onSelected: (value) {
        switch (value) {
          case 'profile':
            context.go(AppConstants.profileRoute);
            break;
          case 'logout':
            _handleLogout();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'profile',
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'logout',
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppTheme.primarySwatch,
            ),
            child: _buildLogo(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _navigationItems.length,
              itemBuilder: (context, index) {
                final item = _navigationItems[index];
                return ListTile(
                  leading: Icon(item.icon),
                  title: Text(item.label),
                  selected: _selectedIndex == index,
                  onTap: () {
                    _onDestinationSelected(index);
                    Navigator.of(context).pop(); // Close drawer
                  },
                );
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.of(context).pop();
              context.go(AppConstants.profileRoute);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              _handleLogout();
            },
          ),
        ],
      ),
    );
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    context.go(_navigationItems[index].route);
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go(AppConstants.loginRoute);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final String route;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

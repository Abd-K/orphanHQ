import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DesktopLayout extends StatelessWidget {
  final Widget child;
  final String currentRoute;
  final String pageTitle;
  final List<Widget>? actions;

  const DesktopLayout({
    super.key,
    required this.child,
    required this.currentRoute,
    required this.pageTitle,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Sidebar Navigation
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                right: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            child: Column(
              children: [
                // App Header
                Container(
                  height: 80,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                    border: Border(
                      bottom: BorderSide(color: Colors.blue[800]!, width: 1),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.home_work, color: Colors.white, size: 32),
                      SizedBox(width: 12),
                      Text(
                        'Orphan HQ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Navigation Items
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    children: [
                      _buildNavItem(
                        context,
                        icon: Icons.child_care,
                        title: 'Orphans',
                        route: '/',
                        isActive: currentRoute == '/' ||
                            currentRoute.startsWith('/orphan'),
                      ),
                      _buildNavItem(
                        context,
                        icon: Icons.people,
                        title: 'Supervisors',
                        route: '/supervisors',
                        isActive: currentRoute == '/supervisors' ||
                            currentRoute.startsWith('/supervisor'),
                      ),
                      _buildNavItem(
                        context,
                        icon: Icons.warning,
                        title: 'Emergency',
                        route: '/emergency',
                        isActive: currentRoute == '/emergency',
                        iconColor: Colors.red[600],
                      ),
                      const Divider(height: 32),
                      _buildNavItem(
                        context,
                        icon: Icons.settings,
                        title: 'Settings',
                        route: '/settings',
                        isActive: currentRoute == '/settings',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top Action Bar
                Container(
                  height: 80,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Page Title
                      Expanded(
                        child: Text(
                          pageTitle,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      // Page Actions
                      if (actions != null) ...actions!,
                    ],
                  ),
                ),

                // Page Content
                Expanded(
                  child: Container(
                    color: Colors.grey[50],
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
    required bool isActive,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue[100] : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Colors.blue[700] : (iconColor ?? Colors.grey[600]),
          size: 22,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.blue[700] : Colors.grey[700],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        onTap: () {
          // Only navigate if not already on the target route to prevent unnecessary rebuilds
          final currentLocation = GoRouterState.of(context).uri.path;
          if (currentLocation != route) {
            context.go(route);
          }
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        dense: true,
      ),
    );
  }
}

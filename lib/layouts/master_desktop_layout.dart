import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MasterDesktopLayout extends StatefulWidget {
  final Widget child;
  final String currentRoute;
  final String pageTitle;
  final List<Widget>? actions;

  const MasterDesktopLayout({
    super.key,
    required this.child,
    required this.currentRoute,
    required this.pageTitle,
    this.actions,
  });

  @override
  State<MasterDesktopLayout> createState() => _MasterDesktopLayoutState();
}

class _MasterDesktopLayoutState extends State<MasterDesktopLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // PERMANENT SIDEBAR - Never changes, never rebuilds
          _buildPermanentSidebar(),

          // DYNAMIC CONTENT AREA - Only this updates
          Expanded(
            child: Column(
              children: [
                // Dynamic Action Bar
                _buildDynamicActionBar(),

                // Dynamic Content Area
                Expanded(
                  child: Container(
                    color: Colors.grey[50],
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermanentSidebar() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          right: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Permanent App Header
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

          // Permanent Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _buildNavigationItem(
                  icon: Icons.child_care,
                  title: 'Orphans',
                  route: '/',
                  isActive: widget.currentRoute == '/' ||
                      widget.currentRoute.startsWith('/orphan'),
                ),
                _buildNavigationItem(
                  icon: Icons.people,
                  title: 'Supervisors',
                  route: '/supervisors',
                  isActive: widget.currentRoute == '/supervisors' ||
                      widget.currentRoute.startsWith('/supervisor'),
                ),
                _buildNavigationItem(
                  icon: Icons.warning,
                  title: 'Emergency',
                  route: '/emergency',
                  isActive: widget.currentRoute == '/emergency',
                  iconColor: Colors.red[600],
                ),
                const Divider(height: 32),
                _buildNavigationItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  route: '/settings',
                  isActive: widget.currentRoute == '/settings',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicActionBar() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
              widget.pageTitle,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          // Page Actions
          if (widget.actions != null) ...widget.actions!,
        ],
      ),
    );
  }

  Widget _buildNavigationItem({
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
          // Instant navigation - no visual transition
          final currentLocation = GoRouterState.of(context).uri.path;
          if (currentLocation != route) {
            // Use pushReplacement for instant navigation without animation
            context.go(route);
          }
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        dense: true,
      ),
    );
  }
}

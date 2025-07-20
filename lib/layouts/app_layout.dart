import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orphan_hq/services/app_localizations.dart';

class AppLayout extends StatefulWidget {
  final Widget child;
  final String currentRoute;

  const AppLayout({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // PERMANENT SIDEBAR - Never changes, never rebuilds
          _buildPermanentSidebar(),

          // DYNAMIC CONTENT AREA - Only this updates
          Expanded(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermanentSidebar() {
    final theme = Theme.of(context);

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? const Color(0xFF161B22) // Match card color
            : Colors.grey[50],
        border: Border(
          right: BorderSide(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Permanent App Header
          Container(
            height: 80,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark
                  ? const Color(0xFF0D1117) // Match scaffold background
                  : Colors.blue[700],
              border: Border(
                bottom: BorderSide(
                  color: theme.brightness == Brightness.dark
                      ? const Color(0xFF21262D)
                      : Colors.blue[800]!,
                  width: 1,
                ),
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
                  title: AppLocalizations.of(context)!.translate('orphans'),
                  route: '/',
                  isActive: widget.currentRoute == '/' ||
                      widget.currentRoute.startsWith('/orphan'),
                ),
                _buildNavigationItem(
                  icon: Icons.people,
                  title:
                  AppLocalizations.of(context)!.translate('supervisors'),
                  route: '/supervisors',
                  isActive: widget.currentRoute == '/supervisors' ||
                      widget.currentRoute.startsWith('/supervisor'),
                ),
                _buildNavigationItem(
                  icon: Icons.warning,
                  title: AppLocalizations.of(context)!.translate('emergency'),
                  route: '/emergency',
                  isActive: widget.currentRoute == '/emergency',
                  iconColor: Colors.red[600],
                ),
                const Divider(height: 32),
                _buildNavigationItem(
                  icon: Icons.settings,
                  title: AppLocalizations.of(context)!.translate('settings'),
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

  Widget _buildNavigationItem({
    required IconData icon,
    required String title,
    required String route,
    required bool isActive,
    Color? iconColor,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: isActive
            ? (isDark ? Colors.blue[900]!.withOpacity(0.3) : Colors.blue[100])
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive
              ? (isDark ? Colors.blue[300] : Colors.blue[700])
              : (iconColor ?? (isDark ? Colors.grey[400] : Colors.grey[600])),
          size: 22,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive
                ? (isDark ? Colors.blue[300] : Colors.blue[700])
                : (isDark ? Colors.grey[300] : Colors.grey[700]),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        onTap: () {
          // Instant navigation - no visual transition
          final currentLocation = GoRouterState.of(context).uri.path;
          if (currentLocation != route) {
            // Use go() for instant navigation without any animation
            context.go(route);
          }
        },
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        dense: true,
      ),
    );
  }
}
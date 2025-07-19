import 'package:go_router/go_router.dart';
import 'package:orphan_hq/pages/add_supervisor_page.dart';
import 'package:orphan_hq/pages/edit_supervisor_page.dart';
import 'package:orphan_hq/pages/emergency_dashboard_page.dart';
import 'package:orphan_hq/pages/onboard_orphan_page.dart';
import 'package:orphan_hq/pages/orphan_details_page.dart';
import 'package:orphan_hq/pages/orphan_list_page.dart';
import 'package:orphan_hq/pages/settings_page.dart';
import 'package:orphan_hq/pages/supervisor_details_page.dart';
import 'package:orphan_hq/pages/supervisor_orphans_page.dart';
import 'package:orphan_hq/pages/supervisor_view_page.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) =>
          const OrphanListPage(), // Main page shows orphan list
    ),
    GoRoute(
      path: '/onboard',
      builder: (context, state) =>
          const OnboardOrphanPage(), // Use dedicated onboard orphan page
    ),
    GoRoute(
      path: '/emergency',
      builder: (context, state) => const EmergencyDashboardPage(),
    ),
    GoRoute(
      path: '/supervisors',
      builder: (context, state) => const SupervisorViewPage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/add-supervisor',
      builder: (context, state) => const AddSupervisorPage(),
    ),
    GoRoute(
      path: '/edit-supervisor/:id',
      builder: (context, state) {
        final supervisorId = state.pathParameters['id']!;
        return EditSupervisorPage(supervisorId: supervisorId);
      },
    ),
    GoRoute(
      path: '/supervisor/:id',
      builder: (context, state) {
        final supervisorId = state.pathParameters['id']!;
        return SupervisorDetailsPage(supervisorId: supervisorId);
      },
    ),
    GoRoute(
      path: '/orphan/:id',
      builder: (context, state) {
        final orphanId = state.pathParameters['id']!;
        return OrphanDetailsPage(orphanId: orphanId);
      },
    ),
    GoRoute(
      path: '/supervisor/:id/orphans',
      builder: (context, state) {
        final supervisorId = state.pathParameters['id']!;
        return SupervisorOrphansPage(supervisorId: supervisorId);
      },
    ),
  ],
);

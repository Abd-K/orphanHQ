import 'package:go_router/go_router.dart';
import 'package:orphan_hq/pages/add_supervisor_page.dart';
import 'package:orphan_hq/pages/emergency_dashboard_page.dart';
import 'package:orphan_hq/pages/onboard_orphan_page.dart';
import 'package:orphan_hq/pages/orphan_details_page.dart';
import 'package:orphan_hq/pages/orphan_list_page.dart';
import 'package:orphan_hq/pages/supervisor_orphans_page.dart';
import 'package:orphan_hq/pages/supervisor_view_page.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const OrphanListPage(),
    ),
    GoRoute(
      path: '/onboard',
      builder: (context, state) => const OnboardOrphanPage(),
    ),
    GoRoute(
      path: '/emergency',
      builder: (context, state) => const EmergencyDashboardPage(),
    ),
    GoRoute(
      path: '/add-supervisor',
      builder: (context, state) => const AddSupervisorPage(),
    ),
    GoRoute(
      path: '/supervisors',
      builder: (context, state) => const SupervisorViewPage(),
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

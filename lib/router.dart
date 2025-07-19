import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orphan_hq/layouts/app_layout.dart';
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
      builder: (context, state) => AppLayout(
        currentRoute: '/',
        child: const OrphanListPage(),
      ),
    ),
    GoRoute(
      path: '/onboard',
      builder: (context, state) => AppLayout(
        currentRoute: '/onboard',
        child: const OnboardOrphanPage(),
      ),
    ),
    GoRoute(
      path: '/emergency',
      builder: (context, state) => AppLayout(
        currentRoute: '/emergency',
        child: const EmergencyDashboardPage(),
      ),
    ),
    GoRoute(
      path: '/supervisors',
      builder: (context, state) => AppLayout(
        currentRoute: '/supervisors',
        child: const SupervisorViewPage(),
      ),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => AppLayout(
        currentRoute: '/settings',
        child: const SettingsPage(),
      ),
    ),
    GoRoute(
      path: '/add-supervisor',
      builder: (context, state) => AppLayout(
        currentRoute: '/add-supervisor',
        child: const AddSupervisorPage(),
      ),
    ),
    GoRoute(
      path: '/edit-supervisor/:id',
      builder: (context, state) {
        final supervisorId = state.pathParameters['id']!;
        return AppLayout(
          currentRoute: '/edit-supervisor/$supervisorId',
          child: EditSupervisorPage(supervisorId: supervisorId),
        );
      },
    ),
    GoRoute(
      path: '/supervisor/:id',
      builder: (context, state) {
        final supervisorId = state.pathParameters['id']!;
        return AppLayout(
          currentRoute: '/supervisor/$supervisorId',
          child: SupervisorDetailsPage(supervisorId: supervisorId),
        );
      },
    ),
    GoRoute(
      path: '/orphan/:id',
      builder: (context, state) {
        final orphanId = state.pathParameters['id']!;
        return AppLayout(
          currentRoute: '/orphan/$orphanId',
          child: OrphanDetailsPage(orphanId: orphanId),
        );
      },
    ),
    GoRoute(
      path: '/supervisor/:id/orphans',
      builder: (context, state) {
        final supervisorId = state.pathParameters['id']!;
        return AppLayout(
          currentRoute: '/supervisor/$supervisorId/orphans',
          child: SupervisorOrphansPage(supervisorId: supervisorId),
        );
      },
    ),
  ],
);

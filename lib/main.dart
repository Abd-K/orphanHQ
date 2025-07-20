import 'package:flutter/material.dart';
import 'package:orphan_hq/database.dart';
import 'package:orphan_hq/repositories/orphan_repository.dart';
import 'package:orphan_hq/repositories/supervisor_repository.dart';
import 'package:orphan_hq/services/local_api_server.dart';
import 'package:orphan_hq/router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<AppDb>(
          create: (_) => AppDb(),
          dispose: (context, db) => db.close(),
        ),
        ProxyProvider<AppDb, OrphanRepository>(
          update: (context, db, previous) => OrphanRepository(db),
        ),
        ProxyProvider<AppDb, SupervisorRepository>(
          update: (context, db, previous) => SupervisorRepository(db),
        ),
        ProxyProvider2<OrphanRepository, SupervisorRepository, LocalApiServer>(
          update: (context, orphanRepo, supervisorRepo, previous) =>
              LocalApiServer(
            orphanRepository: orphanRepo,
            supervisorRepository: supervisorRepo,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Start the API server after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startApiServer();
    });
  }

  Future<void> _startApiServer() async {
    try {
      final server = context.read<LocalApiServer>();
      final tunnelResult = await server.start();
      print('Server started: ${tunnelResult.primaryUrl}');
    } catch (e) {
      print('Failed to start API server: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Orphan HQ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Disable all page transitions globally
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: InstantPageTransitionsBuilder(),
            TargetPlatform.iOS: InstantPageTransitionsBuilder(),
            TargetPlatform.linux: InstantPageTransitionsBuilder(),
            TargetPlatform.macOS: InstantPageTransitionsBuilder(),
            TargetPlatform.windows: InstantPageTransitionsBuilder(),
          },
        ),
      ),
    );
  }
}

// Custom page transition that shows content instantly without any animation
class InstantPageTransitionsBuilder extends PageTransitionsBuilder {
  const InstantPageTransitionsBuilder();

  @override
  Widget buildTransitions<T extends Object?>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Return the child directly without any transition animation
    return child;
  }
}

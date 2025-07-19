import 'package:flutter/material.dart';
import 'package:orphan_hq/database.dart';
import 'package:orphan_hq/repositories/orphan_repository.dart';
import 'package:orphan_hq/repositories/supervisor_repository.dart';
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
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Orphan HQ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

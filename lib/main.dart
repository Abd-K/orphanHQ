import 'package:flutter/material.dart';
import 'package:orphan_hq/database.dart';
import 'package:orphan_hq/repositories/orphan_repository.dart';
import 'package:orphan_hq/repositories/supervisor_repository.dart';
import 'package:orphan_hq/services/local_api_server.dart';
import 'package:orphan_hq/router.dart';
import 'package:orphan_hq/pages/settings_page.dart';
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
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
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
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          routerConfig: router,
          title: 'Orphan HQ',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            cardTheme: CardTheme(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey[300]!),
              ),
            ),
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
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            scaffoldBackgroundColor:
                const Color(0xFF0D1117), // Much darker background
            cardTheme: CardTheme(
              elevation: 0,
              color: const Color(0xFF161B22), // Darker card color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(
                    color: Color(0xFF21262D)), // Darker borders
              ),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF161B22),
              foregroundColor:
                  Color(0xFFFFFFFF), // Pure white for better contrast
              elevation: 0,
            ),
            drawerTheme: const DrawerThemeData(
              backgroundColor: Color(0xFF161B22),
            ),
            listTileTheme: const ListTileThemeData(
              textColor: Color(0xFFFFFFFF), // Pure white for better contrast
              iconColor:
                  Color(0xFFE6EDF3), // Lighter gray for better icon visibility
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(
                  color: Color(0xFFFFFFFF)), // Pure white for better contrast
              bodyMedium: TextStyle(
                  color: Color(0xFFFFFFFF)), // Pure white for better contrast
              bodySmall: TextStyle(
                  color:
                      Color(0xFFE6EDF3)), // Lighter gray for better readability
              headlineLarge: TextStyle(
                  color: Color(0xFFFFFFFF)), // Pure white for headings
              headlineMedium: TextStyle(
                  color: Color(0xFFFFFFFF)), // Pure white for headings
              headlineSmall: TextStyle(
                  color: Color(0xFFFFFFFF)), // Pure white for headings
              titleLarge:
                  TextStyle(color: Color(0xFFFFFFFF)), // Pure white for titles
              titleMedium:
                  TextStyle(color: Color(0xFFFFFFFF)), // Pure white for titles
              titleSmall:
                  TextStyle(color: Color(0xFFFFFFFF)), // Pure white for titles
              labelLarge:
                  TextStyle(color: Color(0xFFFFFFFF)), // Pure white for labels
              labelMedium: TextStyle(
                  color: Color(0xFFE6EDF3)), // Lighter gray for better contrast
              labelSmall: TextStyle(
                  color: Color(0xFFE6EDF3)), // Lighter gray for better contrast
            ),
            iconTheme: const IconThemeData(
              color:
                  Color(0xFFE6EDF3), // Lighter gray for better icon visibility
            ),
            // Improved text button styling for better contrast
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    const Color(0xFF58A6FF), // Better blue for text buttons
              ),
            ),
            dividerColor: const Color(0xFF21262D),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF238636), // Better green for primary actions
                foregroundColor:
                    const Color(0xFFFFFFFF), // Pure white text on buttons
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(
                    0xFFE6EDF3), // Better contrast for outlined buttons
                side: const BorderSide(color: Color(0xFF21262D)),
              ),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              labelStyle:
                  TextStyle(color: Color(0xFFE6EDF3)), // Better label contrast
              hintStyle: TextStyle(
                  color: Color(0xFFE6EDF3)), // Better hint text contrast
              helperStyle: TextStyle(
                  color: Color(0xFFE6EDF3)), // Better helper text contrast
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF30363D)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF30363D)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF58A6FF), width: 2),
              ),
              filled: true,
              fillColor: Color(0xFF21262D), // Better background for form fields
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF30363D)),
              ),
            ),
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Color(0xFF58A6FF), // Better cursor color
              selectionColor: Color(0xFF58A6FF), // Better text selection color
              selectionHandleColor:
                  Color(0xFF58A6FF), // Better selection handle color
            ),
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
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        );
      },
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

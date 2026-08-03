import 'package:flutter/material.dart';

import '../features/dashboard/presentation/dashboard_screen.dart';
import 'providers.dart';

class SubscriptionTrackerApp extends StatelessWidget {
  const SubscriptionTrackerApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Düzenli Ödemelerim',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff315c48)),
      useMaterial3: true,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    ),
    home: DashboardScreen(controllerProvider: dashboardControllerProvider),
  );
}

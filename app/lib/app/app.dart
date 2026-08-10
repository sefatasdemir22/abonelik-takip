import 'package:flutter/material.dart';

import 'app_shell.dart';

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
    home: const AppShell(),
  );
}

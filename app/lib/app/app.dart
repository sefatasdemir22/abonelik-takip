import 'package:flutter/material.dart';

import 'app_shell.dart';
import 'app_theme.dart';

class SubscriptionTrackerApp extends StatefulWidget {
  const SubscriptionTrackerApp({super.key});

  @override
  State<SubscriptionTrackerApp> createState() => _SubscriptionTrackerAppState();
}

class _SubscriptionTrackerAppState extends State<SubscriptionTrackerApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Düzenli Ödemelerim',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: _themeMode,
    themeAnimationDuration: Duration.zero,
    home: AppShell(
      themeMode: _themeMode,
      onThemeModeChanged: (mode) => setState(() => _themeMode = mode),
    ),
  );
}

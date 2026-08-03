import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/notifications/domain/notification_scheduler.dart';
import '../integrations/notifications/android_notification_scheduler.dart';
import '../integrations/security/android_database_key_store.dart';
import 'app.dart';
import 'providers.dart';

Future<void> bootstrap({NotificationScheduler? notificationScheduler}) async {
  WidgetsFlutterBinding.ensureInitialized();
  final scheduler = notificationScheduler ?? AndroidNotificationScheduler();
  final databaseKeyStore = AndroidDatabaseKeyStore();
  final databaseKey = await databaseKeyStore.readOrCreateDatabaseKey();
  await scheduler.initialize();
  runApp(
    ProviderScope(
      overrides: [
        notificationSchedulerProvider.overrideWithValue(scheduler),
        databaseKeyStoreProvider.overrideWithValue(databaseKeyStore),
        databaseKeyProvider.overrideWithValue(databaseKey),
      ],
      child: const SubscriptionTrackerApp(),
    ),
  );
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/domain/app_clock.dart';
import '../core/persistence/app_database.dart';
import '../core/security/database_key_store.dart';
import '../features/dashboard/presentation/dashboard_controller.dart';
import '../features/notifications/domain/notification_scheduler.dart';
import '../features/payment_occurrences/data/drift_payment_occurrence_repository.dart';
import '../features/payment_occurrences/domain/payment_occurrence_repository.dart';
import '../features/recurring_payments/data/drift_recurring_payment_repository.dart';
import '../features/recurring_payments/domain/recurring_payment_repository.dart';
import '../integrations/notifications/android_notification_scheduler.dart';
import '../integrations/security/android_database_key_store.dart';

final databaseKeyStoreProvider = Provider<DatabaseKeyStore>(
  (ref) => AndroidDatabaseKeyStore(),
);

final databaseKeyProvider = Provider<String>(
  (ref) =>
      throw StateError('Veritabanı anahtarı bootstrap sırasında sağlanmalı.'),
);

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase.encrypted(ref.watch(databaseKeyProvider));
  ref.onDispose(database.close);
  return database;
});

final clockProvider = Provider<AppClock>((ref) => const SystemAppClock());

final recurringPaymentRepositoryProvider = Provider<RecurringPaymentRepository>(
  (ref) => DriftRecurringPaymentRepository(ref.watch(databaseProvider)),
);

final occurrenceRepositoryProvider = Provider<PaymentOccurrenceRepository>(
  (ref) => DriftPaymentOccurrenceRepository(
    ref.watch(databaseProvider),
    ref.watch(recurringPaymentRepositoryProvider),
  ),
);

final notificationSchedulerProvider = Provider<NotificationScheduler>(
  (ref) => AndroidNotificationScheduler(),
);

final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, DashboardState>(
      (ref) => DashboardController(
        ref.watch(recurringPaymentRepositoryProvider),
        ref.watch(occurrenceRepositoryProvider),
        ref.watch(notificationSchedulerProvider),
        ref.watch(clockProvider),
      )..load(),
    );

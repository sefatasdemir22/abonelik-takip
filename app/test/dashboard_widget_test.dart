import 'package:abonelik_takip/app/app.dart';
import 'package:abonelik_takip/app/providers.dart';
import 'package:abonelik_takip/core/domain/app_clock.dart';
import 'package:abonelik_takip/core/domain/billing_schedule.dart';
import 'package:abonelik_takip/core/domain/local_date.dart';
import 'package:abonelik_takip/core/persistence/app_database.dart';
import 'package:abonelik_takip/features/notifications/domain/notification_scheduler.dart';
import 'package:abonelik_takip/features/recurring_payments/domain/recurring_payment.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('eklenen ödeme dashboard Sıradaki kartında görünür', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final scheduler = _FakeNotificationScheduler();
    final clock = FakeAppClock(DateTime(2026, 8, 3, 12));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          notificationSchedulerProvider.overrideWithValue(scheduler),
          clockProvider.overrideWithValue(clock),
        ],
        child: const SubscriptionTrackerApp(),
      ),
    );
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(SubscriptionTrackerApp)),
    );
    await container
        .read(dashboardControllerProvider.notifier)
        .addPayment(
          name: 'Spotify',
          amountMinor: 5999,
          currencyCode: 'TRY',
          nextPaymentDate: LocalDate(2026, 8, 15),
          category: SystemCategory.entertainment,
          billingCadence: BillingCadence.monthly,
          paymentMethodNickname: 'Bonus kart',
        );
    await tester.pumpAndSettle();

    expect(find.text('Sıradaki'), findsOneWidget);
    expect(find.text('Spotify'), findsNWidgets(2));
    expect(find.textContaining('59,99 TRY'), findsNWidgets(2));
    expect(scheduler.scheduledNames, ['Spotify']);
    expect(scheduler.permissionRequested, isTrue);
  });

  testWidgets('ödeme ekleme formu çekirdek alanları gösterir', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          notificationSchedulerProvider.overrideWithValue(
            _FakeNotificationScheduler(),
          ),
          clockProvider.overrideWithValue(
            FakeAppClock(DateTime(2026, 8, 3, 12)),
          ),
        ],
        child: const SubscriptionTrackerApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ödeme ekle'));
    await tester.pumpAndSettle();

    expect(find.text('Düzenli ödeme ekle'), findsOneWidget);
    expect(find.byKey(const Key('payment-name')), findsOneWidget);
    expect(find.byKey(const Key('payment-amount')), findsOneWidget);
    expect(find.byKey(const Key('payment-currency')), findsOneWidget);
    expect(find.text('Tutar'), findsOneWidget);
    expect(find.text('Aylık'), findsOneWidget);
    expect(find.text('Yıllık'), findsOneWidget);
    final cadenceSelector = tester.widget<SegmentedButton<BillingCadence>>(
      find.byType(SegmentedButton<BillingCadence>),
    );
    expect(cadenceSelector.selected, {BillingCadence.monthly});
    expect(find.text('Sonraki ödeme tarihi'), findsOneWidget);
  });
}

final class _FakeNotificationScheduler implements NotificationScheduler {
  bool permissionRequested = false;
  final List<String> scheduledNames = [];

  @override
  Future<void> cancelForOccurrence(String recurringPaymentId) async {}

  @override
  Future<void> initialize() async {}

  @override
  Future<void> requestPermission() async => permissionRequested = true;

  @override
  Future<void> scheduleFor(RecurringPayment payment) async {
    scheduledNames.add(payment.name);
  }
}

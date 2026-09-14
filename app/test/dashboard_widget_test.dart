import 'package:abonelik_takip/app/app.dart';
import 'package:abonelik_takip/app/providers.dart';
import 'package:abonelik_takip/core/domain/app_clock.dart';
import 'package:abonelik_takip/core/domain/billing_schedule.dart';
import 'package:abonelik_takip/core/domain/local_date.dart';
import 'package:abonelik_takip/core/persistence/app_database.dart';
import 'package:abonelik_takip/features/dashboard/presentation/dashboard_controller.dart';
import 'package:abonelik_takip/features/payment_occurrences/data/drift_payment_occurrence_repository.dart';
import 'package:abonelik_takip/features/recurring_payments/data/drift_recurring_payment_repository.dart';
import 'package:abonelik_takip/features/notifications/domain/notification_scheduler.dart';
import 'package:abonelik_takip/features/recurring_payments/domain/recurring_payment.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('dashboard reminder repair', () {
    late AppDatabase database;
    late DriftRecurringPaymentRepository repository;
    late DashboardController controller;
    late _FakeNotificationScheduler scheduler;

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
      repository = DriftRecurringPaymentRepository(database);
      scheduler = _FakeNotificationScheduler();
      controller = DashboardController(
        repository,
        DriftPaymentOccurrenceRepository(database, repository),
        scheduler,
        FakeAppClock(DateTime(2026, 8, 3, 12)),
      );
    });

    tearDown(() async {
      controller.dispose();
      await database.close();
    });

    for (final paid in [true, false]) {
      test(
        'load repairs next cycle after ${paid ? "paid" : "skipped"}',
        () async {
          await repository.add(_payment('Spotify', LocalDate(2026, 8, 3)));
          await controller.load();

          final nextDate = LocalDate(2026, 9, 3);
          expect(controller.state.error, isNull);
          expect(controller.state.payments.single.nextPaymentDate, nextDate);
          expect(scheduler.scheduledPayments.single.nextPaymentDate, nextDate);
          expect(scheduler.events, ['schedule:Spotify']);
          expect(scheduler.permissionRequested, isFalse);

          final occurrence = controller.state.awaiting.single;
          if (paid) {
            await controller.markPaid(occurrence);
          } else {
            await controller.markSkipped(occurrence);
          }

          expect(controller.state.awaiting, isEmpty);
          expect(scheduler.events, [
            'schedule:Spotify',
            'cancel:Spotify',
            'schedule:Spotify',
          ]);
          expect(scheduler.scheduledPayments.last.nextPaymentDate, nextDate);
          expect(scheduler.permissionRequested, isFalse);
        },
      );
    }

    test(
      'one scheduling failure does not block data or other payments',
      () async {
        await repository.add(_payment('Spotify', LocalDate(2026, 8, 10)));
        await repository.add(_payment('Netflix', LocalDate(2026, 8, 15)));
        scheduler.failForId = 'Spotify';

        await controller.load();

        expect(controller.state.loading, isFalse);
        expect(controller.state.error, isNull);
        expect(controller.state.payments, hasLength(2));
        expect(controller.state.summaries.single.remainingPlannedMinor, 11998);
        expect(scheduler.events, ['schedule:Spotify', 'schedule:Netflix']);
        expect(scheduler.permissionRequested, isFalse);
      },
    );
  });

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
    await container.read(addRecurringPaymentProvider)(
      name: 'Spotify',
      amountMinor: 5999,
      currencyCode: 'TRY',
      nextPaymentDate: LocalDate(2026, 8, 15),
      category: SystemCategory.entertainment,
      billingCadence: BillingCadence.monthly,
      paymentMethodNickname: 'Bonus kart',
    );
    await container.read(dashboardControllerProvider.notifier).load();
    await tester.pumpAndSettle();

    expect(find.text('Sıradaki ödeme'), findsOneWidget);
    expect(find.text('Spotify'), findsOneWidget);
    expect(find.textContaining('59,99 TRY'), findsNWidgets(2));
    expect(scheduler.scheduledNames, ['Spotify', 'Spotify']);
    expect(scheduler.permissionRequested, isTrue);
  });

  testWidgets('Aboneliklerimden eklenen ödeme Ana Sayfada görünür', (
    tester,
  ) async {
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
    await tester.tap(find.text('Aboneliklerim'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Abonelik ekle'));
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

    await tester.enterText(
      find.byKey(const Key('payment-name')),
      'YouTube Premium',
    );
    await tester.enterText(find.byKey(const Key('payment-amount')), '79,99');
    await tester.ensureVisible(find.text('Sonraki ödeme tarihi'));
    await tester.tap(find.text('Sonraki ödeme tarihi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('15').last);
    await tester.tap(
      find
          .descendant(
            of: find.byType(DatePickerDialog),
            matching: find.byType(TextButton),
          )
          .last,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-payment')));
    await tester.pumpAndSettle();

    expect(find.text('Düzenli ödeme ekle'), findsNothing);
    await tester.tap(find.text('Ana Sayfa'));
    await tester.pumpAndSettle();
    expect(find.text('YouTube Premium'), findsOneWidget);
  });

  testWidgets('uygulama shell ana sekmeler arasinda gecis yapar', (
    tester,
  ) async {
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

    expect(find.text('Ana Sayfa'), findsNWidgets(2));
    expect(find.text('Aboneliklerim'), findsOneWidget);
    expect(find.text('Ailem'), findsNWidgets(2));
    expect(find.text('Hesaplaşma'), findsNWidgets(2));
    expect(find.text('Profil'), findsOneWidget);
    expect(find.text('Analiz'), findsOneWidget);

    await tester.tap(find.text('Aboneliklerim'));
    await tester.pumpAndSettle();
    expect(find.text('Kişisel aboneliklerin'), findsOneWidget);
    expect(find.text('Paylaşılan'), findsOneWidget);

    await tester.tap(find.text('Ana Sayfa'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Analiz'));
    await tester.pumpAndSettle();
    expect(find.text('Aylık görünüm'), findsOneWidget);
    expect(find.text('Kategori dağılımı'), findsOneWidget);
  });
}

final class _FakeNotificationScheduler implements NotificationScheduler {
  bool permissionRequested = false;
  final List<String> scheduledNames = [];
  final List<RecurringPayment> scheduledPayments = [];
  final List<String> events = [];
  String? failForId;

  @override
  Future<void> cancelForOccurrence(String recurringPaymentId) async {
    events.add('cancel:$recurringPaymentId');
  }

  @override
  Future<void> initialize() async {}

  @override
  Future<void> requestPermission() async => permissionRequested = true;

  @override
  Future<void> scheduleFor(RecurringPayment payment) async {
    scheduledNames.add(payment.name);
    scheduledPayments.add(payment);
    events.add('schedule:${payment.id}');
    if (payment.id == failForId) throw StateError('Scheduling failed');
  }
}

RecurringPayment _payment(String id, LocalDate date) => RecurringPayment(
  id: id,
  name: id,
  amountMinor: 5999,
  currencyCode: 'TRY',
  nextPaymentDate: date,
  billingSchedule: BillingSchedule.monthly(day: date.day),
  category: SystemCategory.entertainment,
  createdAtUtc: DateTime.utc(2026, 8, 1),
);

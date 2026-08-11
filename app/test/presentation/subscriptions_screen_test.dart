import 'package:abonelik_takip/core/domain/app_clock.dart';
import 'package:abonelik_takip/core/domain/billing_schedule.dart';
import 'package:abonelik_takip/core/domain/local_date.dart';
import 'package:abonelik_takip/features/notifications/domain/notification_scheduler.dart';
import 'package:abonelik_takip/features/recurring_payments/application/add_recurring_payment.dart';
import 'package:abonelik_takip/features/recurring_payments/application/get_active_recurring_payments.dart';
import 'package:abonelik_takip/features/recurring_payments/domain/recurring_payment.dart';
import 'package:abonelik_takip/features/recurring_payments/domain/recurring_payment_repository.dart';
import 'package:abonelik_takip/features/subscriptions/presentation/subscriptions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('empty result kişisel empty state gösterir', (tester) async {
    await tester.pumpWidget(_appWith(const []));
    await tester.pumpAndSettle();

    expect(find.text('Kişisel aboneliklerin'), findsOneWidget);
  });

  testWidgets('gerçek abonelik bilgilerini cadence ile gösterir', (
    tester,
  ) async {
    await tester.pumpWidget(
      _appWith([
        _payment(
          id: 'netflix',
          name: 'Netflix',
          amountMinor: 22999,
          currencyCode: 'TRY',
          date: LocalDate(2026, 8, 15),
          schedule: BillingSchedule.monthly(day: 15),
        ),
        _payment(
          id: 'cloud',
          name: 'Cloud',
          amountMinor: 999,
          currencyCode: 'USD',
          date: LocalDate(2026, 12, 2),
          schedule: BillingSchedule.yearly(month: 12, day: 2),
        ),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.text('Netflix'), findsOneWidget);
    expect(find.text('229,99 TRY'), findsOneWidget);
    expect(find.text('15 Ağu 2026'), findsOneWidget);
    expect(find.text('Aylık'), findsOneWidget);
    expect(find.text('Cloud'), findsOneWidget);
    expect(find.text('9,99 USD'), findsOneWidget);
    expect(find.text('2 Ara 2026'), findsOneWidget);
    expect(find.text('Yıllık'), findsOneWidget);
    expect(find.textContaining('Toplam'), findsNothing);
  });

  testWidgets('paylaşılan sekmede kişisel ekleme FAB gizlenir', (tester) async {
    await tester.pumpWidget(_appWith(const []));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Paylaşılan'));
    await tester.pumpAndSettle();

    expect(find.text('Abonelik ekle'), findsNothing);
  });
}

Widget _appWith(List<RecurringPayment> payments) {
  final repository = _FakeRepository(payments);
  return MaterialApp(
    home: SubscriptionsScreen(
      addRecurringPayment: AddRecurringPayment(
        repository,
        _FakeNotificationScheduler(),
        FakeAppClock(DateTime.utc(2026, 8, 1)),
      ),
      getActiveRecurringPayments: GetActiveRecurringPayments(repository),
      onPaymentAdded: () async {},
    ),
  );
}

RecurringPayment _payment({
  required String id,
  required String name,
  required int amountMinor,
  required String currencyCode,
  required LocalDate date,
  required BillingSchedule schedule,
}) => RecurringPayment(
  id: id,
  name: name,
  amountMinor: amountMinor,
  currencyCode: currencyCode,
  nextPaymentDate: date,
  billingSchedule: schedule,
  category: SystemCategory.entertainment,
  createdAtUtc: DateTime.utc(2026, 8, 1),
);

final class _FakeRepository implements RecurringPaymentRepository {
  _FakeRepository(this.payments);

  final List<RecurringPayment> payments;

  @override
  Future<List<RecurringPayment>> getActive() async => payments;

  @override
  Future<void> add(RecurringPayment payment) async {}

  @override
  Future<void> updateNextPaymentDate(String id, String nextDateIso) async {}
}

final class _FakeNotificationScheduler implements NotificationScheduler {
  @override
  Future<void> cancelForOccurrence(String recurringPaymentId) async {}

  @override
  Future<void> initialize() async {}

  @override
  Future<void> requestPermission() async {}

  @override
  Future<void> scheduleFor(RecurringPayment payment) async {}
}

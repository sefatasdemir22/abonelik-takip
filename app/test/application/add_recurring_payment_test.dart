import 'package:abonelik_takip/core/domain/app_clock.dart';
import 'package:abonelik_takip/core/domain/billing_schedule.dart';
import 'package:abonelik_takip/core/domain/local_date.dart';
import 'package:abonelik_takip/features/notifications/domain/notification_scheduler.dart';
import 'package:abonelik_takip/features/recurring_payments/application/add_recurring_payment.dart';
import 'package:abonelik_takip/features/recurring_payments/domain/recurring_payment.dart';
import 'package:abonelik_takip/features/recurring_payments/domain/recurring_payment_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _FakeRecurringPaymentRepository repository;
  late _FakeNotificationScheduler notifications;
  late AddRecurringPayment addRecurringPayment;

  setUp(() {
    repository = _FakeRecurringPaymentRepository();
    notifications = _FakeNotificationScheduler();
    addRecurringPayment = AddRecurringPayment(
      repository,
      notifications,
      FakeAppClock(DateTime.utc(2026, 8, 1)),
    );
  });

  test('monthly recurring payment eklenir ve notification planlanir', () async {
    final payment = await addRecurringPayment(
      name: ' Spotify ',
      amountMinor: 5999,
      currencyCode: ' try ',
      nextPaymentDate: LocalDate(2026, 8, 15),
      category: SystemCategory.entertainment,
      billingCadence: BillingCadence.monthly,
    );

    expect(repository.added, same(payment));
    expect(payment.name, 'Spotify');
    expect(payment.currencyCode, 'TRY');
    expect(payment.billingSchedule, BillingSchedule.monthly(day: 15));
    expect(notifications.permissionRequested, isTrue);
    expect(notifications.scheduled, same(payment));
  });

  test('yearly recurring payment month ve day anchor ile eklenir', () async {
    final payment = await addRecurringPayment(
      name: 'Yıllık plan',
      amountMinor: 12990,
      currencyCode: 'TRY',
      nextPaymentDate: LocalDate(2026, 8, 31),
      category: SystemCategory.software,
      billingCadence: BillingCadence.yearly,
    );

    expect(payment.billingSchedule.cadence, BillingCadence.yearly);
    expect(payment.billingSchedule.anchorMonth, 8);
    expect(payment.billingSchedule.anchorDay, 31);
    expect(repository.added, same(payment));
    expect(notifications.scheduled, same(payment));
  });
}

final class _FakeRecurringPaymentRepository
    implements RecurringPaymentRepository {
  RecurringPayment? added;

  @override
  Future<void> add(RecurringPayment payment) async => added = payment;

  @override
  Future<List<RecurringPayment>> getActive() async => const [];

  @override
  Future<void> updateNextPaymentDate(String id, String nextDateIso) async {}
}

final class _FakeNotificationScheduler implements NotificationScheduler {
  bool permissionRequested = false;
  RecurringPayment? scheduled;

  @override
  Future<void> cancelForOccurrence(String recurringPaymentId) async {}

  @override
  Future<void> initialize() async {}

  @override
  Future<void> requestPermission() async => permissionRequested = true;

  @override
  Future<void> scheduleFor(RecurringPayment payment) async =>
      scheduled = payment;
}

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
    final result = await addRecurringPayment(
      name: ' Spotify ',
      amountMinor: 5999,
      currencyCode: ' try ',
      nextPaymentDate: LocalDate(2026, 8, 15),
      category: SystemCategory.entertainment,
      billingCadence: BillingCadence.monthly,
    );

    final payment = result.payment;
    expect(repository.added, same(payment));
    expect(payment.name, 'Spotify');
    expect(payment.currencyCode, 'TRY');
    expect(payment.billingSchedule, BillingSchedule.monthly(day: 15));
    expect(notifications.permissionRequested, isTrue);
    expect(notifications.scheduled, same(payment));
    expect(result.notificationFailed, isFalse);
  });

  test('yearly recurring payment month ve day anchor ile eklenir', () async {
    final result = await addRecurringPayment(
      name: 'Yıllık plan',
      amountMinor: 12990,
      currencyCode: 'TRY',
      nextPaymentDate: LocalDate(2026, 8, 31),
      category: SystemCategory.software,
      billingCadence: BillingCadence.yearly,
    );

    final payment = result.payment;
    expect(payment.billingSchedule.cadence, BillingCadence.yearly);
    expect(payment.billingSchedule.anchorMonth, 8);
    expect(payment.billingSchedule.anchorDay, 31);
    expect(repository.added, same(payment));
    expect(notifications.scheduled, same(payment));
  });

  test('repository failure creation failure olarak yayılır', () async {
    repository.addError = StateError('database unavailable');

    await expectLater(_add(addRecurringPayment), throwsA(isA<StateError>()));

    expect(repository.addCalls, 1);
    expect(notifications.permissionRequested, isFalse);
    expect(notifications.scheduled, isNull);
  });

  test('notification failure persistence sonrası başarılı sonuçtur', () async {
    notifications.scheduleError = StateError('notifications unavailable');

    final result = await _add(addRecurringPayment);

    expect(result.notificationFailed, isTrue);
    expect(repository.addCalls, 1);
    expect(repository.added, same(result.payment));
  });

  test('permission failure persistence sonrası başarılı sonuçtur', () async {
    notifications.permissionError = StateError('permission unavailable');

    final result = await _add(addRecurringPayment);

    expect(result.notificationFailed, isTrue);
    expect(repository.addCalls, 1);
    expect(repository.added, same(result.payment));
    expect(notifications.scheduled, isNull);
  });
}

Future<AddRecurringPaymentResult> _add(AddRecurringPayment useCase) => useCase(
  name: 'Spotify',
  amountMinor: 5999,
  currencyCode: 'TRY',
  nextPaymentDate: LocalDate(2026, 8, 15),
  category: SystemCategory.entertainment,
  billingCadence: BillingCadence.monthly,
);

final class _FakeRecurringPaymentRepository
    implements RecurringPaymentRepository {
  RecurringPayment? added;
  Object? addError;
  int addCalls = 0;

  @override
  Future<void> add(RecurringPayment payment) async {
    addCalls++;
    if (addError case final error?) throw error;
    added = payment;
  }

  @override
  Future<List<RecurringPayment>> getActive() async => const [];

  @override
  Future<void> updateNextPaymentDate(String id, String nextDateIso) async {}
}

final class _FakeNotificationScheduler implements NotificationScheduler {
  bool permissionRequested = false;
  RecurringPayment? scheduled;
  Object? permissionError;
  Object? scheduleError;

  @override
  Future<void> cancelForOccurrence(String recurringPaymentId) async {}

  @override
  Future<void> initialize() async {}

  @override
  Future<void> requestPermission() async {
    permissionRequested = true;
    if (permissionError case final error?) throw error;
  }

  @override
  Future<void> scheduleFor(RecurringPayment payment) async {
    if (scheduleError case final error?) throw error;
    scheduled = payment;
  }
}

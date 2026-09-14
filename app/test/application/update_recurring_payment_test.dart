import 'package:abonelik_takip/core/domain/billing_schedule.dart';
import 'package:abonelik_takip/core/domain/local_date.dart';
import 'package:abonelik_takip/features/notifications/domain/notification_scheduler.dart';
import 'package:abonelik_takip/features/recurring_payments/application/update_recurring_payment.dart';
import 'package:abonelik_takip/features/recurring_payments/domain/recurring_payment.dart';
import 'package:abonelik_takip/features/recurring_payments/domain/recurring_payment_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _FakeRepository repository;
  late _FakeNotifications notifications;
  late UpdateRecurringPayment update;

  setUp(() {
    repository = _FakeRepository();
    notifications = _FakeNotifications();
    update = UpdateRecurringPayment(repository, notifications);
  });

  test('full edit preserves identity and reschedules notification', () async {
    final existing = _payment();

    final result = await _update(
      update,
      existing: existing,
      currencyCode: ' usd ',
      nextPaymentDate: LocalDate(2026, 9, 30),
      category: SystemCategory.software,
      paymentMethodNickname: ' Bonus ',
    );

    final payment = result.payment;
    expect(payment.id, existing.id);
    expect(payment.createdAtUtc, existing.createdAtUtc);
    expect(payment.active, existing.active);
    expect(payment.name, 'Yeni ad');
    expect(payment.amountMinor, 7999);
    expect(payment.currencyCode, 'USD');
    expect(payment.nextPaymentDate, LocalDate(2026, 9, 30));
    expect(payment.category, SystemCategory.software);
    expect(payment.paymentMethodNickname, 'Bonus');
    expect(repository.updateCalls, 1);
    expect(repository.updated, same(payment));
    expect(notifications.permissionRequested, isFalse);
    expect(notifications.cancelledIds, [existing.id]);
    expect(notifications.scheduled, [same(payment)]);
    expect(result.notificationFailed, isFalse);
  });

  test('monthly schedule uses new date day as anchor', () async {
    final result = await _update(
      update,
      existing: _payment(),
      nextPaymentDate: LocalDate(2026, 9, 30),
    );

    expect(result.payment.billingSchedule.cadence, BillingCadence.monthly);
    expect(result.payment.billingSchedule.anchorDay, 30);
  });

  test('yearly schedule uses new date month and day as anchor', () async {
    final result = await _update(
      update,
      existing: _payment(),
      nextPaymentDate: LocalDate(2026, 10, 15),
      billingCadence: BillingCadence.yearly,
    );

    expect(result.payment.billingSchedule.cadence, BillingCadence.yearly);
    expect(result.payment.billingSchedule.anchorMonth, 10);
    expect(result.payment.billingSchedule.anchorDay, 15);
  });

  test('repository failure skips notification operations', () async {
    repository.error = StateError('database unavailable');

    await expectLater(
      _update(update, existing: _payment()),
      throwsA(isA<StateError>()),
    );

    expect(repository.updateCalls, 1);
    expect(notifications.cancelledIds, isEmpty);
    expect(notifications.scheduled, isEmpty);
  });

  test(
    'cancel failure still attempts schedule and returns partial success',
    () async {
      notifications.cancelError = StateError('cancel unavailable');

      final result = await _update(update, existing: _payment());

      expect(repository.updateCalls, 1);
      expect(notifications.scheduled, hasLength(1));
      expect(result.notificationFailed, isTrue);
    },
  );

  test('schedule failure returns partial success', () async {
    notifications.scheduleError = StateError('schedule unavailable');

    final result = await _update(update, existing: _payment());

    expect(repository.updateCalls, 1);
    expect(result.notificationFailed, isTrue);
  });

  test('blank payment method clears existing nickname', () async {
    final existing = _payment(paymentMethodNickname: 'Bonus');

    final result = await _update(
      update,
      existing: existing,
      paymentMethodNickname: '   ',
    );

    expect(result.payment.paymentMethodNickname, isNull);
    expect(repository.updated?.paymentMethodNickname, isNull);
  });

  test(
    'legacy currency can remain but cannot change to unsupported code',
    () async {
      final legacy = _payment(currencyCode: 'CHF');

      final unchanged = await _update(
        update,
        existing: legacy,
        currencyCode: ' chf ',
      );
      expect(unchanged.payment.currencyCode, 'CHF');
      expect(repository.updateCalls, 1);
      expect(notifications.cancelledIds, [legacy.id]);
      expect(notifications.scheduled, hasLength(1));

      await expectLater(
        _update(update, existing: legacy, currencyCode: 'ABC'),
        throwsArgumentError,
      );
      expect(repository.updateCalls, 1);
      expect(notifications.cancelledIds, [legacy.id]);
      expect(notifications.scheduled, hasLength(1));
    },
  );

  test('supported currency cannot change to unsupported code', () async {
    await expectLater(
      _update(update, existing: _payment(), currencyCode: 'ABC'),
      throwsArgumentError,
    );

    expect(repository.updateCalls, 0);
    expect(notifications.cancelledIds, isEmpty);
    expect(notifications.scheduled, isEmpty);
  });
}

Future<UpdateRecurringPaymentResult> _update(
  UpdateRecurringPayment useCase, {
  required RecurringPayment existing,
  String currencyCode = 'TRY',
  LocalDate? nextPaymentDate,
  BillingCadence billingCadence = BillingCadence.monthly,
  SystemCategory category = SystemCategory.entertainment,
  String? paymentMethodNickname,
}) => useCase(
  existing: existing,
  name: ' Yeni ad ',
  amountMinor: 7999,
  currencyCode: currencyCode,
  nextPaymentDate: nextPaymentDate ?? LocalDate(2026, 8, 20),
  category: category,
  billingCadence: billingCadence,
  paymentMethodNickname: paymentMethodNickname,
);

RecurringPayment _payment({
  String currencyCode = 'TRY',
  String? paymentMethodNickname,
}) => RecurringPayment(
  id: 'payment-id',
  name: 'Eski ad',
  amountMinor: 5999,
  currencyCode: currencyCode,
  nextPaymentDate: LocalDate(2026, 8, 15),
  billingSchedule: BillingSchedule.monthly(day: 15),
  paymentMethodNickname: paymentMethodNickname,
  category: SystemCategory.entertainment,
  active: false,
  createdAtUtc: DateTime.utc(2026, 7, 1),
);

final class _FakeRepository implements RecurringPaymentRepository {
  int updateCalls = 0;
  RecurringPayment? updated;
  Object? error;

  @override
  Future<void> update(RecurringPayment payment) async {
    updateCalls++;
    if (error case final value?) throw value;
    updated = payment;
  }

  @override
  Future<void> add(RecurringPayment payment) async {}

  @override
  Future<List<RecurringPayment>> getActive() async => const [];

  @override
  Future<void> updateNextPaymentDate(String id, String nextDateIso) async {}
}

final class _FakeNotifications implements NotificationScheduler {
  bool permissionRequested = false;
  final List<String> cancelledIds = [];
  final List<RecurringPayment> scheduled = [];
  Object? cancelError;
  Object? scheduleError;

  @override
  Future<void> cancelForOccurrence(String recurringPaymentId) async {
    cancelledIds.add(recurringPaymentId);
    if (cancelError case final error?) throw error;
  }

  @override
  Future<void> initialize() async {}

  @override
  Future<void> requestPermission() async => permissionRequested = true;

  @override
  Future<void> scheduleFor(RecurringPayment payment) async {
    scheduled.add(payment);
    if (scheduleError case final error?) throw error;
  }
}

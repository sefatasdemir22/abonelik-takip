import 'package:uuid/uuid.dart';

import '../../../core/domain/app_clock.dart';
import '../../../core/domain/billing_schedule.dart';
import '../../../core/domain/local_date.dart';
import '../../notifications/domain/notification_scheduler.dart';
import '../domain/recurring_payment.dart';
import '../domain/recurring_payment_repository.dart';

final class AddRecurringPayment {
  AddRecurringPayment(
    this._repository,
    this._notifications,
    this._clock, {
    Uuid? uuid,
  }) : _uuid = uuid ?? const Uuid();

  final RecurringPaymentRepository _repository;
  final NotificationScheduler _notifications;
  final AppClock _clock;
  final Uuid _uuid;

  Future<RecurringPayment> call({
    required String name,
    required int amountMinor,
    required String currencyCode,
    required LocalDate nextPaymentDate,
    required SystemCategory category,
    required BillingCadence billingCadence,
    String? paymentMethodNickname,
  }) async {
    final billingSchedule = switch (billingCadence) {
      BillingCadence.monthly => BillingSchedule.monthly(
        day: nextPaymentDate.day,
      ),
      BillingCadence.yearly => BillingSchedule.yearly(
        month: nextPaymentDate.month,
        day: nextPaymentDate.day,
      ),
    };
    final payment = RecurringPayment(
      id: _uuid.v4(),
      name: name.trim(),
      amountMinor: amountMinor,
      currencyCode: currencyCode.trim().toUpperCase(),
      nextPaymentDate: nextPaymentDate,
      billingSchedule: billingSchedule,
      paymentMethodNickname: paymentMethodNickname?.trim().isEmpty == true
          ? null
          : paymentMethodNickname?.trim(),
      category: category,
      createdAtUtc: _clock.nowUtc(),
    );
    await _repository.add(payment);
    await _notifications.requestPermission();
    await _notifications.scheduleFor(payment);
    return payment;
  }
}

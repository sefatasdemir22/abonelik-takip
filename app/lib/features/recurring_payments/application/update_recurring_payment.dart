import '../../../core/domain/billing_schedule.dart';
import '../../../core/domain/local_date.dart';
import '../../notifications/domain/notification_scheduler.dart';
import '../domain/recurring_payment.dart';
import '../domain/recurring_payment_repository.dart';
import 'supported_recurring_payment_currencies.dart';

final class UpdateRecurringPaymentResult {
  const UpdateRecurringPaymentResult({
    required this.payment,
    required this.notificationFailed,
  });

  final RecurringPayment payment;
  final bool notificationFailed;
}

final class UpdateRecurringPayment {
  const UpdateRecurringPayment(this._repository, this._notifications);

  final RecurringPaymentRepository _repository;
  final NotificationScheduler _notifications;

  Future<UpdateRecurringPaymentResult> call({
    required RecurringPayment existing,
    required String name,
    required int amountMinor,
    required String currencyCode,
    required LocalDate nextPaymentDate,
    required SystemCategory category,
    required BillingCadence billingCadence,
    String? paymentMethodNickname,
  }) async {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Cannot be empty.');
    }
    if (amountMinor <= 0) {
      throw ArgumentError.value(
        amountMinor,
        'amountMinor',
        'Must be greater than zero.',
      );
    }
    final normalizedCurrency = currencyCode.trim().toUpperCase();
    if (!RegExp(r'^[A-Z]{3}$').hasMatch(normalizedCurrency)) {
      throw ArgumentError.value(currencyCode, 'currencyCode');
    }
    final existingCurrency = existing.currencyCode.trim().toUpperCase();
    if (!isSupportedRecurringPaymentCurrency(normalizedCurrency) &&
        normalizedCurrency != existingCurrency) {
      throw ArgumentError.value(
        currencyCode,
        'currencyCode',
        'Unsupported currency.',
      );
    }

    final billingSchedule = switch (billingCadence) {
      BillingCadence.monthly => BillingSchedule.monthly(
        day: nextPaymentDate.day,
      ),
      BillingCadence.yearly => BillingSchedule.yearly(
        month: nextPaymentDate.month,
        day: nextPaymentDate.day,
      ),
    };
    final normalizedPaymentMethod = paymentMethodNickname?.trim();
    final updated = RecurringPayment(
      id: existing.id,
      name: normalizedName,
      amountMinor: amountMinor,
      currencyCode: normalizedCurrency,
      nextPaymentDate: nextPaymentDate,
      billingSchedule: billingSchedule,
      paymentMethodNickname:
          normalizedPaymentMethod == null || normalizedPaymentMethod.isEmpty
          ? null
          : normalizedPaymentMethod,
      category: category,
      active: existing.active,
      createdAtUtc: existing.createdAtUtc,
    );

    await _repository.update(updated);

    var notificationFailed = false;
    try {
      await _notifications.cancelForOccurrence(updated.id);
    } catch (_) {
      notificationFailed = true;
    }
    try {
      await _notifications.scheduleFor(updated);
    } catch (_) {
      notificationFailed = true;
    }

    return UpdateRecurringPaymentResult(
      payment: updated,
      notificationFailed: notificationFailed,
    );
  }
}

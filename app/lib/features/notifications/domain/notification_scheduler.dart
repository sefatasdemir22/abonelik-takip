import '../../recurring_payments/domain/recurring_payment.dart';

abstract interface class NotificationScheduler {
  Future<void> initialize();
  Future<void> requestPermission();
  Future<void> scheduleFor(RecurringPayment payment);
  Future<void> cancelForOccurrence(String recurringPaymentId);
}

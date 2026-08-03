import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/domain/app_clock.dart';
import '../../../core/domain/local_date.dart';
import '../../notifications/domain/notification_scheduler.dart';
import '../../payment_occurrences/domain/payment_occurrence.dart';
import '../../payment_occurrences/domain/payment_occurrence_repository.dart';
import '../../recurring_payments/domain/recurring_payment.dart';
import '../../recurring_payments/domain/recurring_payment_repository.dart';

final class DashboardState {
  const DashboardState({
    this.loading = true,
    this.payments = const [],
    this.awaiting = const [],
    this.summaries = const [],
    this.error,
  });

  final bool loading;
  final List<RecurringPayment> payments;
  final List<PaymentOccurrence> awaiting;
  final List<CurrencyMonthlySummary> summaries;
  final String? error;
}

final class DashboardController extends StateNotifier<DashboardState> {
  DashboardController(
    this._recurringPayments,
    this._occurrences,
    this._notifications,
    this._clock, [
    this._uuid = const Uuid(),
  ]) : super(const DashboardState());

  final RecurringPaymentRepository _recurringPayments;
  final PaymentOccurrenceRepository _occurrences;
  final NotificationScheduler _notifications;
  final AppClock _clock;
  final Uuid _uuid;

  Future<void> load() async {
    try {
      final today = _clock.todayLocal();
      await _occurrences.materializeDueOccurrences(today);
      final results = await Future.wait<Object>([
        _recurringPayments.getActive(),
        _occurrences.getAwaitingConfirmation(),
        _occurrences.getMonthlySummary(today),
      ]);
      state = DashboardState(
        loading: false,
        payments: results[0] as List<RecurringPayment>,
        awaiting: results[1] as List<PaymentOccurrence>,
        summaries: results[2] as List<CurrencyMonthlySummary>,
      );
    } catch (error) {
      state = DashboardState(loading: false, error: error.toString());
    }
  }

  Future<void> addPayment({
    required String name,
    required int amountMinor,
    required String currencyCode,
    required LocalDate nextPaymentDate,
    required SystemCategory category,
    String? paymentMethodNickname,
  }) async {
    final payment = RecurringPayment(
      id: _uuid.v4(),
      name: name.trim(),
      amountMinor: amountMinor,
      currencyCode: currencyCode.trim().toUpperCase(),
      nextPaymentDate: nextPaymentDate,
      billingDay: nextPaymentDate.day,
      paymentMethodNickname: paymentMethodNickname?.trim().isEmpty == true
          ? null
          : paymentMethodNickname?.trim(),
      category: category,
      createdAtUtc: _clock.nowUtc(),
    );
    await _recurringPayments.add(payment);
    await _notifications.requestPermission();
    await _notifications.scheduleFor(payment);
    await load();
  }

  Future<void> markPaid(PaymentOccurrence occurrence) async {
    await _occurrences.markPaid(occurrence.id, _clock.nowUtc());
    await _notifications.cancelForOccurrence(occurrence.recurringPaymentId);
    await load();
  }

  Future<void> markSkipped(PaymentOccurrence occurrence) async {
    await _occurrences.markSkipped(occurrence.id, _clock.nowUtc());
    await _notifications.cancelForOccurrence(occurrence.recurringPaymentId);
    await load();
  }
}

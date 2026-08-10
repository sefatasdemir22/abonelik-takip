import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/app_clock.dart';
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
    this._clock,
  ) : super(const DashboardState());

  final RecurringPaymentRepository _recurringPayments;
  final PaymentOccurrenceRepository _occurrences;
  final NotificationScheduler _notifications;
  final AppClock _clock;

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

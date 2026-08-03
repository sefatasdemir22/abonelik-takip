import '../../../core/domain/local_date.dart';
import 'payment_occurrence.dart';

abstract interface class PaymentOccurrenceRepository {
  Future<int> materializeDueOccurrences(LocalDate today);
  Future<List<PaymentOccurrence>> getAwaitingConfirmation();
  Future<void> markPaid(String id, DateTime confirmedAtUtc);
  Future<void> markSkipped(String id, DateTime confirmedAtUtc);
  Future<List<CurrencyMonthlySummary>> getMonthlySummary(LocalDate today);
}

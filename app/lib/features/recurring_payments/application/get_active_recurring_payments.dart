import '../domain/recurring_payment.dart';
import '../domain/recurring_payment_repository.dart';

final class GetActiveRecurringPayments {
  const GetActiveRecurringPayments(this._repository);

  final RecurringPaymentRepository _repository;

  Future<List<RecurringPayment>> call() => _repository.getActive();
}

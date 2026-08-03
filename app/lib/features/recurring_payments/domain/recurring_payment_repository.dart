import 'recurring_payment.dart';

abstract interface class RecurringPaymentRepository {
  Future<void> add(RecurringPayment payment);
  Future<List<RecurringPayment>> getActive();
  Future<void> updateNextPaymentDate(String id, String nextDateIso);
}

import 'package:abonelik_takip/core/persistence/app_database.dart';
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../generated_migrations/schema.dart';
import '../../generated_migrations/schema_v1.dart' as v1;
import '../../generated_migrations/schema_v2.dart' as v2;

void main() {
  test(
    'v1 recurring payment v2 migrationinda korunur ve monthly varsayilani alir',
    () async {
      final verifier = SchemaVerifier(GeneratedHelper());
      final schema = await verifier.schemaAt(1);
      addTearDown(schema.close);

      final legacyDatabase = v1.DatabaseAtV1(schema.newConnection());
      await legacyDatabase
          .into(legacyDatabase.recurringPayments)
          .insert(
            v1.RecurringPaymentsCompanion.insert(
              id: 'legacy-payment',
              name: 'Legacy payment',
              amountMinor: 12990,
              currencyCode: 'TRY',
              nextPaymentDate: '2026-08-31',
              billingDay: 31,
              category: 'software',
              createdAtUtc:
                  DateTime.utc(2026, 8, 1).millisecondsSinceEpoch ~/ 1000,
            ),
          );
      await legacyDatabase.close();

      final database = AppDatabase(schema.newConnection());
      await verifier.migrateAndValidate(database, 2);
      await database.close();

      final migratedDatabase = v2.DatabaseAtV2(schema.newConnection());
      final payment = await migratedDatabase
          .select(migratedDatabase.recurringPayments)
          .getSingle();

      expect(payment.id, 'legacy-payment');
      expect(payment.name, 'Legacy payment');
      expect(payment.amountMinor, 12990);
      expect(payment.currencyCode, 'TRY');
      expect(payment.nextPaymentDate, '2026-08-31');
      expect(payment.billingDay, 31);
      expect(payment.category, 'software');
      expect(payment.billingCadence, 'monthly');
      expect(payment.billingMonth, null);

      await migratedDatabase.close();
    },
  );
}

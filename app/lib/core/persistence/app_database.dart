import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DataClassName('RecurringPaymentRow')
class RecurringPayments extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get amountMinor => integer()();
  TextColumn get currencyCode => text()();
  TextColumn get nextPaymentDate => text()();
  IntColumn get billingDay => integer()();
  TextColumn get paymentMethodNickname => text().nullable()();
  TextColumn get category => text()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAtUtc => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('PaymentOccurrenceRow')
class PaymentOccurrences extends Table {
  TextColumn get id => text()();
  TextColumn get recurringPaymentId =>
      text().references(RecurringPayments, #id)();
  TextColumn get paymentName => text()();
  TextColumn get expectedDate => text()();
  IntColumn get expectedAmountMinor => integer()();
  TextColumn get currencyCode => text()();
  TextColumn get status => text()();
  IntColumn get actualAmountMinor => integer().nullable()();
  DateTimeColumn get confirmedAtUtc => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {recurringPaymentId, expectedDate},
  ];
}

@DriftDatabase(tables: [RecurringPayments, PaymentOccurrences])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  AppDatabase.encrypted(String databaseKey)
    : super(
        driftDatabase(
          name: 'abonelik_takip',
          native: DriftNativeOptions(
            setup: (database) {
              if (!RegExp(r'^[A-Za-z0-9_-]{43}$').hasMatch(databaseKey)) {
                throw ArgumentError('Geçersiz veritabanı anahtarı.');
              }
              database.execute("PRAGMA key = '$databaseKey'");
              if (database.select('PRAGMA cipher').isEmpty) {
                throw StateError('Şifreli SQLite sağlayıcısı etkin değil.');
              }
              database.select('SELECT count(*) FROM sqlite_master');
            },
          ),
        ),
      );

  @override
  int get schemaVersion => 1;
}

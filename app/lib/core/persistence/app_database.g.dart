// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RecurringPaymentsTable extends RecurringPayments
    with TableInfo<$RecurringPaymentsTable, RecurringPaymentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextPaymentDateMeta = const VerificationMeta(
    'nextPaymentDate',
  );
  @override
  late final GeneratedColumn<String> nextPaymentDate = GeneratedColumn<String>(
    'next_payment_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _billingDayMeta = const VerificationMeta(
    'billingDay',
  );
  @override
  late final GeneratedColumn<int> billingDay = GeneratedColumn<int>(
    'billing_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentMethodNicknameMeta =
      const VerificationMeta('paymentMethodNickname');
  @override
  late final GeneratedColumn<String> paymentMethodNickname =
      GeneratedColumn<String>(
        'payment_method_nickname',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> createdAtUtc = GeneratedColumn<DateTime>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    amountMinor,
    currencyCode,
    nextPaymentDate,
    billingDay,
    paymentMethodNickname,
    category,
    active,
    createdAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecurringPaymentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('next_payment_date')) {
      context.handle(
        _nextPaymentDateMeta,
        nextPaymentDate.isAcceptableOrUnknown(
          data['next_payment_date']!,
          _nextPaymentDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextPaymentDateMeta);
    }
    if (data.containsKey('billing_day')) {
      context.handle(
        _billingDayMeta,
        billingDay.isAcceptableOrUnknown(data['billing_day']!, _billingDayMeta),
      );
    } else if (isInserting) {
      context.missing(_billingDayMeta);
    }
    if (data.containsKey('payment_method_nickname')) {
      context.handle(
        _paymentMethodNicknameMeta,
        paymentMethodNickname.isAcceptableOrUnknown(
          data['payment_method_nickname']!,
          _paymentMethodNicknameMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringPaymentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringPaymentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      nextPaymentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}next_payment_date'],
      )!,
      billingDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}billing_day'],
      )!,
      paymentMethodNickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method_nickname'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at_utc'],
      )!,
    );
  }

  @override
  $RecurringPaymentsTable createAlias(String alias) {
    return $RecurringPaymentsTable(attachedDatabase, alias);
  }
}

class RecurringPaymentRow extends DataClass
    implements Insertable<RecurringPaymentRow> {
  final String id;
  final String name;
  final int amountMinor;
  final String currencyCode;
  final String nextPaymentDate;
  final int billingDay;
  final String? paymentMethodNickname;
  final String category;
  final bool active;
  final DateTime createdAtUtc;
  const RecurringPaymentRow({
    required this.id,
    required this.name,
    required this.amountMinor,
    required this.currencyCode,
    required this.nextPaymentDate,
    required this.billingDay,
    this.paymentMethodNickname,
    required this.category,
    required this.active,
    required this.createdAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['currency_code'] = Variable<String>(currencyCode);
    map['next_payment_date'] = Variable<String>(nextPaymentDate);
    map['billing_day'] = Variable<int>(billingDay);
    if (!nullToAbsent || paymentMethodNickname != null) {
      map['payment_method_nickname'] = Variable<String>(paymentMethodNickname);
    }
    map['category'] = Variable<String>(category);
    map['active'] = Variable<bool>(active);
    map['created_at_utc'] = Variable<DateTime>(createdAtUtc);
    return map;
  }

  RecurringPaymentsCompanion toCompanion(bool nullToAbsent) {
    return RecurringPaymentsCompanion(
      id: Value(id),
      name: Value(name),
      amountMinor: Value(amountMinor),
      currencyCode: Value(currencyCode),
      nextPaymentDate: Value(nextPaymentDate),
      billingDay: Value(billingDay),
      paymentMethodNickname: paymentMethodNickname == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethodNickname),
      category: Value(category),
      active: Value(active),
      createdAtUtc: Value(createdAtUtc),
    );
  }

  factory RecurringPaymentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringPaymentRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      nextPaymentDate: serializer.fromJson<String>(json['nextPaymentDate']),
      billingDay: serializer.fromJson<int>(json['billingDay']),
      paymentMethodNickname: serializer.fromJson<String?>(
        json['paymentMethodNickname'],
      ),
      category: serializer.fromJson<String>(json['category']),
      active: serializer.fromJson<bool>(json['active']),
      createdAtUtc: serializer.fromJson<DateTime>(json['createdAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'nextPaymentDate': serializer.toJson<String>(nextPaymentDate),
      'billingDay': serializer.toJson<int>(billingDay),
      'paymentMethodNickname': serializer.toJson<String?>(
        paymentMethodNickname,
      ),
      'category': serializer.toJson<String>(category),
      'active': serializer.toJson<bool>(active),
      'createdAtUtc': serializer.toJson<DateTime>(createdAtUtc),
    };
  }

  RecurringPaymentRow copyWith({
    String? id,
    String? name,
    int? amountMinor,
    String? currencyCode,
    String? nextPaymentDate,
    int? billingDay,
    Value<String?> paymentMethodNickname = const Value.absent(),
    String? category,
    bool? active,
    DateTime? createdAtUtc,
  }) => RecurringPaymentRow(
    id: id ?? this.id,
    name: name ?? this.name,
    amountMinor: amountMinor ?? this.amountMinor,
    currencyCode: currencyCode ?? this.currencyCode,
    nextPaymentDate: nextPaymentDate ?? this.nextPaymentDate,
    billingDay: billingDay ?? this.billingDay,
    paymentMethodNickname: paymentMethodNickname.present
        ? paymentMethodNickname.value
        : this.paymentMethodNickname,
    category: category ?? this.category,
    active: active ?? this.active,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
  );
  RecurringPaymentRow copyWithCompanion(RecurringPaymentsCompanion data) {
    return RecurringPaymentRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      nextPaymentDate: data.nextPaymentDate.present
          ? data.nextPaymentDate.value
          : this.nextPaymentDate,
      billingDay: data.billingDay.present
          ? data.billingDay.value
          : this.billingDay,
      paymentMethodNickname: data.paymentMethodNickname.present
          ? data.paymentMethodNickname.value
          : this.paymentMethodNickname,
      category: data.category.present ? data.category.value : this.category,
      active: data.active.present ? data.active.value : this.active,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringPaymentRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('nextPaymentDate: $nextPaymentDate, ')
          ..write('billingDay: $billingDay, ')
          ..write('paymentMethodNickname: $paymentMethodNickname, ')
          ..write('category: $category, ')
          ..write('active: $active, ')
          ..write('createdAtUtc: $createdAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    amountMinor,
    currencyCode,
    nextPaymentDate,
    billingDay,
    paymentMethodNickname,
    category,
    active,
    createdAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringPaymentRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.amountMinor == this.amountMinor &&
          other.currencyCode == this.currencyCode &&
          other.nextPaymentDate == this.nextPaymentDate &&
          other.billingDay == this.billingDay &&
          other.paymentMethodNickname == this.paymentMethodNickname &&
          other.category == this.category &&
          other.active == this.active &&
          other.createdAtUtc == this.createdAtUtc);
}

class RecurringPaymentsCompanion extends UpdateCompanion<RecurringPaymentRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> amountMinor;
  final Value<String> currencyCode;
  final Value<String> nextPaymentDate;
  final Value<int> billingDay;
  final Value<String?> paymentMethodNickname;
  final Value<String> category;
  final Value<bool> active;
  final Value<DateTime> createdAtUtc;
  final Value<int> rowid;
  const RecurringPaymentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.nextPaymentDate = const Value.absent(),
    this.billingDay = const Value.absent(),
    this.paymentMethodNickname = const Value.absent(),
    this.category = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurringPaymentsCompanion.insert({
    required String id,
    required String name,
    required int amountMinor,
    required String currencyCode,
    required String nextPaymentDate,
    required int billingDay,
    this.paymentMethodNickname = const Value.absent(),
    required String category,
    this.active = const Value.absent(),
    required DateTime createdAtUtc,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       amountMinor = Value(amountMinor),
       currencyCode = Value(currencyCode),
       nextPaymentDate = Value(nextPaymentDate),
       billingDay = Value(billingDay),
       category = Value(category),
       createdAtUtc = Value(createdAtUtc);
  static Insertable<RecurringPaymentRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? amountMinor,
    Expression<String>? currencyCode,
    Expression<String>? nextPaymentDate,
    Expression<int>? billingDay,
    Expression<String>? paymentMethodNickname,
    Expression<String>? category,
    Expression<bool>? active,
    Expression<DateTime>? createdAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (nextPaymentDate != null) 'next_payment_date': nextPaymentDate,
      if (billingDay != null) 'billing_day': billingDay,
      if (paymentMethodNickname != null)
        'payment_method_nickname': paymentMethodNickname,
      if (category != null) 'category': category,
      if (active != null) 'active': active,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurringPaymentsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? amountMinor,
    Value<String>? currencyCode,
    Value<String>? nextPaymentDate,
    Value<int>? billingDay,
    Value<String?>? paymentMethodNickname,
    Value<String>? category,
    Value<bool>? active,
    Value<DateTime>? createdAtUtc,
    Value<int>? rowid,
  }) {
    return RecurringPaymentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      amountMinor: amountMinor ?? this.amountMinor,
      currencyCode: currencyCode ?? this.currencyCode,
      nextPaymentDate: nextPaymentDate ?? this.nextPaymentDate,
      billingDay: billingDay ?? this.billingDay,
      paymentMethodNickname:
          paymentMethodNickname ?? this.paymentMethodNickname,
      category: category ?? this.category,
      active: active ?? this.active,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (nextPaymentDate.present) {
      map['next_payment_date'] = Variable<String>(nextPaymentDate.value);
    }
    if (billingDay.present) {
      map['billing_day'] = Variable<int>(billingDay.value);
    }
    if (paymentMethodNickname.present) {
      map['payment_method_nickname'] = Variable<String>(
        paymentMethodNickname.value,
      );
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<DateTime>(createdAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('nextPaymentDate: $nextPaymentDate, ')
          ..write('billingDay: $billingDay, ')
          ..write('paymentMethodNickname: $paymentMethodNickname, ')
          ..write('category: $category, ')
          ..write('active: $active, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentOccurrencesTable extends PaymentOccurrences
    with TableInfo<$PaymentOccurrencesTable, PaymentOccurrenceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentOccurrencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recurringPaymentIdMeta =
      const VerificationMeta('recurringPaymentId');
  @override
  late final GeneratedColumn<String> recurringPaymentId =
      GeneratedColumn<String>(
        'recurring_payment_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES recurring_payments (id)',
        ),
      );
  static const VerificationMeta _paymentNameMeta = const VerificationMeta(
    'paymentName',
  );
  @override
  late final GeneratedColumn<String> paymentName = GeneratedColumn<String>(
    'payment_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expectedDateMeta = const VerificationMeta(
    'expectedDate',
  );
  @override
  late final GeneratedColumn<String> expectedDate = GeneratedColumn<String>(
    'expected_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expectedAmountMinorMeta =
      const VerificationMeta('expectedAmountMinor');
  @override
  late final GeneratedColumn<int> expectedAmountMinor = GeneratedColumn<int>(
    'expected_amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualAmountMinorMeta = const VerificationMeta(
    'actualAmountMinor',
  );
  @override
  late final GeneratedColumn<int> actualAmountMinor = GeneratedColumn<int>(
    'actual_amount_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confirmedAtUtcMeta = const VerificationMeta(
    'confirmedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> confirmedAtUtc =
      GeneratedColumn<DateTime>(
        'confirmed_at_utc',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recurringPaymentId,
    paymentName,
    expectedDate,
    expectedAmountMinor,
    currencyCode,
    status,
    actualAmountMinor,
    confirmedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_occurrences';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentOccurrenceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('recurring_payment_id')) {
      context.handle(
        _recurringPaymentIdMeta,
        recurringPaymentId.isAcceptableOrUnknown(
          data['recurring_payment_id']!,
          _recurringPaymentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recurringPaymentIdMeta);
    }
    if (data.containsKey('payment_name')) {
      context.handle(
        _paymentNameMeta,
        paymentName.isAcceptableOrUnknown(
          data['payment_name']!,
          _paymentNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentNameMeta);
    }
    if (data.containsKey('expected_date')) {
      context.handle(
        _expectedDateMeta,
        expectedDate.isAcceptableOrUnknown(
          data['expected_date']!,
          _expectedDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_expectedDateMeta);
    }
    if (data.containsKey('expected_amount_minor')) {
      context.handle(
        _expectedAmountMinorMeta,
        expectedAmountMinor.isAcceptableOrUnknown(
          data['expected_amount_minor']!,
          _expectedAmountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_expectedAmountMinorMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('actual_amount_minor')) {
      context.handle(
        _actualAmountMinorMeta,
        actualAmountMinor.isAcceptableOrUnknown(
          data['actual_amount_minor']!,
          _actualAmountMinorMeta,
        ),
      );
    }
    if (data.containsKey('confirmed_at_utc')) {
      context.handle(
        _confirmedAtUtcMeta,
        confirmedAtUtc.isAcceptableOrUnknown(
          data['confirmed_at_utc']!,
          _confirmedAtUtcMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {recurringPaymentId, expectedDate},
  ];
  @override
  PaymentOccurrenceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentOccurrenceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      recurringPaymentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurring_payment_id'],
      )!,
      paymentName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_name'],
      )!,
      expectedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expected_date'],
      )!,
      expectedAmountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expected_amount_minor'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      actualAmountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_amount_minor'],
      ),
      confirmedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}confirmed_at_utc'],
      ),
    );
  }

  @override
  $PaymentOccurrencesTable createAlias(String alias) {
    return $PaymentOccurrencesTable(attachedDatabase, alias);
  }
}

class PaymentOccurrenceRow extends DataClass
    implements Insertable<PaymentOccurrenceRow> {
  final String id;
  final String recurringPaymentId;
  final String paymentName;
  final String expectedDate;
  final int expectedAmountMinor;
  final String currencyCode;
  final String status;
  final int? actualAmountMinor;
  final DateTime? confirmedAtUtc;
  const PaymentOccurrenceRow({
    required this.id,
    required this.recurringPaymentId,
    required this.paymentName,
    required this.expectedDate,
    required this.expectedAmountMinor,
    required this.currencyCode,
    required this.status,
    this.actualAmountMinor,
    this.confirmedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['recurring_payment_id'] = Variable<String>(recurringPaymentId);
    map['payment_name'] = Variable<String>(paymentName);
    map['expected_date'] = Variable<String>(expectedDate);
    map['expected_amount_minor'] = Variable<int>(expectedAmountMinor);
    map['currency_code'] = Variable<String>(currencyCode);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || actualAmountMinor != null) {
      map['actual_amount_minor'] = Variable<int>(actualAmountMinor);
    }
    if (!nullToAbsent || confirmedAtUtc != null) {
      map['confirmed_at_utc'] = Variable<DateTime>(confirmedAtUtc);
    }
    return map;
  }

  PaymentOccurrencesCompanion toCompanion(bool nullToAbsent) {
    return PaymentOccurrencesCompanion(
      id: Value(id),
      recurringPaymentId: Value(recurringPaymentId),
      paymentName: Value(paymentName),
      expectedDate: Value(expectedDate),
      expectedAmountMinor: Value(expectedAmountMinor),
      currencyCode: Value(currencyCode),
      status: Value(status),
      actualAmountMinor: actualAmountMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(actualAmountMinor),
      confirmedAtUtc: confirmedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(confirmedAtUtc),
    );
  }

  factory PaymentOccurrenceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentOccurrenceRow(
      id: serializer.fromJson<String>(json['id']),
      recurringPaymentId: serializer.fromJson<String>(
        json['recurringPaymentId'],
      ),
      paymentName: serializer.fromJson<String>(json['paymentName']),
      expectedDate: serializer.fromJson<String>(json['expectedDate']),
      expectedAmountMinor: serializer.fromJson<int>(
        json['expectedAmountMinor'],
      ),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      status: serializer.fromJson<String>(json['status']),
      actualAmountMinor: serializer.fromJson<int?>(json['actualAmountMinor']),
      confirmedAtUtc: serializer.fromJson<DateTime?>(json['confirmedAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'recurringPaymentId': serializer.toJson<String>(recurringPaymentId),
      'paymentName': serializer.toJson<String>(paymentName),
      'expectedDate': serializer.toJson<String>(expectedDate),
      'expectedAmountMinor': serializer.toJson<int>(expectedAmountMinor),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'status': serializer.toJson<String>(status),
      'actualAmountMinor': serializer.toJson<int?>(actualAmountMinor),
      'confirmedAtUtc': serializer.toJson<DateTime?>(confirmedAtUtc),
    };
  }

  PaymentOccurrenceRow copyWith({
    String? id,
    String? recurringPaymentId,
    String? paymentName,
    String? expectedDate,
    int? expectedAmountMinor,
    String? currencyCode,
    String? status,
    Value<int?> actualAmountMinor = const Value.absent(),
    Value<DateTime?> confirmedAtUtc = const Value.absent(),
  }) => PaymentOccurrenceRow(
    id: id ?? this.id,
    recurringPaymentId: recurringPaymentId ?? this.recurringPaymentId,
    paymentName: paymentName ?? this.paymentName,
    expectedDate: expectedDate ?? this.expectedDate,
    expectedAmountMinor: expectedAmountMinor ?? this.expectedAmountMinor,
    currencyCode: currencyCode ?? this.currencyCode,
    status: status ?? this.status,
    actualAmountMinor: actualAmountMinor.present
        ? actualAmountMinor.value
        : this.actualAmountMinor,
    confirmedAtUtc: confirmedAtUtc.present
        ? confirmedAtUtc.value
        : this.confirmedAtUtc,
  );
  PaymentOccurrenceRow copyWithCompanion(PaymentOccurrencesCompanion data) {
    return PaymentOccurrenceRow(
      id: data.id.present ? data.id.value : this.id,
      recurringPaymentId: data.recurringPaymentId.present
          ? data.recurringPaymentId.value
          : this.recurringPaymentId,
      paymentName: data.paymentName.present
          ? data.paymentName.value
          : this.paymentName,
      expectedDate: data.expectedDate.present
          ? data.expectedDate.value
          : this.expectedDate,
      expectedAmountMinor: data.expectedAmountMinor.present
          ? data.expectedAmountMinor.value
          : this.expectedAmountMinor,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      status: data.status.present ? data.status.value : this.status,
      actualAmountMinor: data.actualAmountMinor.present
          ? data.actualAmountMinor.value
          : this.actualAmountMinor,
      confirmedAtUtc: data.confirmedAtUtc.present
          ? data.confirmedAtUtc.value
          : this.confirmedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentOccurrenceRow(')
          ..write('id: $id, ')
          ..write('recurringPaymentId: $recurringPaymentId, ')
          ..write('paymentName: $paymentName, ')
          ..write('expectedDate: $expectedDate, ')
          ..write('expectedAmountMinor: $expectedAmountMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('status: $status, ')
          ..write('actualAmountMinor: $actualAmountMinor, ')
          ..write('confirmedAtUtc: $confirmedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    recurringPaymentId,
    paymentName,
    expectedDate,
    expectedAmountMinor,
    currencyCode,
    status,
    actualAmountMinor,
    confirmedAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentOccurrenceRow &&
          other.id == this.id &&
          other.recurringPaymentId == this.recurringPaymentId &&
          other.paymentName == this.paymentName &&
          other.expectedDate == this.expectedDate &&
          other.expectedAmountMinor == this.expectedAmountMinor &&
          other.currencyCode == this.currencyCode &&
          other.status == this.status &&
          other.actualAmountMinor == this.actualAmountMinor &&
          other.confirmedAtUtc == this.confirmedAtUtc);
}

class PaymentOccurrencesCompanion
    extends UpdateCompanion<PaymentOccurrenceRow> {
  final Value<String> id;
  final Value<String> recurringPaymentId;
  final Value<String> paymentName;
  final Value<String> expectedDate;
  final Value<int> expectedAmountMinor;
  final Value<String> currencyCode;
  final Value<String> status;
  final Value<int?> actualAmountMinor;
  final Value<DateTime?> confirmedAtUtc;
  final Value<int> rowid;
  const PaymentOccurrencesCompanion({
    this.id = const Value.absent(),
    this.recurringPaymentId = const Value.absent(),
    this.paymentName = const Value.absent(),
    this.expectedDate = const Value.absent(),
    this.expectedAmountMinor = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.status = const Value.absent(),
    this.actualAmountMinor = const Value.absent(),
    this.confirmedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentOccurrencesCompanion.insert({
    required String id,
    required String recurringPaymentId,
    required String paymentName,
    required String expectedDate,
    required int expectedAmountMinor,
    required String currencyCode,
    required String status,
    this.actualAmountMinor = const Value.absent(),
    this.confirmedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       recurringPaymentId = Value(recurringPaymentId),
       paymentName = Value(paymentName),
       expectedDate = Value(expectedDate),
       expectedAmountMinor = Value(expectedAmountMinor),
       currencyCode = Value(currencyCode),
       status = Value(status);
  static Insertable<PaymentOccurrenceRow> custom({
    Expression<String>? id,
    Expression<String>? recurringPaymentId,
    Expression<String>? paymentName,
    Expression<String>? expectedDate,
    Expression<int>? expectedAmountMinor,
    Expression<String>? currencyCode,
    Expression<String>? status,
    Expression<int>? actualAmountMinor,
    Expression<DateTime>? confirmedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recurringPaymentId != null)
        'recurring_payment_id': recurringPaymentId,
      if (paymentName != null) 'payment_name': paymentName,
      if (expectedDate != null) 'expected_date': expectedDate,
      if (expectedAmountMinor != null)
        'expected_amount_minor': expectedAmountMinor,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (status != null) 'status': status,
      if (actualAmountMinor != null) 'actual_amount_minor': actualAmountMinor,
      if (confirmedAtUtc != null) 'confirmed_at_utc': confirmedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentOccurrencesCompanion copyWith({
    Value<String>? id,
    Value<String>? recurringPaymentId,
    Value<String>? paymentName,
    Value<String>? expectedDate,
    Value<int>? expectedAmountMinor,
    Value<String>? currencyCode,
    Value<String>? status,
    Value<int?>? actualAmountMinor,
    Value<DateTime?>? confirmedAtUtc,
    Value<int>? rowid,
  }) {
    return PaymentOccurrencesCompanion(
      id: id ?? this.id,
      recurringPaymentId: recurringPaymentId ?? this.recurringPaymentId,
      paymentName: paymentName ?? this.paymentName,
      expectedDate: expectedDate ?? this.expectedDate,
      expectedAmountMinor: expectedAmountMinor ?? this.expectedAmountMinor,
      currencyCode: currencyCode ?? this.currencyCode,
      status: status ?? this.status,
      actualAmountMinor: actualAmountMinor ?? this.actualAmountMinor,
      confirmedAtUtc: confirmedAtUtc ?? this.confirmedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (recurringPaymentId.present) {
      map['recurring_payment_id'] = Variable<String>(recurringPaymentId.value);
    }
    if (paymentName.present) {
      map['payment_name'] = Variable<String>(paymentName.value);
    }
    if (expectedDate.present) {
      map['expected_date'] = Variable<String>(expectedDate.value);
    }
    if (expectedAmountMinor.present) {
      map['expected_amount_minor'] = Variable<int>(expectedAmountMinor.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (actualAmountMinor.present) {
      map['actual_amount_minor'] = Variable<int>(actualAmountMinor.value);
    }
    if (confirmedAtUtc.present) {
      map['confirmed_at_utc'] = Variable<DateTime>(confirmedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentOccurrencesCompanion(')
          ..write('id: $id, ')
          ..write('recurringPaymentId: $recurringPaymentId, ')
          ..write('paymentName: $paymentName, ')
          ..write('expectedDate: $expectedDate, ')
          ..write('expectedAmountMinor: $expectedAmountMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('status: $status, ')
          ..write('actualAmountMinor: $actualAmountMinor, ')
          ..write('confirmedAtUtc: $confirmedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RecurringPaymentsTable recurringPayments =
      $RecurringPaymentsTable(this);
  late final $PaymentOccurrencesTable paymentOccurrences =
      $PaymentOccurrencesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    recurringPayments,
    paymentOccurrences,
  ];
}

typedef $$RecurringPaymentsTableCreateCompanionBuilder =
    RecurringPaymentsCompanion Function({
      required String id,
      required String name,
      required int amountMinor,
      required String currencyCode,
      required String nextPaymentDate,
      required int billingDay,
      Value<String?> paymentMethodNickname,
      required String category,
      Value<bool> active,
      required DateTime createdAtUtc,
      Value<int> rowid,
    });
typedef $$RecurringPaymentsTableUpdateCompanionBuilder =
    RecurringPaymentsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> amountMinor,
      Value<String> currencyCode,
      Value<String> nextPaymentDate,
      Value<int> billingDay,
      Value<String?> paymentMethodNickname,
      Value<String> category,
      Value<bool> active,
      Value<DateTime> createdAtUtc,
      Value<int> rowid,
    });

final class $$RecurringPaymentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RecurringPaymentsTable,
          RecurringPaymentRow
        > {
  $$RecurringPaymentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $PaymentOccurrencesTable,
    List<PaymentOccurrenceRow>
  >
  _paymentOccurrencesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.paymentOccurrences,
        aliasName:
            'recurring_payments__id__payment_occurrences__recurring_payment_id',
      );

  $$PaymentOccurrencesTableProcessedTableManager get paymentOccurrencesRefs {
    final manager =
        $$PaymentOccurrencesTableTableManager(
          $_db,
          $_db.paymentOccurrences,
        ).filter(
          (f) => f.recurringPaymentId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _paymentOccurrencesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RecurringPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringPaymentsTable> {
  $$RecurringPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nextPaymentDate => $composableBuilder(
    column: $table.nextPaymentDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get billingDay => $composableBuilder(
    column: $table.billingDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethodNickname => $composableBuilder(
    column: $table.paymentMethodNickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> paymentOccurrencesRefs(
    Expression<bool> Function($$PaymentOccurrencesTableFilterComposer f) f,
  ) {
    final $$PaymentOccurrencesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paymentOccurrences,
      getReferencedColumn: (t) => t.recurringPaymentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentOccurrencesTableFilterComposer(
            $db: $db,
            $table: $db.paymentOccurrences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecurringPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringPaymentsTable> {
  $$RecurringPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nextPaymentDate => $composableBuilder(
    column: $table.nextPaymentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get billingDay => $composableBuilder(
    column: $table.billingDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethodNickname => $composableBuilder(
    column: $table.paymentMethodNickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecurringPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringPaymentsTable> {
  $$RecurringPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nextPaymentDate => $composableBuilder(
    column: $table.nextPaymentDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get billingDay => $composableBuilder(
    column: $table.billingDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentMethodNickname => $composableBuilder(
    column: $table.paymentMethodNickname,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  Expression<T> paymentOccurrencesRefs<T extends Object>(
    Expression<T> Function($$PaymentOccurrencesTableAnnotationComposer a) f,
  ) {
    final $$PaymentOccurrencesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.paymentOccurrences,
          getReferencedColumn: (t) => t.recurringPaymentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PaymentOccurrencesTableAnnotationComposer(
                $db: $db,
                $table: $db.paymentOccurrences,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RecurringPaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecurringPaymentsTable,
          RecurringPaymentRow,
          $$RecurringPaymentsTableFilterComposer,
          $$RecurringPaymentsTableOrderingComposer,
          $$RecurringPaymentsTableAnnotationComposer,
          $$RecurringPaymentsTableCreateCompanionBuilder,
          $$RecurringPaymentsTableUpdateCompanionBuilder,
          (RecurringPaymentRow, $$RecurringPaymentsTableReferences),
          RecurringPaymentRow,
          PrefetchHooks Function({bool paymentOccurrencesRefs})
        > {
  $$RecurringPaymentsTableTableManager(
    _$AppDatabase db,
    $RecurringPaymentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurringPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurringPaymentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<String> nextPaymentDate = const Value.absent(),
                Value<int> billingDay = const Value.absent(),
                Value<String?> paymentMethodNickname = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime> createdAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecurringPaymentsCompanion(
                id: id,
                name: name,
                amountMinor: amountMinor,
                currencyCode: currencyCode,
                nextPaymentDate: nextPaymentDate,
                billingDay: billingDay,
                paymentMethodNickname: paymentMethodNickname,
                category: category,
                active: active,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int amountMinor,
                required String currencyCode,
                required String nextPaymentDate,
                required int billingDay,
                Value<String?> paymentMethodNickname = const Value.absent(),
                required String category,
                Value<bool> active = const Value.absent(),
                required DateTime createdAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => RecurringPaymentsCompanion.insert(
                id: id,
                name: name,
                amountMinor: amountMinor,
                currencyCode: currencyCode,
                nextPaymentDate: nextPaymentDate,
                billingDay: billingDay,
                paymentMethodNickname: paymentMethodNickname,
                category: category,
                active: active,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecurringPaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({paymentOccurrencesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (paymentOccurrencesRefs) db.paymentOccurrences,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (paymentOccurrencesRefs)
                    await $_getPrefetchedData<
                      RecurringPaymentRow,
                      $RecurringPaymentsTable,
                      PaymentOccurrenceRow
                    >(
                      currentTable: table,
                      referencedTable: $$RecurringPaymentsTableReferences
                          ._paymentOccurrencesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RecurringPaymentsTableReferences(
                            db,
                            table,
                            p0,
                          ).paymentOccurrencesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.recurringPaymentId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RecurringPaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecurringPaymentsTable,
      RecurringPaymentRow,
      $$RecurringPaymentsTableFilterComposer,
      $$RecurringPaymentsTableOrderingComposer,
      $$RecurringPaymentsTableAnnotationComposer,
      $$RecurringPaymentsTableCreateCompanionBuilder,
      $$RecurringPaymentsTableUpdateCompanionBuilder,
      (RecurringPaymentRow, $$RecurringPaymentsTableReferences),
      RecurringPaymentRow,
      PrefetchHooks Function({bool paymentOccurrencesRefs})
    >;
typedef $$PaymentOccurrencesTableCreateCompanionBuilder =
    PaymentOccurrencesCompanion Function({
      required String id,
      required String recurringPaymentId,
      required String paymentName,
      required String expectedDate,
      required int expectedAmountMinor,
      required String currencyCode,
      required String status,
      Value<int?> actualAmountMinor,
      Value<DateTime?> confirmedAtUtc,
      Value<int> rowid,
    });
typedef $$PaymentOccurrencesTableUpdateCompanionBuilder =
    PaymentOccurrencesCompanion Function({
      Value<String> id,
      Value<String> recurringPaymentId,
      Value<String> paymentName,
      Value<String> expectedDate,
      Value<int> expectedAmountMinor,
      Value<String> currencyCode,
      Value<String> status,
      Value<int?> actualAmountMinor,
      Value<DateTime?> confirmedAtUtc,
      Value<int> rowid,
    });

final class $$PaymentOccurrencesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PaymentOccurrencesTable,
          PaymentOccurrenceRow
        > {
  $$PaymentOccurrencesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RecurringPaymentsTable _recurringPaymentIdTable(_$AppDatabase db) =>
      db.recurringPayments.createAlias(
        'payment_occurrences__recurring_payment_id__recurring_payments__id',
      );

  $$RecurringPaymentsTableProcessedTableManager get recurringPaymentId {
    final $_column = $_itemColumn<String>('recurring_payment_id')!;

    final manager = $$RecurringPaymentsTableTableManager(
      $_db,
      $_db.recurringPayments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recurringPaymentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PaymentOccurrencesTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentOccurrencesTable> {
  $$PaymentOccurrencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentName => $composableBuilder(
    column: $table.paymentName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expectedDate => $composableBuilder(
    column: $table.expectedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expectedAmountMinor => $composableBuilder(
    column: $table.expectedAmountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualAmountMinor => $composableBuilder(
    column: $table.actualAmountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get confirmedAtUtc => $composableBuilder(
    column: $table.confirmedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  $$RecurringPaymentsTableFilterComposer get recurringPaymentId {
    final $$RecurringPaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recurringPaymentId,
      referencedTable: $db.recurringPayments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringPaymentsTableFilterComposer(
            $db: $db,
            $table: $db.recurringPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentOccurrencesTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentOccurrencesTable> {
  $$PaymentOccurrencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentName => $composableBuilder(
    column: $table.paymentName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expectedDate => $composableBuilder(
    column: $table.expectedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expectedAmountMinor => $composableBuilder(
    column: $table.expectedAmountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualAmountMinor => $composableBuilder(
    column: $table.actualAmountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get confirmedAtUtc => $composableBuilder(
    column: $table.confirmedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecurringPaymentsTableOrderingComposer get recurringPaymentId {
    final $$RecurringPaymentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recurringPaymentId,
      referencedTable: $db.recurringPayments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringPaymentsTableOrderingComposer(
            $db: $db,
            $table: $db.recurringPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentOccurrencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentOccurrencesTable> {
  $$PaymentOccurrencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get paymentName => $composableBuilder(
    column: $table.paymentName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get expectedDate => $composableBuilder(
    column: $table.expectedDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get expectedAmountMinor => $composableBuilder(
    column: $table.expectedAmountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get actualAmountMinor => $composableBuilder(
    column: $table.actualAmountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get confirmedAtUtc => $composableBuilder(
    column: $table.confirmedAtUtc,
    builder: (column) => column,
  );

  $$RecurringPaymentsTableAnnotationComposer get recurringPaymentId {
    final $$RecurringPaymentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.recurringPaymentId,
          referencedTable: $db.recurringPayments,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringPaymentsTableAnnotationComposer(
                $db: $db,
                $table: $db.recurringPayments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$PaymentOccurrencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentOccurrencesTable,
          PaymentOccurrenceRow,
          $$PaymentOccurrencesTableFilterComposer,
          $$PaymentOccurrencesTableOrderingComposer,
          $$PaymentOccurrencesTableAnnotationComposer,
          $$PaymentOccurrencesTableCreateCompanionBuilder,
          $$PaymentOccurrencesTableUpdateCompanionBuilder,
          (PaymentOccurrenceRow, $$PaymentOccurrencesTableReferences),
          PaymentOccurrenceRow,
          PrefetchHooks Function({bool recurringPaymentId})
        > {
  $$PaymentOccurrencesTableTableManager(
    _$AppDatabase db,
    $PaymentOccurrencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentOccurrencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentOccurrencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentOccurrencesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> recurringPaymentId = const Value.absent(),
                Value<String> paymentName = const Value.absent(),
                Value<String> expectedDate = const Value.absent(),
                Value<int> expectedAmountMinor = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> actualAmountMinor = const Value.absent(),
                Value<DateTime?> confirmedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentOccurrencesCompanion(
                id: id,
                recurringPaymentId: recurringPaymentId,
                paymentName: paymentName,
                expectedDate: expectedDate,
                expectedAmountMinor: expectedAmountMinor,
                currencyCode: currencyCode,
                status: status,
                actualAmountMinor: actualAmountMinor,
                confirmedAtUtc: confirmedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String recurringPaymentId,
                required String paymentName,
                required String expectedDate,
                required int expectedAmountMinor,
                required String currencyCode,
                required String status,
                Value<int?> actualAmountMinor = const Value.absent(),
                Value<DateTime?> confirmedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentOccurrencesCompanion.insert(
                id: id,
                recurringPaymentId: recurringPaymentId,
                paymentName: paymentName,
                expectedDate: expectedDate,
                expectedAmountMinor: expectedAmountMinor,
                currencyCode: currencyCode,
                status: status,
                actualAmountMinor: actualAmountMinor,
                confirmedAtUtc: confirmedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PaymentOccurrencesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recurringPaymentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (recurringPaymentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.recurringPaymentId,
                                referencedTable:
                                    $$PaymentOccurrencesTableReferences
                                        ._recurringPaymentIdTable(db),
                                referencedColumn:
                                    $$PaymentOccurrencesTableReferences
                                        ._recurringPaymentIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PaymentOccurrencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentOccurrencesTable,
      PaymentOccurrenceRow,
      $$PaymentOccurrencesTableFilterComposer,
      $$PaymentOccurrencesTableOrderingComposer,
      $$PaymentOccurrencesTableAnnotationComposer,
      $$PaymentOccurrencesTableCreateCompanionBuilder,
      $$PaymentOccurrencesTableUpdateCompanionBuilder,
      (PaymentOccurrenceRow, $$PaymentOccurrencesTableReferences),
      PaymentOccurrenceRow,
      PrefetchHooks Function({bool recurringPaymentId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RecurringPaymentsTableTableManager get recurringPayments =>
      $$RecurringPaymentsTableTableManager(_db, _db.recurringPayments);
  $$PaymentOccurrencesTableTableManager get paymentOccurrences =>
      $$PaymentOccurrencesTableTableManager(_db, _db.paymentOccurrences);
}

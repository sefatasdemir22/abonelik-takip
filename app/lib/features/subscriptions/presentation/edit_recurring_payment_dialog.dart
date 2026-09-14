import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/domain/billing_schedule.dart';
import '../../../core/domain/local_date.dart';
import '../../../core/domain/money.dart';
import '../../recurring_payments/application/update_recurring_payment.dart';
import '../../recurring_payments/domain/recurring_payment.dart';
import 'supported_currencies.dart';

class EditRecurringPaymentDialog extends StatefulWidget {
  const EditRecurringPaymentDialog({
    required this.payment,
    required this.updateRecurringPayment,
    super.key,
  });

  final RecurringPayment payment;
  final UpdateRecurringPayment updateRecurringPayment;

  @override
  State<EditRecurringPaymentDialog> createState() =>
      _EditRecurringPaymentDialogState();
}

class _EditRecurringPaymentDialogState
    extends State<EditRecurringPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _amount;
  late final TextEditingController _paymentMethod;
  late LocalDate _dateValue;
  late String _currencyCode;
  late SystemCategory _category;
  late BillingCadence _billingCadence;
  bool _saving = false;
  String? _saveError;

  @override
  void initState() {
    super.initState();
    final payment = widget.payment;
    _name = TextEditingController(text: payment.name);
    _amount = TextEditingController(
      text: formatMinorUnits(payment.amountMinor),
    );
    _paymentMethod = TextEditingController(
      text: payment.paymentMethodNickname ?? '',
    );
    _dateValue = payment.nextPaymentDate;
    _currencyCode = payment.currencyCode.trim().toUpperCase();
    _category = payment.category;
    _billingCadence = payment.billingSchedule.cadence;
  }

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    _paymentMethod.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
    titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
    contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
    actionsPadding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
    title: const Text('Aboneliği düzenle'),
    content: SizedBox(
      width: 420,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                key: const Key('edit-payment-name'),
                controller: _name,
                decoration: const InputDecoration(labelText: 'Ad'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Ad zorunludur.'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('edit-payment-amount'),
                controller: _amount,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Tutar'),
                validator: (value) {
                  try {
                    if (parseMinorUnits(value ?? '') <= 0) {
                      return 'Tutar sıfırdan büyük olmalı.';
                    }
                    return null;
                  } on FormatException {
                    return 'Geçerli bir tutar girin.';
                  }
                },
              ),
              const SizedBox(height: 12),
              CurrencySelector(
                value: _currencyCode,
                legacyCurrencyCode: widget.payment.currencyCode,
                onChanged: (currency) =>
                    setState(() => _currencyCode = currency),
              ),
              const SizedBox(height: 12),
              SegmentedButton<BillingCadence>(
                segments: const [
                  ButtonSegment(
                    value: BillingCadence.monthly,
                    label: Text('Aylık'),
                  ),
                  ButtonSegment(
                    value: BillingCadence.yearly,
                    label: Text('Yıllık'),
                  ),
                ],
                selected: {_billingCadence},
                onSelectionChanged: (selection) =>
                    setState(() => _billingCadence = selection.single),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<SystemCategory>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Kategori'),
                items: const [
                  DropdownMenuItem(
                    value: SystemCategory.entertainment,
                    child: Text('Eğlence'),
                  ),
                  DropdownMenuItem(
                    value: SystemCategory.software,
                    child: Text('Yazılım'),
                  ),
                  DropdownMenuItem(
                    value: SystemCategory.communication,
                    child: Text('İletişim'),
                  ),
                  DropdownMenuItem(
                    value: SystemCategory.other,
                    child: Text('Diğer'),
                  ),
                ],
                onChanged: (value) =>
                    setState(() => _category = value ?? _category),
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('edit-payment-method'),
                controller: _paymentMethod,
                decoration: const InputDecoration(
                  labelText: 'Ödeme yöntemi takma adı (isteğe bağlı)',
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Sonraki ödeme tarihi'),
                subtitle: Text(_date(_dateValue)),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              if (_saveError != null) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _saveError!,
                    key: const Key('edit-payment-error'),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: _saving ? null : () => Navigator.pop(context),
        child: const Text('Vazgeç'),
      ),
      FilledButton(
        key: const Key('save-edit-payment'),
        onPressed: _saving ? null : _save,
        child: _saving
            ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Kaydet'),
      ),
    ],
  );

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _dateValue.atLocalTime(),
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
    );
    if (selected != null) {
      setState(() => _dateValue = LocalDate.fromDateTime(selected));
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _saveError = null;
    });
    try {
      final result = await widget.updateRecurringPayment(
        existing: widget.payment,
        name: _name.text,
        amountMinor: parseMinorUnits(_amount.text),
        currencyCode: _currencyCode,
        nextPaymentDate: _dateValue,
        paymentMethodNickname: _paymentMethod.text,
        category: _category,
        billingCadence: _billingCadence,
      );
      if (mounted) Navigator.pop(context, result);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _saveError = 'Abonelik güncellenemedi. Lütfen tekrar deneyin.';
      });
    }
  }
}

String _date(LocalDate value) =>
    DateFormat('dd.MM.yyyy').format(value.atLocalTime());

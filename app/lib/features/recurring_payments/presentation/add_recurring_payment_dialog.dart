import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/domain/billing_schedule.dart';
import '../../../core/domain/local_date.dart';
import '../../../core/domain/money.dart';
import '../application/add_recurring_payment.dart';
import '../domain/recurring_payment.dart';

class AddRecurringPaymentDialog extends StatefulWidget {
  const AddRecurringPaymentDialog({
    required this.addRecurringPayment,
    super.key,
  });

  final AddRecurringPayment addRecurringPayment;

  @override
  State<AddRecurringPaymentDialog> createState() =>
      _AddRecurringPaymentDialogState();
}

class _AddRecurringPaymentDialogState extends State<AddRecurringPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _amount = TextEditingController();
  final _currency = TextEditingController(text: 'TRY');
  final _paymentMethod = TextEditingController();
  LocalDate? _dateValue;
  SystemCategory _category = SystemCategory.entertainment;
  BillingCadence _billingCadence = BillingCadence.monthly;
  bool _saving = false;
  String? _saveError;

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    _currency.dispose();
    _paymentMethod.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
    titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
    contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
    actionsPadding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
    title: const Text('Düzenli ödeme ekle'),
    content: SizedBox(
      width: 420,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                key: const Key('payment-name'),
                controller: _name,
                decoration: const InputDecoration(labelText: 'Ad'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Ad zorunludur.'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('payment-amount'),
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
              TextFormField(
                key: const Key('payment-currency'),
                controller: _currency,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Para birimi kodu',
                ),
                validator: (value) =>
                    RegExp(r'^[A-Za-z]{3}$').hasMatch(value?.trim() ?? '')
                    ? null
                    : 'Üç harfli kod girin.',
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
                controller: _paymentMethod,
                decoration: const InputDecoration(
                  labelText: 'Ödeme yöntemi takma adı (isteğe bağlı)',
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Sonraki ödeme tarihi'),
                subtitle: Text(
                  _dateValue == null ? 'Tarih seçin' : _date(_dateValue!),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              if (_dateValue == null)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tarih zorunludur.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              if (_saveError != null) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _saveError!,
                    key: const Key('save-payment-error'),
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
        key: const Key('save-payment'),
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
      initialDate: _dateValue?.atLocalTime() ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
    );
    if (selected != null) {
      setState(() => _dateValue = LocalDate.fromDateTime(selected));
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _dateValue == null) {
      setState(() {});
      return;
    }
    setState(() {
      _saving = true;
      _saveError = null;
    });
    try {
      final result = await widget.addRecurringPayment(
        name: _name.text,
        amountMinor: parseMinorUnits(_amount.text),
        currencyCode: _currency.text,
        nextPaymentDate: _dateValue!,
        paymentMethodNickname: _paymentMethod.text,
        category: _category,
        billingCadence: _billingCadence,
      );
      if (mounted) Navigator.pop(context, result);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _saveError = 'Abonelik kaydedilemedi. Lütfen tekrar deneyin.';
      });
    }
  }
}

String _date(LocalDate value) =>
    DateFormat('dd.MM.yyyy').format(value.atLocalTime());

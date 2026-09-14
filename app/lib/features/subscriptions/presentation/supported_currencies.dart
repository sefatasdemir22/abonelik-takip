import 'package:flutter/material.dart';

import '../../recurring_payments/application/supported_recurring_payment_currencies.dart';

final class SupportedCurrency {
  const SupportedCurrency({required this.code, required this.label});

  final String code;
  final String label;
}

const _currencyLabels = {
  'TRY': 'Türk Lirası',
  'USD': 'ABD Doları',
  'EUR': 'Euro',
  'GBP': 'İngiliz Sterlini',
};

final supportedCurrencies = [
  for (final code in supportedRecurringPaymentCurrencyCodes)
    SupportedCurrency(code: code, label: _currencyLabels[code]!),
];

class CurrencySelector extends StatelessWidget {
  const CurrencySelector({
    required this.value,
    required this.onChanged,
    this.legacyCurrencyCode,
    super.key,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String? legacyCurrencyCode;

  @override
  Widget build(BuildContext context) {
    final legacyCode = legacyCurrencyCode?.trim().toUpperCase();
    final hasLegacyOption =
        legacyCode != null &&
        legacyCode.isNotEmpty &&
        !supportedCurrencies.any((currency) => currency.code == legacyCode);
    return DropdownButtonFormField<String>(
      key: const Key('payment-currency'),
      initialValue: value,
      decoration: const InputDecoration(labelText: 'Para birimi'),
      items: [
        for (final currency in supportedCurrencies)
          DropdownMenuItem(
            value: currency.code,
            child: Text('${currency.code} — ${currency.label}'),
          ),
        if (hasLegacyOption)
          DropdownMenuItem(
            value: legacyCode,
            child: Text('$legacyCode — Mevcut para birimi'),
          ),
      ],
      onChanged: (currency) {
        if (currency != null) onChanged(currency);
      },
    );
  }
}

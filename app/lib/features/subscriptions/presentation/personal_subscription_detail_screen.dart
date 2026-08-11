import 'package:flutter/material.dart';

import '../../../core/domain/billing_schedule.dart';
import '../../../core/domain/local_date.dart';
import '../../../core/domain/money.dart';
import '../../recurring_payments/domain/recurring_payment.dart';

class PersonalSubscriptionDetailScreen extends StatelessWidget {
  const PersonalSubscriptionDetailScreen({required this.payment, super.key});

  final RecurringPayment payment;

  @override
  Widget build(BuildContext context) {
    final paymentMethod = payment.paymentMethodNickname?.trim();
    return Scaffold(
      appBar: AppBar(title: const Text('Abonelik detayı')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _DetailHeader(payment: payment),
          const SizedBox(height: 16),
          _DetailSurface(
            children: [
              _DetailField(
                icon: Icons.calendar_today_outlined,
                label: 'Sonraki ödeme tarihi',
                value: _formatLocalDate(payment.nextPaymentDate),
              ),
              const SizedBox(height: 18),
              _DetailField(
                icon: Icons.repeat_rounded,
                label: 'Ödeme periyodu',
                value: _cadenceLabel(payment.billingSchedule.cadence),
              ),
              const SizedBox(height: 18),
              _DetailField(
                icon: Icons.category_outlined,
                label: 'Kategori',
                value: _categoryLabel(payment.category),
              ),
              if (paymentMethod != null && paymentMethod.isNotEmpty) ...[
                const SizedBox(height: 18),
                _DetailField(
                  icon: Icons.credit_card_outlined,
                  label: 'Ödeme yöntemi',
                  value: paymentMethod,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.payment});

  final RecurringPayment payment;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(32),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Text(
            payment.name.substring(0, 1).toUpperCase(),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          payment.name,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          '${formatMinorUnits(payment.amountMinor)} ${payment.currencyCode}',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    ),
  );
}

class _DetailSurface extends StatelessWidget {
  const _DetailSurface({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(28),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.06),
          blurRadius: 14,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(children: children),
  );
}

class _DetailField extends StatelessWidget {
  const _DetailField({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 3),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    ],
  );
}

String _formatLocalDate(LocalDate date) {
  const months = [
    'Oca',
    'Şub',
    'Mar',
    'Nis',
    'May',
    'Haz',
    'Tem',
    'Ağu',
    'Eyl',
    'Eki',
    'Kas',
    'Ara',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

String _cadenceLabel(BillingCadence cadence) => switch (cadence) {
  BillingCadence.monthly => 'Aylık',
  BillingCadence.yearly => 'Yıllık',
};

String _categoryLabel(SystemCategory category) => switch (category) {
  SystemCategory.entertainment => 'Eğlence',
  SystemCategory.software => 'Yazılım',
  SystemCategory.communication => 'İletişim',
  SystemCategory.other => 'Diğer',
};

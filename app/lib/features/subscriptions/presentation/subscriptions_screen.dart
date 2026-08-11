import 'package:flutter/material.dart';

import '../../../core/domain/billing_schedule.dart';
import '../../../core/domain/local_date.dart';
import '../../../core/domain/money.dart';
import '../../recurring_payments/application/add_recurring_payment.dart';
import '../../recurring_payments/application/get_active_recurring_payments.dart';
import '../../recurring_payments/domain/recurring_payment.dart';
import '../../recurring_payments/presentation/add_recurring_payment_dialog.dart';

enum _SubscriptionView { personal, shared }

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({
    required this.addRecurringPayment,
    required this.getActiveRecurringPayments,
    required this.onPaymentAdded,
    super.key,
  });

  final AddRecurringPayment addRecurringPayment;
  final GetActiveRecurringPayments getActiveRecurringPayments;
  final Future<void> Function() onPaymentAdded;

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  _SubscriptionView _view = _SubscriptionView.personal;
  bool _loading = true;
  Object? _loadError;
  List<RecurringPayment> _payments = const [];

  @override
  void initState() {
    super.initState();
    _loadPayments();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Aboneliklerim')),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        _SubscriptionSelector(
          selected: _view,
          onChanged: (view) => setState(() => _view = view),
        ),
        const SizedBox(height: 24),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: _view == _SubscriptionView.personal
              ? _buildPersonalContent()
              : const _SubscriptionEmptyPanel(
                  key: ValueKey('shared'),
                  icon: Icons.group_outlined,
                  title: 'Paylaşılan abonelikler',
                  description:
                      'Arkadaşlarınla paylaştığın abonelikleri ve ödeme takibini burada göreceksin.',
                ),
        ),
      ],
    ),
    floatingActionButton: _view == _SubscriptionView.personal
        ? FloatingActionButton.extended(
            onPressed: _addPayment,
            icon: const Icon(Icons.add),
            label: const Text('Abonelik ekle'),
          )
        : null,
  );

  Widget _buildPersonalContent() {
    if (_loading) {
      return const Center(
        key: ValueKey('personal-loading'),
        child: Padding(
          padding: EdgeInsets.all(48),
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (_loadError != null) {
      return _SubscriptionErrorPanel(
        key: const ValueKey('personal-error'),
        onRetry: _loadPayments,
      );
    }
    if (_payments.isEmpty) {
      return const _SubscriptionEmptyPanel(
        key: ValueKey('personal-empty'),
        icon: Icons.wallet_outlined,
        title: 'Kişisel aboneliklerin',
        description:
            'Kendi düzenli ödemelerin ve yenileme tarihlerin burada görünecek.',
      );
    }
    return Column(
      key: const ValueKey('personal-populated'),
      children: [
        for (final payment in _payments) ...[
          _PersonalSubscriptionCard(payment: payment),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Future<void> _loadPayments() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _loadError = null;
      });
    }
    try {
      final payments = await widget.getActiveRecurringPayments();
      if (!mounted) return;
      setState(() {
        _payments = payments;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loadError = error;
        _loading = false;
      });
    }
  }

  Future<void> _addPayment() async {
    final result = await showDialog<AddRecurringPaymentResult>(
      context: context,
      builder: (_) => AddRecurringPaymentDialog(
        addRecurringPayment: widget.addRecurringPayment,
      ),
    );
    if (result == null || !mounted) return;
    await _loadPayments();
    if (!mounted) return;
    await widget.onPaymentAdded();
    if (!mounted || !result.notificationFailed) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Abonelik kaydedildi ancak bildirim ayarlanamadı.'),
      ),
    );
  }
}

class _PersonalSubscriptionCard extends StatelessWidget {
  const _PersonalSubscriptionCard({required this.payment});

  final RecurringPayment payment;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(28),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.07),
          blurRadius: 14,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            payment.name.substring(0, 1).toUpperCase(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                payment.name,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                '${formatMinorUnits(payment.amountMinor)} ${payment.currencyCode}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              Text(_formatLocalDate(payment.nextPaymentDate)),
              const SizedBox(height: 3),
              Text(_cadenceLabel(payment.billingSchedule.cadence)),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SubscriptionErrorPanel extends StatelessWidget {
  const _SubscriptionErrorPanel({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.errorContainer,
      borderRadius: BorderRadius.circular(28),
    ),
    child: Column(
      children: [
        const Icon(Icons.error_outline, size: 36),
        const SizedBox(height: 12),
        const Text('Abonelikler yüklenemedi.'),
        const SizedBox(height: 12),
        FilledButton.tonal(
          onPressed: onRetry,
          child: const Text('Tekrar dene'),
        ),
      ],
    ),
  );
}

class _SubscriptionSelector extends StatelessWidget {
  const _SubscriptionSelector({
    required this.selected,
    required this.onChanged,
  });

  final _SubscriptionView selected;
  final ValueChanged<_SubscriptionView> onChanged;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      children: [
        _SubscriptionOption(
          label: 'Kişisel',
          icon: Icons.person_outline,
          selected: selected == _SubscriptionView.personal,
          onTap: () => onChanged(_SubscriptionView.personal),
        ),
        const SizedBox(width: 8),
        _SubscriptionOption(
          label: 'Paylaşılan',
          icon: Icons.people_outline,
          selected: selected == _SubscriptionView.shared,
          onTap: () => onChanged(_SubscriptionView.shared),
        ),
      ],
    ),
  );
}

class _SubscriptionOption extends StatelessWidget {
  const _SubscriptionOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          constraints: const BoxConstraints(minHeight: 56),
          decoration: BoxDecoration(
            color: selected
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(24),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.shadow.withValues(alpha: 0.10),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _SubscriptionEmptyPanel extends StatelessWidget {
  const _SubscriptionEmptyPanel({
    required this.icon,
    required this.title,
    required this.description,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 44),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(32),
    ),
    child: Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 34),
        ),
        const SizedBox(height: 22),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(description, textAlign: TextAlign.center),
      ],
    ),
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

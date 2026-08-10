import 'package:flutter/material.dart';

import '../../recurring_payments/application/add_recurring_payment.dart';
import '../../recurring_payments/presentation/add_recurring_payment_dialog.dart';

enum _SubscriptionView { personal, shared }

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({
    required this.addRecurringPayment,
    required this.onPaymentAdded,
    super.key,
  });

  final AddRecurringPayment addRecurringPayment;
  final Future<void> Function() onPaymentAdded;

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  _SubscriptionView _view = _SubscriptionView.personal;

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
              ? const _SubscriptionEmptyPanel(
                  key: ValueKey('personal'),
                  icon: Icons.wallet_outlined,
                  title: 'Kişisel aboneliklerin',
                  description:
                      'Kendi düzenli ödemelerin ve yenileme tarihlerin burada görünecek.',
                )
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
    floatingActionButton: FloatingActionButton.extended(
      onPressed: _addPayment,
      icon: const Icon(Icons.add),
      label: const Text('Abonelik ekle'),
    ),
  );

  Future<void> _addPayment() async {
    final added = await showDialog<bool>(
      context: context,
      builder: (_) => AddRecurringPaymentDialog(
        addRecurringPayment: widget.addRecurringPayment,
      ),
    );
    if (added == true) await widget.onPaymentAdded();
  }
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

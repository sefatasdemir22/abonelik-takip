import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/domain/billing_schedule.dart';
import '../../../core/domain/local_date.dart';
import '../../../core/domain/money.dart';
import '../../payment_occurrences/domain/payment_occurrence.dart';
import '../../recurring_payments/domain/recurring_payment.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({
    required this.controllerProvider,
    required this.onOpenAnalysis,
    required this.onOpenFamily,
    required this.onOpenSettlements,
    super.key,
  });

  final StateNotifierProvider<DashboardController, DashboardState>
  controllerProvider;
  final VoidCallback onOpenAnalysis;
  final VoidCallback onOpenFamily;
  final VoidCallback onOpenSettlements;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(controllerProvider);
    final controller = ref.read(controllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('Ana Sayfa')),
      body: state.loading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
          ? _ErrorView(message: state.error!, onRetry: controller.load)
          : RefreshIndicator(
              onRefresh: controller.load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  if (state.payments.isEmpty)
                    const _EmptyState()
                  else
                    _NextPaymentCard(payment: state.payments.first),
                  const SizedBox(height: 24),
                  const _SectionTitle(title: 'Kısayollar'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _ShortcutCard(
                          label: 'Analiz',
                          icon: Icons.analytics_outlined,
                          onTap: onOpenAnalysis,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ShortcutCard(
                          label: 'Ailem',
                          icon: Icons.people_outline,
                          onTap: onOpenFamily,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ShortcutCard(
                          label: 'Hesaplaşma',
                          icon: Icons.handshake_outlined,
                          onTap: onOpenSettlements,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle(title: 'Bu ay'),
                  const SizedBox(height: 12),
                  if (state.summaries.isEmpty)
                    const Text('Bu ay için planlanan ödeme bulunmuyor.')
                  else
                    ...state.summaries.map(
                      (summary) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _SummaryCard(summary: summary),
                      ),
                    ),
                  if (state.awaiting.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const _SectionTitle(title: 'Onay bekleyenler'),
                    const SizedBox(height: 12),
                    for (final occurrence in state.awaiting)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _OccurrenceCard(
                          occurrence: occurrence,
                          onPaid: () => controller.markPaid(occurrence),
                          onSkipped: () => controller.markSkipped(occurrence),
                        ),
                      ),
                  ],
                  if (state.payments.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const _SectionTitle(title: 'Yaklaşan abonelikler'),
                    const SizedBox(height: 12),
                    for (final payment in state.payments)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _UpcomingPaymentCard(payment: payment),
                      ),
                  ],
                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  const _ShortcutCard({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surfaceContainerLow,
    borderRadius: BorderRadius.circular(24),
    child: InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 92),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon),
              const SizedBox(height: 8),
              Text(
                label,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _NextPaymentCard extends StatelessWidget {
  const _NextPaymentCard({required this.payment});

  final RecurringPayment payment;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: [colors.surfaceContainerHigh, colors.surfaceContainerLow],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? colors.shadow : colors.primary).withValues(
              alpha: isDark ? 0.20 : 0.12,
            ),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sıradaki ödeme',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: colors.primary),
            ),
            const SizedBox(height: 12),
            Text(
              payment.name,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            Text(
              '${formatMinorUnits(payment.amountMinor)} ${payment.currencyCode}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoPill(
                  icon: Icons.calendar_today_outlined,
                  label: _date(payment.nextPaymentDate),
                ),
                _InfoPill(
                  icon: Icons.autorenew_rounded,
                  label: _cadence(payment),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Text(
    title,
    style: Theme.of(
      context,
    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
  );
}

class _UpcomingPaymentCard extends StatelessWidget {
  const _UpcomingPaymentCard({required this.payment});

  final RecurringPayment payment;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(26),
    ),
    child: Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(19),
          ),
          child: const Icon(Icons.calendar_month_outlined),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                payment.name,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text('${_date(payment.nextPaymentDate)} • ${_cadence(payment)}'),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${formatMinorUnits(payment.amountMinor)}\n${payment.currencyCode}',
          textAlign: TextAlign.end,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    ),
  );
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.62),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}

class _OccurrenceCard extends StatelessWidget {
  const _OccurrenceCard({
    required this.occurrence,
    required this.onPaid,
    required this.onSkipped,
  });

  final PaymentOccurrence occurrence;
  final VoidCallback onPaid;
  final VoidCallback onSkipped;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(28),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            occurrence.paymentName,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            '${formatMinorUnits(occurrence.expectedAmountMinor)} ${occurrence.currencyCode} • ${_date(occurrence.expectedDate)}',
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: const Size(96, 48),
                  shape: const StadiumBorder(),
                ),
                onPressed: onSkipped,
                child: const Text('Atlandı'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                style: FilledButton.styleFrom(shape: const StadiumBorder()),
                onPressed: onPaid,
                child: const Text('Ödendi'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary});

  final CurrencyMonthlySummary summary;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            summary.currencyCode,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _SummaryLine(
            label: 'Planlanan',
            value: summary.plannedMonthEndMinor,
            currencyCode: summary.currencyCode,
          ),
          _SummaryLine(
            label: 'Ödenen',
            value: summary.paidMinor,
            currencyCode: summary.currencyCode,
          ),
          _SummaryLine(
            label: 'Onay bekleyen',
            value: summary.awaitingMinor,
            currencyCode: summary.currencyCode,
          ),
        ],
      ),
    ),
  );
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.label,
    required this.value,
    required this.currencyCode,
  });

  final String label;
  final int value;
  final String currencyCode;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 8),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          '${formatMinorUnits(value)} $currencyCode',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ],
    ),
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(32),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(32),
    ),
    child: const Column(
      children: [
        Icon(Icons.subscriptions_outlined, size: 48),
        SizedBox(height: 12),
        Text('Henüz abonelik yok'),
        SizedBox(height: 6),
        Text(
          'İlk aboneliğini ekleyerek yaklaşan ödemelerini takip et.',
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('Tekrar dene')),
        ],
      ),
    ),
  );
}

class AddPaymentDialog extends ConsumerStatefulWidget {
  const AddPaymentDialog({required this.controllerProvider, super.key});

  final StateNotifierProvider<DashboardController, DashboardState>
  controllerProvider;

  @override
  ConsumerState<AddPaymentDialog> createState() => _AddPaymentDialogState();
}

class _AddPaymentDialogState extends ConsumerState<AddPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _amount = TextEditingController();
  final _currency = TextEditingController(text: 'TRY');
  final _paymentMethod = TextEditingController();
  LocalDate? _dateValue;
  SystemCategory _category = SystemCategory.entertainment;
  BillingCadence _billingCadence = BillingCadence.monthly;
  bool _saving = false;

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
    setState(() => _saving = true);
    await ref
        .read(widget.controllerProvider.notifier)
        .addPayment(
          name: _name.text,
          amountMinor: parseMinorUnits(_amount.text),
          currencyCode: _currency.text,
          nextPaymentDate: _dateValue!,
          paymentMethodNickname: _paymentMethod.text,
          category: _category,
          billingCadence: _billingCadence,
        );
    if (mounted) Navigator.pop(context);
  }
}

String _date(LocalDate value) =>
    DateFormat('dd.MM.yyyy').format(value.atLocalTime());

String _cadence(RecurringPayment payment) =>
    payment.billingSchedule.cadence == BillingCadence.monthly
    ? 'Aylık'
    : 'Yıllık';

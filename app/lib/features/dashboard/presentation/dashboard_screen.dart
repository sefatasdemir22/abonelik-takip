import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/domain/local_date.dart';
import '../../../core/domain/money.dart';
import '../../payment_occurrences/domain/payment_occurrence.dart';
import '../../recurring_payments/domain/recurring_payment.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({required this.controllerProvider, super.key});

  final StateNotifierProvider<DashboardController, DashboardState>
  controllerProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(controllerProvider);
    final controller = ref.read(controllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('Düzenli Ödemelerim')),
      body: state.loading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
          ? _ErrorView(message: state.error!, onRetry: controller.load)
          : RefreshIndicator(
              onRefresh: controller.load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (state.payments.isEmpty)
                    const _EmptyState()
                  else
                    _NextPaymentCard(payment: state.payments.first),
                  const SizedBox(height: 20),
                  if (state.awaiting.isNotEmpty) ...[
                    Text(
                      'Onay bekleyenler',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    for (final occurrence in state.awaiting)
                      _OccurrenceCard(
                        occurrence: occurrence,
                        onPaid: () => controller.markPaid(occurrence),
                        onSkipped: () => controller.markSkipped(occurrence),
                      ),
                    const SizedBox(height: 12),
                  ],
                  Text('Bu ay', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  if (state.summaries.isEmpty)
                    const Text('Bu ay için henüz planlanan ödeme yok.')
                  else
                    for (final summary in state.summaries)
                      _SummaryCard(summary: summary),
                  const SizedBox(height: 20),
                  Text(
                    'Düzenli ödemeler',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  for (final payment in state.payments)
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.autorenew),
                        title: Text(payment.name),
                        subtitle: Text(
                          '${formatMinorUnits(payment.amountMinor)} ${payment.currencyCode} • ${_date(payment.nextPaymentDate)}',
                        ),
                        trailing: payment.paymentMethodNickname == null
                            ? null
                            : Text(payment.paymentMethodNickname!),
                      ),
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog<void>(
          context: context,
          builder: (_) =>
              _AddPaymentDialog(controllerProvider: controllerProvider),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Ödeme ekle'),
      ),
    );
  }
}

class _NextPaymentCard extends StatelessWidget {
  const _NextPaymentCard({required this.payment});

  final RecurringPayment payment;

  @override
  Widget build(BuildContext context) => Card(
    color: Theme.of(context).colorScheme.primaryContainer,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sıradaki', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Text(payment.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            '${formatMinorUnits(payment.amountMinor)} ${payment.currencyCode} • ${_date(payment.nextPaymentDate)}',
          ),
        ],
      ),
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
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(occurrence.paymentName),
          Text(
            '${formatMinorUnits(occurrence.expectedAmountMinor)} ${occurrence.currencyCode} • ${_date(occurrence.expectedDate)}',
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: onSkipped, child: const Text('Atlandı')),
              const SizedBox(width: 8),
              FilledButton(onPressed: onPaid, child: const Text('Ödendi')),
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
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            summary.currencyCode,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          _SummaryLine(label: 'Ödendi', value: summary.paidMinor),
          _SummaryLine(label: 'Onay bekliyor', value: summary.awaitingMinor),
          _SummaryLine(
            label: 'Kalan tahmin',
            value: summary.remainingPlannedMinor,
          ),
          const Divider(),
          _SummaryLine(
            label: 'Ay sonu planlanan',
            value: summary.plannedMonthEndMinor,
          ),
        ],
      ),
    ),
  );
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.label, required this.value});
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [Text(label), Text(formatMinorUnits(value))],
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) => const Card(
    child: Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(Icons.calendar_month_outlined, size: 48),
          SizedBox(height: 12),
          Text('İlk düzenli ödemeni ekle'),
          SizedBox(height: 4),
          Text('Yaklaşan tarihleri ve aylık yükünü tek yerde gör.'),
        ],
      ),
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

class _AddPaymentDialog extends ConsumerStatefulWidget {
  const _AddPaymentDialog({required this.controllerProvider});

  final StateNotifierProvider<DashboardController, DashboardState>
  controllerProvider;

  @override
  ConsumerState<_AddPaymentDialog> createState() => _AddPaymentDialogState();
}

class _AddPaymentDialogState extends ConsumerState<_AddPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _amount = TextEditingController();
  final _currency = TextEditingController(text: 'TRY');
  final _paymentMethod = TextEditingController();
  LocalDate? _dateValue;
  SystemCategory _category = SystemCategory.entertainment;
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
                decoration: const InputDecoration(labelText: 'Aylık tutar'),
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
        );
    if (mounted) Navigator.pop(context);
  }
}

String _date(LocalDate value) =>
    DateFormat('dd.MM.yyyy').format(value.atLocalTime());

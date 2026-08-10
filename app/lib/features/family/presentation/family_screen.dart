import 'package:flutter/material.dart';

class FamilyScreen extends StatelessWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Ailem')),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: const [
        _FamilyIntro(),
        SizedBox(height: 18),
        _FamilyArea(icon: Icons.people_outline, title: 'Aile üyeleri'),
        SizedBox(height: 12),
        _FamilyArea(icon: Icons.savings_outlined, title: 'Ortak bütçe'),
        SizedBox(height: 12),
        _FamilyArea(
          icon: Icons.subscriptions_outlined,
          title: 'Aile abonelikleri',
        ),
        SizedBox(height: 12),
        _FamilyArea(icon: Icons.receipt_long_outlined, title: 'Ortak giderler'),
      ],
    ),
  );
}

class _FamilyIntro extends StatelessWidget {
  const _FamilyIntro();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(32),
    ),
    child: const Column(
      children: [
        Icon(Icons.family_restroom_outlined, size: 52),
        SizedBox(height: 16),
        Text(
          'Henüz aile oluşturulmadı',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 8),
        Text(
          'Aile alanları hazır olduğunda ortak finans görünümün burada olacak.',
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

class _FamilyArea extends StatelessWidget {
  const _FamilyArea({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(26),
    ),
    child: Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(icon),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          Icons.chevron_right_rounded,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ],
    ),
  );
}

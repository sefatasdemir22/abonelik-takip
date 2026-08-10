import 'package:flutter/material.dart';

class SettlementsScreen extends StatelessWidget {
  const SettlementsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Hesaplaşma')),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: const [
        _SettlementArea(icon: Icons.call_received, title: 'Sana ödenecekler'),
        SizedBox(height: 14),
        _SettlementArea(icon: Icons.call_made, title: 'Senin ödeyeceklerin'),
        SizedBox(height: 14),
        _SettlementArea(icon: Icons.schedule, title: 'Bekleyen hesaplaşmalar'),
        SizedBox(height: 14),
        _SettlementArea(
          icon: Icons.check_circle_outline,
          title: 'Tamamlananlar',
        ),
      ],
    ),
  );
}

class _SettlementArea extends StatelessWidget {
  const _SettlementArea({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(30),
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
          child: Icon(icon),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 5),
              const Text('Veri oluştukça burada görünecek.'),
            ],
          ),
        ),
      ],
    ),
  );
}

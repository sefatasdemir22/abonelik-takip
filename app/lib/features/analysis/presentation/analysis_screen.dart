import 'package:flutter/material.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Analiz')),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: const [
        _AnalysisPreview(
          icon: Icons.calendar_view_month_outlined,
          title: 'Aylık görünüm',
          description:
              'Ödeme verisi oluştukça aylık görünüm burada yer alacak.',
        ),
        SizedBox(height: 16),
        _AnalysisPreview(
          icon: Icons.donut_large_outlined,
          title: 'Kategori dağılımı',
          description: 'Veri oluştukça kategori dağılımı burada görünecek.',
        ),
        SizedBox(height: 16),
        _AnalysisPreview(
          icon: Icons.upcoming_outlined,
          title: 'Yaklaşan yük',
          description: 'Yaklaşan ödeme verileri burada özetlenecek.',
        ),
      ],
    ),
  );
}

class _AnalysisPreview extends StatelessWidget {
  const _AnalysisPreview({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(description),
            ],
          ),
        ),
      ],
    ),
  );
}

import 'package:flutter/material.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Analiz')),
    body: const Center(
      child: Text('Harcama ve abonelik analizleri burada olacak.'),
    ),
  );
}

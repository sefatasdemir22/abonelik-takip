import 'package:flutter/material.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Abonelikler')),
    body: const Center(
      child: Text('Kişisel ve paylaşılan abonelikler burada olacak.'),
    ),
  );
}

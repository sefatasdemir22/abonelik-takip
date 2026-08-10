import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Profil')),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        _SettingsGroup(
          title: 'Görünüm',
          children: [
            PopupMenuButton<ThemeMode>(
              initialValue: themeMode,
              onSelected: onThemeModeChanged,
              itemBuilder: (context) => ThemeMode.values
                  .map(
                    (mode) => PopupMenuItem(
                      value: mode,
                      child: Text(_themeLabel(mode)),
                    ),
                  )
                  .toList(growable: false),
              child: _SettingsRow(
                icon: Icons.palette_outlined,
                title: 'Tema',
                value: _themeLabel(themeMode),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const _SettingsGroup(
          title: 'Bildirimler',
          children: [
            _SettingsRow(
              icon: Icons.notifications_outlined,
              title: 'Ödeme hatırlatmaları',
              value: 'Daha sonra yapılandırılacak',
              valueBelow: true,
            ),
          ],
        ),
        const SizedBox(height: 16),
        const _SettingsGroup(
          title: 'Tercihler',
          children: [
            _SettingsRow(
              icon: Icons.tune_outlined,
              title: 'Uygulama tercihleri',
              value: 'Daha sonra eklenecek',
              valueBelow: true,
            ),
          ],
        ),
        const SizedBox(height: 16),
        const _SettingsGroup(
          title: 'Uygulama',
          children: [
            _SettingsRow(
              icon: Icons.info_outline,
              title: 'Hakkında',
              value: 'Abonelik Takip',
            ),
          ],
        ),
      ],
    ),
  );
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        ...children,
      ],
    ),
  );
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.value,
    this.valueBelow = false,
  });

  final IconData icon;
  final String title;
  final String value;
  final bool valueBelow;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 56),
    child: Row(
      children: [
        Icon(icon),
        const SizedBox(width: 14),
        if (valueBelow)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          )
        else ...[
          Expanded(child: Text(title)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ],
    ),
  );
}

String _themeLabel(ThemeMode mode) => switch (mode) {
  ThemeMode.system => 'Sistem',
  ThemeMode.light => 'Açık',
  ThemeMode.dark => 'Koyu',
};

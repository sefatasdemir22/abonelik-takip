import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/analysis/presentation/analysis_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/family/presentation/family_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/settlements/presentation/settlements_screen.dart';
import '../features/subscriptions/presentation/subscriptions_screen.dart';
import 'providers.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  static const _homeIndex = 2;
  static const _analysisIndex = 5;

  int _selectedIndex = _homeIndex;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        IndexedStack(
          index: _selectedIndex,
          children: [
            SubscriptionsScreen(
              addRecurringPayment: ref.watch(addRecurringPaymentProvider),
              getActiveRecurringPayments: ref.watch(
                getActiveRecurringPaymentsProvider,
              ),
              onPaymentAdded: () =>
                  ref.read(dashboardControllerProvider.notifier).load(),
            ),
            const FamilyScreen(),
            DashboardScreen(
              controllerProvider: dashboardControllerProvider,
              onOpenAnalysis: () => _select(_analysisIndex),
              onOpenFamily: () => _select(1),
              onOpenSettlements: () => _select(3),
            ),
            const SettlementsScreen(),
            ProfileScreen(
              themeMode: widget.themeMode,
              onThemeModeChanged: widget.onThemeModeChanged,
            ),
            const AnalysisScreen(),
          ],
        ),
        if (_selectedIndex == _homeIndex)
          Positioned(
            top: 4,
            right: 16,
            child: SafeArea(
              child: _HomeViewControl(
                themeMode: widget.themeMode,
                onChanged: widget.onThemeModeChanged,
              ),
            ),
          ),
      ],
    ),
    bottomNavigationBar: SafeArea(
      minimum: const EdgeInsets.fromLTRB(10, 4, 10, 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).colorScheme.shadow.withValues(alpha: 0.10),
              blurRadius: 22,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _ShellDestination(
                label: 'Aboneliklerim',
                icon: Icons.subscriptions_outlined,
                selectedIcon: Icons.subscriptions,
                selected: _selectedIndex == 0,
                onTap: () => _select(0),
              ),
              const SizedBox(width: 4),
              _ShellDestination(
                label: 'Ailem',
                icon: Icons.people_outline,
                selectedIcon: Icons.people,
                selected: _selectedIndex == 1,
                onTap: () => _select(1),
              ),
              const SizedBox(width: 4),
              _ShellDestination(
                label: 'Ana Sayfa',
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                selected: _selectedIndex == _homeIndex,
                prominent: true,
                onTap: () => _select(_homeIndex),
              ),
              const SizedBox(width: 4),
              _ShellDestination(
                label: 'Hesaplaşma',
                icon: Icons.handshake_outlined,
                selectedIcon: Icons.handshake,
                selected: _selectedIndex == 3,
                onTap: () => _select(3),
              ),
              const SizedBox(width: 4),
              _ShellDestination(
                label: 'Profil',
                icon: Icons.person_outline,
                selectedIcon: Icons.person,
                selected: _selectedIndex == 4,
                onTap: () => _select(4),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  void _select(int index) => setState(() => _selectedIndex = index);
}

class _ShellDestination extends StatelessWidget {
  const _ShellDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.onTap,
    this.prominent = false,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool selected;
  final VoidCallback onTap;
  final bool prominent;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Transform.translate(
      offset: Offset(0, prominent ? -5 : 0),
      child: Semantics(
        selected: selected,
        button: true,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            constraints: BoxConstraints(minHeight: prominent ? 64 : 56),
            decoration: BoxDecoration(
              color: selected
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(prominent ? 25 : 22),
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
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(selected ? selectedIcon : icon, size: prominent ? 25 : 22),
                const SizedBox(height: 3),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _HomeViewControl extends StatelessWidget {
  const _HomeViewControl({required this.themeMode, required this.onChanged});

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surfaceContainerHigh,
    shape: const CircleBorder(),
    child: PopupMenuButton<ThemeMode>(
      tooltip: 'Ana Sayfa görünümü',
      icon: const Icon(Icons.tune_rounded),
      initialValue: themeMode,
      onSelected: onChanged,
      itemBuilder: (context) => [
        const PopupMenuItem<ThemeMode>(
          enabled: false,
          child: Text('Tema', style: TextStyle(fontWeight: FontWeight.w700)),
        ),
        for (final mode in ThemeMode.values)
          PopupMenuItem(
            value: mode,
            child: Row(
              children: [
                Icon(_themeIcon(mode), size: 20),
                const SizedBox(width: 12),
                Text(_themeLabel(mode)),
                if (mode == themeMode) ...[
                  const Spacer(),
                  const Icon(Icons.check, size: 20),
                ],
              ],
            ),
          ),
        const PopupMenuItem<ThemeMode>(
          enabled: false,
          child: Text(
            'Ana sayfa düzenleme seçenekleri daha sonra burada olacak.',
          ),
        ),
      ],
    ),
  );
}

String _themeLabel(ThemeMode mode) => switch (mode) {
  ThemeMode.system => 'Sistem',
  ThemeMode.light => 'Açık',
  ThemeMode.dark => 'Koyu',
};

IconData _themeIcon(ThemeMode mode) => switch (mode) {
  ThemeMode.system => Icons.brightness_auto_outlined,
  ThemeMode.light => Icons.light_mode_outlined,
  ThemeMode.dark => Icons.dark_mode_outlined,
};

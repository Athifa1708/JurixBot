import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';

class MainScaffold extends ConsumerStatefulWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/chat')) return 1;
    if (location.startsWith('/explore')) return 2;
    if (location.startsWith('/complaints')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/chat');
        break;
      case 2:
        context.go('/explore');
        break;
      case 3:
        context.go('/complaints');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateSelectedIndex(context);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context); // nullable during initialization sometimes, better to use ! if sure or fallback

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: widget.child,
      bottomNavigationBar: Container(
        color: theme.scaffoldBackgroundColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavBarItem(
                  icon: Icons.home_rounded,
                  label: l10n?.navHome ?? 'Home',
                  isSelected: currentIndex == 0,
                  onTap: () => _onItemTapped(0, context),
                ),
                _NavBarItem(
                  icon: Icons.chat_bubble_rounded,
                  label: l10n?.navChat ?? 'Chat',
                  isSelected: currentIndex == 1,
                  onTap: () => _onItemTapped(1, context),
                ),
                _NavBarItem(
                  icon: Icons.explore_rounded,
                  label: l10n?.navExplore ?? 'Explore',
                  isSelected: currentIndex == 2,
                  onTap: () => _onItemTapped(2, context),
                ),
                _NavBarItem(
                  icon: Icons.edit_document,
                  label: l10n?.navDrafts ?? 'Drafts',
                  isSelected: currentIndex == 3,
                  onTap: () => _onItemTapped(3, context),
                ),
                _NavBarItem(
                  icon: Icons.person_rounded,
                  label: l10n?.navProfile ?? 'Profile',
                  isSelected: currentIndex == 4,
                  onTap: () => _onItemTapped(4, context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Smooth, subtle color transition
    final color = isSelected 
        ? theme.colorScheme.primary 
        : theme.colorScheme.onSurface.withOpacity(0.4);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                // Extremely subtle highlight, avoiding "large colored box" look
                color: isSelected 
                    ? theme.colorScheme.primary.withOpacity(0.08) 
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: AnimatedTheme(
                data: theme,
                child: Icon(icon, color: color, size: 26),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontFamily: theme.textTheme.bodyMedium?.fontFamily,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

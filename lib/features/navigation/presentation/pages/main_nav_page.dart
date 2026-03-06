import 'package:cse_edge/features/community/presentation/pages/community_page.dart';
import 'package:cse_edge/features/profile/presentation/pages/profile_page.dart';
import 'package:cse_edge/features/resources/presentation/pages/resource_vault_page.dart';
import 'package:cse_edge/features/subjects/presentation/pages/subjects_home_page.dart';
import 'package:cse_edge/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

class MainNavPage extends StatefulWidget {
  final int initialYear;
  final int initialSemester;

  const MainNavPage({
    super.key,
    required this.initialYear,
    required this.initialSemester,
  });

  @override
  State<MainNavPage> createState() => _MainNavPageState();
}

class _MainNavPageState extends State<MainNavPage> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    SubjectsHomePage(
      initialYear: widget.initialYear,
      initialSemester: widget.initialSemester,
    ),
    const ResourceVaultPage(),
    const CommunityPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [
                colorScheme.surface.withOpacity(0.95),
                colorScheme.surfaceContainerHighest.withOpacity(0.92),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.08),
                blurRadius: 18,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.10),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                backgroundColor: Colors.transparent,
                indicatorColor: colorScheme.primary.withOpacity(0.16),
                height: 74,
                labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
                  (states) {
                    final selected = states.contains(WidgetState.selected);
                    return TextStyle(
                      fontSize: selected ? 13 : 12,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      letterSpacing: 0.2,
                    );
                  },
                ),
                iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
                  (states) {
                    final selected = states.contains(WidgetState.selected);
                    return IconThemeData(
                      size: selected ? 28 : 24,
                      color: selected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    );
                  },
                ),
              ),
              child: NavigationBar(
                selectedIndex: _currentIndex,
                elevation: 0,
                labelBehavior:
                    NavigationDestinationLabelBehavior.alwaysShow,
                animationDuration: const Duration(milliseconds: 500),
                onDestinationSelected: (index) {
                  setState(() => _currentIndex = index);
                },
                destinations: const [
                  NavigationDestination(
                    icon: _NavIconWrapper(
                      icon: Icons.menu_book_outlined,
                    ),
                    selectedIcon: _NavIconWrapper(
                      icon: Icons.menu_book_rounded,
                      isSelected: true,
                    ),
                    label: AppStrings.navSubjects,
                  ),
                  NavigationDestination(
                    icon: _NavIconWrapper(
                      icon: Icons.quiz_outlined,
                    ),
                    selectedIcon: _NavIconWrapper(
                      icon: Icons.quiz_rounded,
                      isSelected: true,
                    ),
                    label: AppStrings.navPractice,
                  ),
                  NavigationDestination(
                    icon: _NavIconWrapper(
                      icon: Icons.forum_outlined,
                    ),
                    selectedIcon: _NavIconWrapper(
                      icon: Icons.forum_rounded,
                      isSelected: true,
                    ),
                    label: AppStrings.navCommunity,
                  ),
                  NavigationDestination(
                    icon: _NavIconWrapper(
                      icon: Icons.person_outline_rounded,
                    ),
                    selectedIcon: _NavIconWrapper(
                      icon: Icons.person_rounded,
                      isSelected: true,
                    ),
                    label: AppStrings.navProfile,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavIconWrapper extends StatelessWidget {
  final IconData icon;
  final bool isSelected;

  const _NavIconWrapper({
    required this.icon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isSelected
            ? LinearGradient(
                colors: [
                  colorScheme.primary.withOpacity(0.18),
                  colorScheme.secondary.withOpacity(0.10),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
      ),
      child: Icon(icon),
    );
  }
}
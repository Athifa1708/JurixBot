import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/home/home_screen.dart';
import '../features/home/main_scaffold.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/onboarding/language_selection_screen.dart';
import '../features/chat/chat_screen.dart';
import '../features/explore/explore_screen.dart';
import '../features/emergency/sos_screen.dart';
import '../features/explore/pathway_screen.dart';
import '../features/explore/risk_screen.dart';
import '../features/legal_search/legal_search_screen.dart';
import '../features/drafts/draft_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/rights/rights_screen.dart';
import '../features/updates/updates_screen.dart';
import '../features/documents/analyze_screen.dart';

import '../main.dart'; // For SplashScreen
import '../core/storage/secure_storage.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreenWrapper(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/language-selection',
      builder: (context, state) => const LanguageSelectionScreen(),
    ),
    // ShellRoute wraps routes in the MainScaffold (Bottom Nav)
    ShellRoute(
      builder: (context, state, child) {
        return MainScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/chat',
          builder: (context, state) => const ChatScreen(),
        ),
        GoRoute(
          path: '/explore',
          builder: (context, state) => const ExploreScreen(),
        ),
        GoRoute(
          path: '/legal',
          builder: (context, state) => const LegalSearchScreen(),
        ),
        GoRoute(
          path: '/draft',
          builder: (context, state) => const DraftScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/rights',
          builder: (context, state) => const RightsScreen(),
        ),
        GoRoute(
          path: '/updates',
          builder: (context, state) => const UpdatesScreen(),
        ),
        GoRoute(
          path: '/analyze',
          builder: (context, state) => const AnalyzeScreen(),
        ),
        GoRoute(
          path: '/sos',
          builder: (context, state) => const SOSScreen(),
        ),
        GoRoute(
          path: '/pathway',
          builder: (context, state) => const PathwayScreen(),
        ),
        GoRoute(
          path: '/risk',
          builder: (context, state) => const RiskScreen(),
        ),
      ],
    ),
  ],
);

class SplashScreenWrapper extends StatefulWidget {
  const SplashScreenWrapper({super.key});

  @override
  State<SplashScreenWrapper> createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    await Future.delayed(const Duration(seconds: 2));
    
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedOnboarding = prefs.getBool('hasCompletedOnboarding') ?? false;
    
    if (!mounted) return;
    
    if (!hasCompletedOnboarding) {
      context.go('/onboarding');
      return;
    }

    // Skip auth completely, go straight to home
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}

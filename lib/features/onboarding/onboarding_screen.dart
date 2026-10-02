import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCompletedOnboarding', true);
    if (mounted) {
      context.go('/language-selection');
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'balance':
        return Icons.balance;
      case 'chat':
        return Icons.chat;
      case 'description':
        return Icons.description;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    // Fallbacks provided just in case l10n isn't ready during first boot splash transition
    final List<Map<String, String>> pages = [
      {
        'title': l10n?.understandYourRights ?? 'Understand Your Rights',
        'description': l10n?.understandRightsDesc ?? 'Get simple and accessible explanations of Indian laws and legal rights.',
        'icon': 'balance',
      },
      {
        'title': l10n?.askJurixbot ?? 'Ask JuriXBot',
        'description': l10n?.askJurixbotDesc ?? 'Ask legal questions in your preferred language and get clear explanations.',
        'icon': 'chat',
      },
      {
        'title': l10n?.legalHelpSimple ?? 'Legal Help, Made Simple',
        'description': l10n?.legalHelpSimpleDesc ?? 'Search laws, understand documents, draft complaints and explore your rights.',
        'icon': 'description',
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getIconData(pages[index]['icon']!),
                          size: 120,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 40),
                        Text(
                          pages[index]['title']!,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          pages[index]['description']!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _completeOnboarding,
                    child: Text(l10n?.skip ?? 'Skip'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage == pages.length - 1) {
                        _completeOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    child: Text(_currentPage == pages.length - 1 ? (l10n?.getStarted ?? 'Get Started') : (l10n?.next ?? 'Next')),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

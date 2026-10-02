import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/locale_provider.dart';
import '../../l10n/app_localizations.dart';

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends ConsumerState<LanguageSelectionScreen> {
  String _selectedLanguage = 'en';

  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English', 'native': 'English'},
    {'code': 'hi', 'name': 'Hindi', 'native': 'हिंदी'},
    {'code': 'ta', 'name': 'Tamil', 'native': 'தமிழ்'},
    {'code': 'te', 'name': 'Telugu', 'native': 'తెలుగు'},
    {'code': 'ml', 'name': 'Malayalam', 'native': 'മലയാളം'},
    {'code': 'kn', 'name': 'Kannada', 'native': 'ಕನ್ನಡ'},
    {'code': 'bn', 'name': 'Bengali', 'native': 'বাংলা'},
    {'code': 'mr', 'name': 'Marathi', 'native': 'मराठी'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedLanguage = ref.read(localeProvider).languageCode;
  }

  Future<void> _saveLanguageAndContinue() async {
    // 1. Update the Riverpod state (this triggers the instant UI rebuild across the app)
    await ref.read(localeProvider.notifier).setLocale(_selectedLanguage);
    
    // 2. Mark onboarding as complete
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCompletedOnboarding', true);

    if (mounted) {
      // 3. Go directly to home
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.chooseLanguage ?? 'Choose Language'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              l10n?.selectLanguageDescription ?? 'Select your preferred language for JuriXBot',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _languages.length,
              itemBuilder: (context, index) {
                final lang = _languages[index];
                final isSelected = _selectedLanguage == lang['code'];
                return ListTile(
                  title: Text(lang['native']!),
                  subtitle: Text(lang['name']!),
                  trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.indigo) : null,
                  tileColor: isSelected ? Colors.indigo.withValues(alpha: 0.1) : null,
                  onTap: () {
                    setState(() {
                      _selectedLanguage = lang['code']!;
                    });
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveLanguageAndContinue,
                child: Text(l10n?.continueBtn ?? 'Continue'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

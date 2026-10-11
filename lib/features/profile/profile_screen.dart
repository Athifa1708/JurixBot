import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String _preferredLanguage = 'EN';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _preferredLanguage = (prefs.getString('preferredLanguage') ?? 'EN').toUpperCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final isGuest = user == null || user.isGuest;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 16),
          Text(
            user?.name ?? l10n.guestUser,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          if (!isGuest)
            Text(
              user?.email ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          const SizedBox(height: 32),
          
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('My Complaints'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              if (isGuest) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please register to track complaints.')));
              } else {
                context.push('/complaints');
              }
            },
          ),
          const Divider(),
          
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            trailing: Text(_preferredLanguage),
            onTap: () => context.push('/language-selection').then((_) => _loadLanguage()),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.aboutJurixbot),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l10n.aboutJurixbot),
                  content: Text(l10n.aboutDescription),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n.close),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(isGuest ? Icons.login : Icons.logout, color: isGuest ? Colors.indigo : Colors.red),
            title: Text(isGuest ? 'Login / Register' : 'Logout', style: TextStyle(color: isGuest ? Colors.indigo : Colors.red, fontWeight: FontWeight.bold)),
            onTap: () {
              ref.read(authProvider.notifier).logout();
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}

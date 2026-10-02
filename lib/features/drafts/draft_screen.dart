import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class DraftScreen extends StatefulWidget {
  const DraftScreen({super.key});

  @override
  State<DraftScreen> createState() => _DraftScreenState();
}

class _DraftScreenState extends State<DraftScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _authController = TextEditingController();
  final TextEditingController _compController = TextEditingController();
  
  bool _isLoading = false;
  String? _draftResult;

  void _generateDraft() async {
    if (_nameController.text.trim().isEmpty || _compController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _draftResult = null;
    });

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _draftResult = '''From,
${_nameController.text.trim()}

To,
${_authController.text.isEmpty ? '[AUTHORITY]' : _authController.text.trim()}

Subject: Formal Complaint regarding ${_compController.text.trim().substring(0, _compController.text.length > 20 ? 20 : _compController.text.length)}...

Respected Sir/Madam,

I am writing this letter to bring to your attention the following matter:

${_compController.text.trim()}

I kindly request you to look into this issue at the earliest and take the necessary legal actions.

Yours faithfully,
${_nameController.text.trim()}
Date: ${DateTime.now().toString().split(' ')[0]}''';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Draft Complaint')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Generate a formal complaint letter with AI assistance.',
              style: TextStyle(color: AppColors.secondaryText, fontSize: 14),
            ),
            const SizedBox(height: 24),
            
            const Text('Your Full Name', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Enter your full name'),
            ),
            const SizedBox(height: 16),
            
            const Text('Authority to Address', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _authController,
              decoration: const InputDecoration(hintText: 'E.g. Labour Commissioner, Police Station...'),
            ),
            const SizedBox(height: 16),
            
            const Text('Complaint Details', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _compController,
              maxLines: 5,
              decoration: const InputDecoration(hintText: 'Describe what happened in detail...'),
            ),
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _generateDraft,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Generate Complaint Letter'),
              ),
            ),
            const SizedBox(height: 32),
            
            if (_draftResult != null) ...[
              const Text('Generated Draft:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.divider),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_draftResult!, style: const TextStyle(height: 1.6)),
              )
            ]
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class PathwayScreen extends StatefulWidget {
  const PathwayScreen({super.key});

  @override
  State<PathwayScreen> createState() => _PathwayScreenState();
}

class _PathwayScreenState extends State<PathwayScreen> {
  final TextEditingController _situationController = TextEditingController();
  String _selectedCategory = 'Labour Rights';
  bool _isLoading = false;
  List<String> _steps = [];

  final List<String> _categories = [
    'Labour Rights',
    'Women\'s Rights',
    'Property Rights',
    'Consumer Rights',
    'Cyber Crime',
    'Police & FIR'
  ];

  void _generatePathway() async {
    if (_situationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe your situation')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _steps = [];
    });

    // Simulate API Call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _steps = [
        'Collect all relevant documents and evidence related to your situation.',
        'Send a formal legal notice to the opposing party detailing your grievances.',
        'If unresolved, file a formal complaint with the appropriate regulatory authority.',
        'Consult with a legal professional to file a petition in the designated court.'
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Legal Pathway Generator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Describe your situation and get a step-by-step legal action plan.',
              style: TextStyle(color: AppColors.secondaryText, fontSize: 14),
            ),
            const SizedBox(height: 24),
            const Text('Legal Category', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.divider),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedCategory,
                  items: _categories.map((String cat) {
                    return DropdownMenuItem(value: cat, child: Text(cat));
                  }).toList(),
                  onChanged: (val) {
                    setState(() => _selectedCategory = val!);
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Describe Your Situation', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _situationController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'E.g. My employer has not paid salary for 3 months...',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _generatePathway,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Generate Legal Pathway'),
              ),
            ),
            const SizedBox(height: 32),
            if (_steps.isNotEmpty) ...[
              const Text('Recommended Action Plan:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...List.generate(_steps.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        child: Text('${index + 1}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(_steps[index], style: const TextStyle(fontSize: 15, height: 1.5)),
                      ),
                    ],
                  ),
                );
              }),
            ]
          ],
        ),
      ),
    );
  }
}

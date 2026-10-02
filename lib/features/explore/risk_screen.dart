import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import 'dart:math';

class RiskScreen extends StatefulWidget {
  const RiskScreen({super.key});

  @override
  State<RiskScreen> createState() => _RiskScreenState();
}

class _RiskScreenState extends State<RiskScreen> {
  final TextEditingController _caseController = TextEditingController();
  bool _isLoading = false;
  int? _riskScore;
  String? _analysis;

  void _analyzeRisk() async {
    if (_caseController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe your case')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _riskScore = null;
      _analysis = null;
    });

    // Simulate API Call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      // Mock logic from HTML: Math.floor(Math.random()*40+40)
      _riskScore = Random().nextInt(40) + 40; 
      _analysis = "Based on the preliminary details provided, your case appears to have moderate standing. It is highly recommended to preserve all written evidence and seek formal legal consultation before proceeding with litigation.";
    });
  }

  Color _getRiskColor(int score) {
    if (score > 75) return AppColors.success;
    if (score > 45) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Risk Analyzer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Assess the legal strength and risk level of your case.',
              style: TextStyle(color: AppColors.secondaryText, fontSize: 14),
            ),
            const SizedBox(height: 24),
            const Text('Describe Your Legal Case', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _caseController,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'Provide details about your legal situation for analysis...',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _analyzeRisk,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Analyze Case Risk'),
              ),
            ),
            const SizedBox(height: 32),
            if (_riskScore != null) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    const Text('Case Strength', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: _riskScore! / 100,
                      minHeight: 12,
                      backgroundColor: AppColors.divider,
                      color: _getRiskColor(_riskScore!),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$_riskScore%',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _getRiskColor(_riskScore!),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _analysis!,
                      style: const TextStyle(height: 1.5, color: AppColors.primaryText),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}

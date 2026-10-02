import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class SOSScreen extends StatelessWidget {
  const SOSScreen({super.key});

  final List<Map<String, String>> sosList = const [
    {'num': '100', 'name': 'Police', 'desc': 'Crime, theft, violence'},
    {'num': '1091', 'name': "Women's Helpline", 'desc': 'Violence against women, harassment'},
    {'num': '1930', 'name': 'Cyber Crime', 'desc': 'Online fraud, UPI scams, hacking'},
    {'num': '1098', 'name': 'Childline', 'desc': 'Child abuse, missing child'},
    {'num': '15100', 'name': 'Legal Aid', 'desc': 'Free legal assistance for all citizens'},
    {'num': '181', 'name': 'Women in Distress', 'desc': 'State helpline for women'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency SOS'),
        backgroundColor: AppColors.error,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: sosList.length,
        itemBuilder: (context, index) {
          final sos = sosList[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: AppColors.error.withOpacity(0.3)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(Icons.phone_in_talk, color: AppColors.error, size: 30),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sos['num']!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.error,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          sos['name']!,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          sos['desc']!,
                          style: const TextStyle(color: AppColors.secondaryText),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.call, color: AppColors.success, size: 32),
                    onPressed: () {
                      // In a real app, use url_launcher: launchUrl(Uri.parse('tel:${sos['num']}'));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Calling ${sos['num']}...')),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

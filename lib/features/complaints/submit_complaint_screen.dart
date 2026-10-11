import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/complaint_provider.dart';

class SubmitComplaintScreen extends ConsumerStatefulWidget {
  const SubmitComplaintScreen({super.key});

  @override
  ConsumerState<SubmitComplaintScreen> createState() => _SubmitComplaintScreenState();
}

class _SubmitComplaintScreenState extends ConsumerState<SubmitComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _contactController = TextEditingController();

  String? _selectedCategory;
  final List<String> _categories = [
    'Consumer Rights',
    'Cyber Crime',
    'Police/FIR',
    'Labour Rights',
    'Property Rights',
    'Women Rights',
    'General/Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    final complaint = await ref.read(complaintProvider.notifier).submitComplaint(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory!,
      location: _locationController.text.trim(),
      contactDetails: _contactController.text.trim(),
    );

    if (complaint != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Complaint submitted successfully! Ref: ${complaint.referenceId}')),
      );
      context.pop(); // Go back to complaints list
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(complaintProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Complaint'),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.error != null) ...[
                      Text(state.error!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                    ],
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Complaint Title *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category *',
                        border: OutlineInputBorder(),
                      ),
                      items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (val) => setState(() => _selectedCategory = val),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Description *',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      validator: (value) => value == null || value.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location (Optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _contactController,
                      decoration: const InputDecoration(
                        labelText: 'Contact Details (Optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: state.isLoading ? null : _submit,
                        child: const Text('Submit Complaint'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

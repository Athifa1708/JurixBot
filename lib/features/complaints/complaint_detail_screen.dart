import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/complaint_provider.dart';

class ComplaintDetailScreen extends ConsumerStatefulWidget {
  final int complaintId;
  const ComplaintDetailScreen({super.key, required this.complaintId});

  @override
  ConsumerState<ComplaintDetailScreen> createState() => _ComplaintDetailScreenState();
}

class _ComplaintDetailScreenState extends ConsumerState<ComplaintDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(complaintProvider.notifier).getComplaintDetails(widget.complaintId);
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return Colors.blue;
      case 'assigned':
      case 'in progress':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(complaintProvider);
    final complaint = state.activeComplaint;

    if (state.isLoading && complaint == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Complaint Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (complaint == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Complaint Details')),
        body: const Center(child: Text('Complaint not found or error loading.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Ref: ${complaint.referenceId}'),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(complaintProvider.notifier).getComplaintDetails(widget.complaintId),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      complaint.title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Chip(
                    label: Text(
                      complaint.status,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: _getStatusColor(complaint.status),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Category: ${complaint.category}',
                style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                'Submitted on: ${DateFormat.yMMMd().format(complaint.createdAt)}',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const Divider(height: 32),
              const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Text(complaint.description, style: const TextStyle(height: 1.5)),

              if (complaint.location != null && complaint.location!.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(complaint.location!),
              ],

              const Divider(height: 40),
              const Text('Status History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),

              if (complaint.history.isEmpty)
                const Text('No status updates yet.')
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: complaint.history.length,
                  itemBuilder: (context, index) {
                    final history = complaint.history[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                margin: const EdgeInsets.only(top: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(history.status),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              if (index != complaint.history.length - 1)
                                Container(
                                  width: 2,
                                  height: 50,
                                  color: Colors.grey.shade300,
                                )
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  history.status,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  DateFormat('MMM d, yyyy • h:mm a').format(history.createdAt),
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                ),
                                if (history.comments != null && history.comments!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(history.comments!),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

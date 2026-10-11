import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/complaint_provider.dart';

class ComplaintsListScreen extends ConsumerStatefulWidget {
  const ComplaintsListScreen({super.key});

  @override
  ConsumerState<ComplaintsListScreen> createState() => _ComplaintsListScreenState();
}

class _ComplaintsListScreenState extends ConsumerState<ComplaintsListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch complaints when the screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(complaintProvider.notifier).fetchComplaints();
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Complaints'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/complaints/submit'),
        label: const Text('New Complaint'),
        icon: const Icon(Icons.add),
      ),
      body: state.isLoading && state.complaints.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : state.error != null && state.complaints.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.read(complaintProvider.notifier).fetchComplaints(),
                        child: const Text('Retry'),
                      )
                    ],
                  ),
                )
              : state.complaints.isEmpty
                  ? const Center(child: Text('You have not submitted any complaints yet.'))
                  : RefreshIndicator(
                      onRefresh: () => ref.read(complaintProvider.notifier).fetchComplaints(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.complaints.length,
                        itemBuilder: (context, index) {
                          final complaint = state.complaints[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ListTile(
                              onTap: () => context.push('/complaints/${complaint.id}'),
                              title: Text(
                                complaint.title,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Ref: ${complaint.referenceId}'),
                                    const SizedBox(height: 4),
                                    Text(complaint.category),
                                  ],
                                ),
                              ),
                              trailing: Chip(
                                label: Text(
                                  complaint.status,
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                                backgroundColor: _getStatusColor(complaint.status),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}

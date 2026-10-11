import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/dio_client.dart';
import '../models/complaint_model.dart';

final complaintProvider = StateNotifierProvider<ComplaintNotifier, ComplaintState>((ref) {
  return ComplaintNotifier();
});

class ComplaintState {
  final List<ComplaintModel> complaints;
  final ComplaintModel? activeComplaint;
  final bool isLoading;
  final String? error;

  ComplaintState({
    this.complaints = const [],
    this.activeComplaint,
    this.isLoading = false,
    this.error,
  });

  ComplaintState copyWith({
    List<ComplaintModel>? complaints,
    ComplaintModel? activeComplaint,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return ComplaintState(
      complaints: complaints ?? this.complaints,
      activeComplaint: activeComplaint ?? this.activeComplaint,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class ComplaintNotifier extends StateNotifier<ComplaintState> {
  ComplaintNotifier() : super(ComplaintState()) {
    fetchComplaints();
  }

  Future<void> fetchComplaints() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await DioClient.instance.get('/complaints');
      final complaints = (response.data as List)
          .map((json) => ComplaintModel.fromJson(json))
          .toList();
      state = state.copyWith(isLoading: false, complaints: complaints);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to load complaints.');
    }
  }

  Future<ComplaintModel?> submitComplaint({
    required String title,
    required String description,
    required String category,
    String? location,
    String? contactDetails,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await DioClient.instance.post(
        '/complaints/',
        data: {
          'title': title,
          'description': description,
          'category': category,
          'location': location,
          'contact_details': contactDetails,
        },
      );
      final newComplaint = ComplaintModel.fromJson(response.data);
      state = state.copyWith(
        isLoading: false,
        complaints: [newComplaint, ...state.complaints],
      );
      return newComplaint;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to submit complaint.');
      return null;
    }
  }

  Future<void> getComplaintDetails(int id) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await DioClient.instance.get('/complaints/$id');
      final complaint = ComplaintModel.fromJson(response.data);
      state = state.copyWith(isLoading: false, activeComplaint: complaint);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to load complaint details.');
    }
  }
}

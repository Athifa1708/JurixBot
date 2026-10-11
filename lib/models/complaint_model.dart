class ComplaintHistoryModel {
  final int id;
  final String status;
  final String? comments;
  final DateTime createdAt;

  ComplaintHistoryModel({
    required this.id,
    required this.status,
    this.comments,
    required this.createdAt,
  });

  factory ComplaintHistoryModel.fromJson(Map<String, dynamic> json) {
    return ComplaintHistoryModel(
      id: json['id'],
      status: json['status'],
      comments: json['comments'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class ComplaintModel {
  final int id;
  final String referenceId;
  final String title;
  final String description;
  final String category;
  final String? location;
  final String? contactDetails;
  final String status;
  final DateTime createdAt;
  final List<ComplaintHistoryModel> history;

  ComplaintModel({
    required this.id,
    required this.referenceId,
    required this.title,
    required this.description,
    required this.category,
    this.location,
    this.contactDetails,
    required this.status,
    required this.createdAt,
    this.history = const [],
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    var historyList = <ComplaintHistoryModel>[];
    if (json['history'] != null) {
      historyList = (json['history'] as List)
          .map((item) => ComplaintHistoryModel.fromJson(item))
          .toList();
    }

    return ComplaintModel(
      id: json['id'],
      referenceId: json['reference_id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      location: json['location'],
      contactDetails: json['contact_details'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      history: historyList,
    );
  }
}

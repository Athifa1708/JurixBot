class ChatSessionModel {
  final int id;
  final String title;
  final String language;

  ChatSessionModel({
    required this.id,
    required this.title,
    required this.language,
  });

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) {
    return ChatSessionModel(
      id: json['id'],
      title: json['title'] ?? 'New Conversation',
      language: json['language'] ?? 'en',
    );
  }
}

class ChatMessageModel {
  final int? id; // null for streamed in-progress messages
  final String role;
  final String content;

  ChatMessageModel({
    this.id,
    required this.role,
    required this.content,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'],
      role: json['role'],
      content: json['content'],
    );
  }

  ChatMessageModel copyWith({String? content}) {
    return ChatMessageModel(
      id: id,
      role: role,
      content: content ?? this.content,
    );
  }
}

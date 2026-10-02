class UserModel {
  final int id;
  final String name;
  final String email;
  final String preferredLanguage;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.preferredLanguage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      preferredLanguage: json['preferred_language'] ?? 'en',
    );
  }

  // Identify guest users based on the local email domain strategy
  bool get isGuest => email.endsWith('@jurixbot.local');
}

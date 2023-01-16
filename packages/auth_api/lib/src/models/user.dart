/// {@template app_user}
/// User model.
/// {@endtemplate}
class AppUser {
  AppUser({
    required this.id,
    required this.username,
  });

  factory AppUser.fromJson(Map<String, dynamic> data) {
    return AppUser(
      id: data['id'] as String,
      username: data['username'] as String,
    );
  }

  final String id;
  final String username;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
    };
  }
}

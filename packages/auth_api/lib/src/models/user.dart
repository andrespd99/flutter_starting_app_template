/// {@template app_user}
/// User model.
/// {@endtemplate}
class AppUser {
  AppUser({
    required this.id,
    required this.username,
  });

  final String id;
  final String username;

  factory AppUser.fromJson(Map<String, dynamic> data) {
    return AppUser(
      id: data['id'] as String,
      username: data['username'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
    };
  }
}

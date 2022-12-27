part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

/// {@template auth_token_fetched}
/// Event added when a token was fetched.
/// {@endtemplate}
class AuthTokenFetched extends AuthEvent {
  /// {@macro auth_authenticating}
  const AuthTokenFetched(this.token) : super();

  final String token;
}

/// {@template auth_user_updated}
/// Event added when user data changed.
/// {@endtemplate}
class AuthUserUpdated extends AuthEvent {
  /// {@macro auth_user_updated}
  const AuthUserUpdated(this.user) : super();

  final User user;
}

/// {@template auth_logout_requested}
/// Event added when the user requested to logout.
/// {@endtemplate}
class AuthLogoutRequested extends AuthEvent {
  /// {@macro auth_logout_requested}
  const AuthLogoutRequested() : super();
}

/// {@template auth_login_requested}
/// Event added when the user requested to sign in.
/// {@endtemplate}
class AuthLoginRequested extends AuthEvent {
  /// {@macro auth_login_requested}
  const AuthLoginRequested({
    required this.email,
    required this.password,
  }) : super();

  final String email;
  final String password;
}

/// {@template auth_register_requested}
/// Event added when the user requested to register.
/// {@endtemplate}
class AuthRegisterRequested extends AuthEvent {
  /// {@macro auth_register_requested}
  const AuthRegisterRequested() : super();
}

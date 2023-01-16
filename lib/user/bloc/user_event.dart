part of 'user_bloc.dart';

abstract class UserEvent {
  const UserEvent();
}

/// {@template user_token_fetched}
/// Event added when a token was fetched.
/// {@endtemplate}
class UserTokenFetched extends UserEvent {
  /// {@macro user_token_fetched}
  const UserTokenFetched(this.token) : super();

  final String token;
}

/// {@template user_user_updated}
/// Event added when user data changed.
/// {@endtemplate}
class UserDataUpdated extends UserEvent {
  /// {@macro user_user_updated}
  const UserDataUpdated(this.user) : super();

  final AppUser user;
}

/// {@template user_logout_requested}
/// Event added when the user requested to logout.
/// {@endtemplate}
class UserLogoutRequested extends UserEvent {
  /// {@macro user_logout_requested}
  const UserLogoutRequested() : super();
}

class UserInvalidTokenFound extends UserEvent {
  const UserInvalidTokenFound() : super();
}

class UserNoTokenFound extends UserEvent {
  const UserNoTokenFound() : super();
}

/// {@template user_login_requested}
/// Event added when the user requested to sign in.
/// {@endtemplate}
class UserLoginRequested extends UserEvent {
  /// {@macro user_login_requested}
  const UserLoginRequested({
    required this.email,
    required this.password,
  }) : super();

  final String email;
  final String password;
}

/// {@template user_register_requested}
/// Event added when the user requested to register.
/// {@endtemplate}
class UserRegisterRequested extends UserEvent {
  /// {@macro user_register_requested}
  const UserRegisterRequested() : super();
}

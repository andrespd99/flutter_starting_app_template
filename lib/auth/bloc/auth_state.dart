part of 'auth_bloc.dart';

/// {@template auth_state}
/// Base class fot [AuthBloc] states.
/// {@endtemplate}
abstract class AuthState extends Equatable {
  /// {@macro auth_state}
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// {@template auth_initial}
/// The initial state of AuthState
/// {@endtemplate}
class AuthInitial extends AuthState {
  /// {@macro auth_initial}
  const AuthInitial() : super();
}

/// {@template auth_authenticated}
/// The state when the user is authenticated.
/// {@endtemplate}
class AuthAuthenticated extends AuthState {
  /// {@macro auth_authenticated}
  const AuthAuthenticated(
    this.token,
    // this.user,
  ) : super();

  /// The token of the authenticated user.
  final String token;

  /// The user data of the authenticated user.
  // final User user;

  @override
  List<Object?> get props => [
        token,
        // user,
      ];
}

/// {@template auth_unauthenticated}
/// The state when the user is unauthenticated.
/// {@endtemplate}
class AuthUnauthenticated extends AuthState {
  /// {@macro auth_unauthenticated}
  const AuthUnauthenticated() : super();
}

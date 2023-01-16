part of 'user_bloc.dart';

/// {@template user_state}
/// Base class fot [UserBloc] states.
/// {@endtemplate}
abstract class UserState extends Equatable {
  /// {@macro user_state}
  const UserState();

  @override
  List<Object?> get props => [];
}

/// {@template user_initial}
/// The initial state of UserBloc.
/// {@endtemplate}
class UserInitial extends UserState {
  /// {@macro user_initial}
  const UserInitial() : super();
}

/// {@template user_authenticated}
/// The state when the user is authenticated.
/// {@endtemplate}
class UserAuthenticated extends UserState {
  /// {@macro user_authenticated}
  const UserAuthenticated(
    // this.token,
    this.user,
  ) : super();

  /// The token of the authenticated user.
  // final String token;

  /// The data of the authenticated user.
  final AppUser user;

  @override
  List<Object?> get props => [
        // token,
        user,
      ];
}

/// {@template user_unauthenticated}
/// The state when the user is unauthenticated.
/// {@endtemplate}
class UserUnauthenticated extends UserState {
  /// {@macro user_unauthenticated}
  const UserUnauthenticated([this.error]) : super();

  /// Description of the error that caused the user to be unauthenticated.
  final String? error;
}

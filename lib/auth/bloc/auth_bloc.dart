import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graphql_base_example/models/user.dart';
import 'package:graphql_base_example/repositories/auth_repository.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    AuthRepository authRepository,
    // UserRepository userRepository,
  )   : _auth = authRepository,
        // _user = userRepository,
        super(const AuthInitial()) {
    on<AuthTokenFetched>(_onAuthTokenFetched);
    on<AuthLoginRequested>(_onAuthSignInRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthUserUpdated>(_onAuthUserUpdated);

    /// update user data when _user.userStream emits a new value.
    /// _user.userStream.listen((user) => add(AuthUserUpdated(user)));
  }

  static const _source = 'AuthBloc';

  final AuthRepository _auth;
  // final UserRepository _user;

  FutureOr<void> _onAuthTokenFetched(
    AuthTokenFetched event,
    Emitter<AuthState> emit,
  ) async {
    try {
      /// Get user data with the token from the event.
      /// User user = _user.fetchUser(token)

      emit(
        AuthAuthenticated(
          event.token,
          // user,
        ),
      );
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  FutureOr<void> _onAuthSignInRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      /// Get token from the repository.
      final token = await _auth.login(
        email: event.email,
        password: event.password,
      );

      /// Get user data with the token from the event.
      /// User user = _user.fetchUser(token)

      emit(
        AuthAuthenticated(
          token,
          // user,
        ),
      );
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  FutureOr<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // TODO: Unsubscribe from push notifications

      // TODO: Execute any other logout logic here, like _auth.logout()

      emit(const AuthUnauthenticated());
    } catch (e) {
      // NOTE: In case of error, user won't be logged out to avoid
      // not unsuscribing from push notifications.
      // FIXME: The above suggestion should be inspected further...
    }
  }

  FutureOr<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // final token = await _auth.signUp(<Sign up data goes here>);

      // final token = await _user.fetchUser(token);

      // emit(AuthAuthenticated(token, user));
    } catch (e) {
      // TODO: Handle error if needed.
      emit(const AuthUnauthenticated());
    }
  }

  FutureOr<void> _onAuthUserUpdated(
    AuthUserUpdated event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // NOTE: Maybe refresh token??? => final token = await _auth.refreshToken();

      // final user = await _user.fetchUser(token);

      // emit(AuthAuthenticated(token, user));
      // or
      // emit(AuthAuthenticated(state.token, user));
    } catch (e) {
      // TODO: Handle error. Should we logout the user? Maybe depending on the error?
    }
  }
}

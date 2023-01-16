import 'dart:async';

import 'package:auth_api/auth_api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_starting_app/repositories/auth_repository.dart';
import 'package:flutter_starting_app/repositories/push_notifications_repository.dart';
import 'package:flutter_starting_app/repositories/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(
    AuthRepository authRepository,
    UserRepository userRepository,
    PushNotificationRepository? notificationsRepository,
  )   : _auth = authRepository,
        _user = userRepository,
        _notifications = notificationsRepository,
        super(const UserInitial()) {
    on<UserTokenFetched>(_onAuthTokenFetched);
    on<UserLoginRequested>(_onAuthSignInRequested);
    on<UserLogoutRequested>(_onAuthLogoutRequested);
    on<UserRegisterRequested>(_onAuthRegisterRequested);
    on<UserDataUpdated>(_onAuthUserUpdated);
    on<UserNoTokenFound>(_onNoTokenFound);
    on<UserInvalidTokenFound>(_onInvalidTokenFound);

    _auth.tokenStream().listen((token) {
      if (token != null) {
        add(UserTokenFetched(token));
      } else {
        add(const UserNoTokenFound());
      }
    });

    _user.userStream().listen((user) {
      if (user != null) {
        add(UserDataUpdated(user));
      } else {
        add(const UserInvalidTokenFound());
      }
    });
  }

  static const _source = 'AuthBloc';

  final AuthRepository _auth;
  final UserRepository _user;
  final PushNotificationRepository? _notifications;

  FutureOr<void> _onAuthTokenFetched(
    UserTokenFetched event,
    Emitter<UserState> emit,
  ) async {
    try {
      /// Get user data with the token from the event.
      final user = await _user.fetchUser(event.token);

      if (user == null) {
        emit(const UserUnauthenticated());
        return;
      }

      emit(UserAuthenticated(user));
    } catch (e) {
      // TODO(me): Add error message.
      emit(const UserUnauthenticated());
    }
  }

  FutureOr<void> _onAuthSignInRequested(
    UserLoginRequested event,
    Emitter<UserState> emit,
  ) async {
    try {
      /// Get token from the repository.
      final token = await _auth.login(
        email: event.email,
        password: event.password,
        fcmToken: await _notifications?.getToken(),
      );

      add(UserTokenFetched(token));
    } catch (e) {
      // TODO(me): Add error message.
      emit(const UserUnauthenticated());
    }
  }

  FutureOr<void> _onAuthRegisterRequested(
    UserRegisterRequested event,
    Emitter<UserState> emit,
  ) async {
    try {
      // final fcmToken = await _notifications?.getToken(),
      // final token = await _auth.signUp(<Sign up data goes here>, fcmToken);

      // add(UserTokenFetched(token));

    } catch (e) {
      // TODO(me): Add error message.
      emit(const UserUnauthenticated());
    }
  }

  FutureOr<void> _onAuthLogoutRequested(
    UserLogoutRequested event,
    Emitter<UserState> emit,
  ) async {
    try {
      // NOTE: Maybe unsubscribe from any FCM topics.

      final fcmToken = await _notifications?.getToken();
      await _auth.signOut(fcmToken);

      // NOTE: Execute any other logout logic here (e.g. clear cache, etc.)

      emit(const UserUnauthenticated());
    } catch (e) {
      // TODO(me): Add error message.
      // NOTE: In case of error, user won't be logged out to avoid
      // not unsuscribing from push notifications.
      // FIXME: The above suggestion should be inspected further...
    }
  }

  FutureOr<void> _onAuthUserUpdated(
    UserDataUpdated event,
    Emitter<UserState> emit,
  ) {
    emit(UserAuthenticated(event.user));
  }

  FutureOr<void> _onInvalidTokenFound(
    UserInvalidTokenFound event,
    Emitter<UserState> emit,
  ) {
    emit(const UserUnauthenticated());
  }

  FutureOr<void> _onNoTokenFound(
    UserNoTokenFound event,
    Emitter<UserState> emit,
  ) {
    emit(const UserUnauthenticated());
  }
}

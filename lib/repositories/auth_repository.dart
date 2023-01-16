import 'dart:async';

import 'package:auth_api/auth_api.dart';
import 'package:graphql_api/graphql_api.dart';
import 'package:rxdart/rxdart.dart';

class AuthRepository {
  AuthRepository({
    required AuthApi authApi,
  }) : _authApi = authApi;

  final AuthApi _authApi;

  late final StreamController<String?> _tokenController =
      BehaviorSubject<String?>(
    // When the stream is first listened to, it will sink any stored token.
    onListen: () async =>
        _tokenController.sink.add(await _authApi.currentUser()),
  );

  /// Stream of [String] which will emit the current token when it changes.
  Stream<String?> tokenStream() => _tokenController.stream;

  /// Sinks the given [token] into the [_tokenController] and emitted to the
  /// [tokenStream].
  void Function(String?) _sinkToken(String? token) => _tokenController.sink.add;

  /// Logs in user and returns a [Future] that resolves to a [String] containing
  /// the token.
  ///
  /// If the login fails, it throws an [AuthException]. If the query fails,
  /// it throws an [OperationException].
  Future<String> login({
    required String email,
    required String password,
    String? fcmToken,
  }) async {
    try {
      final token = await _authApi.login(
        username: email,
        password: password,
        fcmToken: fcmToken,
      );

      _sinkToken(token);

      return token;
    } catch (e) {
      rethrow;
    }
  }

  /// Signs up user and returns a [Future] that resolves to a [String]
  /// containing the token.
  ///
  /// If the sign up fails, it throws an [AuthException]. If the query fails,
  /// it throws an [OperationException].
  Future<String> signUp({
    required String email,
    required String password,
    String? fcmToken,
  }) async {
    try {
      final token = await _authApi.signUp(
        email: email,
        password: password,
        fcmToken: fcmToken,
      );

      _sinkToken(token);

      return token;
    } catch (e) {
      rethrow;
    }
  }

  /// Signs out from the app. If an [fcmToken] is provided, it will be removed
  /// from the user's account to stop notifications from being sent to this
  /// device.
  Future<void> signOut([String? fcmToken]) async {
    try {
      await _authApi.signOut(fcmToken);

      _sinkToken(null);
    } catch (e) {
      rethrow;
    }
  }
}

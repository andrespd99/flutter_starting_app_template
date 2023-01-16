import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_api/graphql_api.dart';
import 'package:my_utils/my_utils.dart' as utils;

/// {@template auth_exception}
/// Exception related to authentication errors.
/// {@endtemplate}
class AuthException implements Exception {
  /// {@macro auth_exception}
  AuthException([this.message]);

  /// Description of this exception.
  String? message;
}

/// {@template auth_api_with_secure_storage}
/// Handles all authentication related operations like login, logout and
/// sign up.
///
/// It uses [FlutterSecureStorage] to store the token.
/// {@endtemplate}
class AuthApi {
  /// {@macro auth_api_with_secure_storage}
  const AuthApi({
    required GraphQlApi graphQlClient,
    required FlutterSecureStorage plugin,
  })  : _client = graphQlClient,
        _plugin = plugin;

  static const _source = 'AuthApi';
  static const _key = '__APP_TOKEN__';

  final GraphQlApi _client;
  final FlutterSecureStorage _plugin;

  /// Retrieves the stored token, if any. Returns `null` if no token is found.
  Future<String?> currentUser() async {
    try {
      final token = await _plugin.read(key: _key);

      _client.setToken(token);

      return token;
    } catch (e) {
      rethrow;
    }
  }

  /// Login with the credentials and returns the authentication token.
  ///
  /// If login fails, an [AuthException] is thrown.
  Future<String> login({
    required String username,
    required String password,
    String? fcmToken,
  }) async {
    try {
      log('🕓 Logging in...', name: '$_source.login()');

      final token = await _client.query<String>(
        query: _loginQuery,
        // TODO(me): Update map key.
        builder: (data) => data['login'] as String,

        // TODO(me): Update map keys.
        variables: {
          'username': username,
          'password': password,
        },
      );

      if (token.isEmpty) {
        throw AuthException('Empty token');
      }

      await _plugin.write(key: _key, value: token);

      log('✅ Login successful.', name: '$_source.login()');

      return token;
    } catch (e) {
      log(
        '❌ Login failed.',
        name: '$_source.login()',
        error: e,
      );
      rethrow;
    }
  }

  // TODO(me): Declare query.
  static const _loginQuery = '';

  /// Signs up user and returns a [Future] that resolves to the authentication
  /// token of the user.
  ///
  /// Throws [AuthException] if token is empty.
  Future<String> signUp({
    required String email,
    required String password,
    // TODO(me): Add all parameters.
    String? fcmToken,
  }) async {
    try {
      log('🕓 Signing up...', name: '$_source.signUp()');

      final result = await _client.mutate<String>(
        query: _signUpQuery,
        // TODO(me): Update map key.
        builder: (data) => data['signUp'] as String,
        // TODO(me): Update map keys.
        variables: {
          'email': email,
          'password': password,
        },
      );

      final token = result;

      if (result.isEmpty) {
        throw AuthException();
      }

      await _plugin.write(key: _key, value: token);

      log('✅ Sign up successful.', name: '$_source.signUp()');

      return token;
    } catch (e) {
      log(
        '❌ Sign up failed.',
        name: '$_source.signUp()',
        error: e,
      );
      rethrow;
    }
  }

  // TODO(me): Declare query.
  static const _signUpQuery = '';

  /// Signs out the current user. If an [fcmToken] is provided, it will be
  /// removed from the user's account to stop notifications from being sent to
  /// this device.
  Future<void> signOut([String? fcmToken]) async {
    try {
      log('🕓 Signing out...', name: '$_source.signOut()');

      await _client.query(
        query: _signOutQuery,
        // TODO(me): Update map key.
        builder: (data) => data['signOut'],
        // TODO(me): Update map keys.
        variables: {},
      );
      await _plugin.delete(key: _key);
      _client.setToken(null);

      log('✅ Sign out successful.', name: '$_source.signOut()');
    } catch (e, s) {
      await utils.log(
        '❌ Sign out failed.',
        name: '$_source.signOut()',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  static const _signOutQuery = '';
}

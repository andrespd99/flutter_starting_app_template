import 'package:auth_api/src/models/query_params.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_api/graphql_api.dart';

/// Exception related to authentication errors.
class AuthException implements Exception {
  AuthException([this.message]);

  String? message;
}

/// Base class for Authentication API for GraphQL-base servers. This class is
/// used to authenticate users and get their tokens by logging in or signing
/// up.
///
/// This class is abstract and should be extended to implement the actual
/// authentication API.
abstract class AuthApi {
  const AuthApi();

  /// Logs in the user with the given [params] and [query].
  Future<String> login({
    required QueryParams<String> params,
    required String query,
  });

  /// Sign up user with the given [params] and [query].
  Future<String> signUp({
    required QueryParams<String> params,
    required String query,
  });

  /// Signs out the current user.
  Future<void> signOut();

  /// Returns the current user token.
  Future<String?> currentUser();
}

/// {@template auth_api}
/// Implementation of [AuthApi] with GraphQL as the query language and
/// [FlutterSecureStorage] to store the token.
/// {@endtemplate}
class AuthApiWithSecureStorage extends AuthApi {
  /// {@macro auth_api}
  const AuthApiWithSecureStorage({
    required GraphqlApi graphQLClient,
    required FlutterSecureStorage plugin,
  })  : _client = graphQLClient,
        _plugin = plugin;

  static const _key = '__APP_TOKEN__';

  final GraphqlApi _client;
  final FlutterSecureStorage _plugin;

  /// Login with [QueryParams] parameters and returns a [Future] that resolves
  /// to a [String] containing the token, and updates the token in the secure
  /// storage.
  ///
  /// If the login fails, it throws an [AuthException].
  @override
  Future<String> login({
    required QueryParams<String> params,
    required String query,
  }) async {
    try {
      final result = await _client.query<String>(
        query: query,
        builder: params.builder,
        variables: params.toMap(),
      );

      final token = result;

      if (token.isEmpty) {
        throw AuthException();
      }

      await _plugin.write(key: _key, value: token);

      return token;
    } catch (e) {
      rethrow;
    }
  }

  /// Signs up with [QueryParams] parameters and returns a [Future] that
  /// resolves to a [String] containing the token, and updates the token in the
  /// secure storage.
  ///
  /// Throws [AuthException] if token is empty.
  @override
  Future<String> signUp({
    required QueryParams<String> params,
    required String query,
  }) async {
    try {
      final result = await _client.mutate<String>(
        query: query,
        builder: params.builder,
        variables: params.toMap(),
      );

      final token = result;

      if (result.isEmpty) {
        throw AuthException();
      }

      await _plugin.write(key: _key, value: token);
      return token;
    } catch (e) {
      rethrow;
    }
  }

  /// Retrieves the stored token, if there's any. If no token is found,
  /// null is returned instead.
  @override
  Future<String?> currentUser() async {
    try {
      final token = await _plugin.read(key: _key);

      _client.setToken(token);

      return token;
    } catch (e) {
      rethrow;
    }
  }

  /// Signs out the current user and returns a [Future] of this action.
  @override
  Future<void> signOut() async {
    await _plugin.delete(key: _key);
    _client.setToken(null);
  }
}

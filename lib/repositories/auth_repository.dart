import 'package:auth_api/auth_api.dart';
import 'package:graphql_api/graphql_api.dart';

/// {@template auth_repository.login_params}
/// Parameters for the login mutation.
/// {@endtemplate}
class LoginParams extends QueryParams<String> {
  /// {@macro auth_repository.login_params}
  LoginParams({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  @override
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
    };
  }

  @override
  String builder(Map<String, dynamic> data) {
    return data['login'] as String;
  }
}

/// {@template auth_repository.sign_up_params}
/// Parameters for the signup mutation.
/// {@endtemplate}
class SignUpParams extends QueryParams<String> {
  /// {@macro auth_repository.sign_up_params}
  SignUpParams({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  @override
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
    };
  }

  @override
  String builder(Map<String, dynamic> data) {
    return data['signup'] as String;
  }
}

class AuthRepository {
  const AuthRepository({
    required AuthApi authApi,
  }) : _authApi = authApi;

  final AuthApi _authApi;

  /// Logs in user and returns a [Future] that resolves to a [String] containing
  /// the token.
  ///
  /// If the login fails, it throws an [AuthException]. If the query fails,
  /// it throws am [OperationException].
  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      final token = await _authApi.login(
        params: LoginParams(username: email, password: password),
        query: _loginQuery,
      );
      return token;
    } catch (e) {
      rethrow;
    }
  }

  static const _loginQuery = r'''
    mutation Login($username: String!, $password: String!) {
      login(username: $username, password: $password)
    }
  ''';

  /// Signs up user and returns a [Future] that resolves to a [String]
  /// containing the token.
  ///
  /// If the sign up fails, it throws an [AuthException]. If the query fails,
  /// it throws am [OperationException].
  Future<String> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final token = await _authApi.signUp(
        params: SignUpParams(username: email, password: password),
        query: _signUpQuery,
      );
      return token;
    } catch (e) {
      rethrow;
    }
  }

  static const _signUpQuery = r'''
    mutation SignUp($username: String!, $password: String!) {
      signup(username: $username, password: $password)
    }
  ''';

  /// Returns the current user token. If the token is not found, returns
  /// `null`.
  Future<String?> currentUser() async => _authApi.currentUser();
}

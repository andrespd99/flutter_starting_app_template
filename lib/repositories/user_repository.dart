import 'dart:async';

import 'package:auth_api/auth_api.dart';
import 'package:rxdart/rxdart.dart';

/// {@template user_repository}
/// Repository which manages user data.
/// {@endtemplate}
class UserRepository {
  /// {@macro user_repository}
  UserRepository({
    required UserApi userApi,
  }) : _userApi = userApi;

  final UserApi _userApi;

  final StreamController<AppUser?> _userController =
      BehaviorSubject<AppUser?>();

  /// Stream of [AppUser] which will emit the current user when it changes.
  Stream<AppUser?> userStream() => _userController.stream;

  void Function(AppUser?) _sinkUser(AppUser? user) => _userController.sink.add;

  /// Fetches user data with the given [token]. If the token is invalid, it will
  /// return `null`.
  Future<AppUser?> fetchUser(String token) async {
    try {
      final user = await _userApi.fetchUser(token);

      _sinkUser(user);

      return user;
    } catch (e) {
      rethrow;
    }
  }

  // NOTE: This is an example method on how to update a user field. Remove or
  // update this method to fit your API.
  Future<AppUser?> updatePhone(String token, String phone) async {
    try {
      final user = await _userApi.updateUser(
        token: token,
        params: {
          'phone': phone,
        },
      );

      _sinkUser(user);

      return user;
    } catch (e) {
      rethrow;
    }
  }

  // TODO: Add methods to update other user fields.

}

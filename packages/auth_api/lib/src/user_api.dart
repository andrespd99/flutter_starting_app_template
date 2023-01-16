import 'dart:async';
import 'dart:developer';

import 'package:auth_api/auth_api.dart';
import 'package:graphql_api/graphql_api.dart';
import 'package:my_utils/my_utils.dart' as utils;

/// {@template user_api}
/// API for user data interaction. This class exposes methods to fetch and
/// update user data.
///
/// For any other user-related objects (e.g. posts, comments, etc.), you should
/// create a separate API class.
/// {@endtemplate}
class UserApi {
  /// {@macro user_api}
  const UserApi({
    required GraphQlApi client,
  }) : _client = client;

  static const _source = 'UserApi';

  final GraphQlApi _client;

  /// Fetches a user with the token from the API. If `null` is returned, the
  /// user is not authenticated or the token is invalid.
  Future<AppUser?> fetchUser(String token) async {
    try {
      log('🕓 Fetching user...', name: '$_source.fetchUser()');

      final response = await _client.query(
        query: _fetchUserQuery,
        builder: (data) => AppUser.fromJson(
          // TODO(me): Update map key.
          data['currentUser'] as Map<String, dynamic>,
        ),
      );

      log('✅ User fetched.', name: '$_source.fetchUser()');

      return response;
    } catch (e, stackTrace) {
      // TODO(me): Handle error.
      await utils.log(
        '❌ Error fetching user.',
        name: '$_source.fetchUser()',
        error: e,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  // TODO(me): Define query.
  static const _fetchUserQuery = '';

  /// Updates the user with the given [token] and [params], and returns the
  /// updated user.
  Future<AppUser> updateUser({
    required String token,
    required Map<String, dynamic> params,
  }) async {
    try {
      log('🕓 Updating user...', name: '$_source.updateUser()');

      /// Calling [fetchUser] to ensure the auth token is still valid and
      /// to obtain user's ID.
      final user = await fetchUser(token);

      /// If user is `null`, the token is invalid, hence the user is not
      /// authenticated and should not be able to update the data.
      if (user == null) {
        throw AuthException('User not authenticated');
      }

      final response = await _client.query<AppUser>(
        query: _updateUserQuery,
        // TODO(me): Update variables's map keys.
        variables: {
          'filter': {
            'id': user.id,
          },
          'record': params,
        },
        builder: (data) => AppUser.fromJson(
          // TODO(me): Update map key.
          data['updateUser'] as Map<String, dynamic>,
        ),
      );

      log('✅ User updated.', name: '$_source.updateUser()');

      return response;
    } catch (e, stackTrace) {
      // TODO(me): Handle error.
      await utils.log(
        '❌ Error updating user.',
        name: '$_source.updateUser()',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  // TODO(me): Define query.
  static const _updateUserQuery = '';
}

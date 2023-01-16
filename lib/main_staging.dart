import 'dart:developer';

import 'package:auth_api/auth_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_api/graphql_api.dart';
import 'package:graphql_base_example/app/app.dart';
import 'package:graphql_base_example/bootstrap.dart';
import 'package:graphql_base_example/repositories/push_notifications_repository.dart';

void main() {
  bootstrap(() async {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      await PushNotificationRepository.initializeApp();
    } catch (e) {
      log('❌ Error initializing push notifications', error: e);
    }

    final _client = GraphqlApi(apiUrl: '');

    return App(
      notificationsRepository: PushNotificationRepository(),
      authApi: AuthApi(
        graphQLClient: _client,
        plugin: const FlutterSecureStorage(),
      ),
      userApi: UserApi(client: _client),
      // TODO: Other repositories and variables...
    );
  });
}

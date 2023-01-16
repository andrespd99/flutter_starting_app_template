import 'dart:developer';

import 'package:auth_api/auth_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_api/graphql_api.dart';
import 'package:graphql_base_example/app/app.dart';
import 'package:graphql_base_example/bootstrap.dart';
import 'package:graphql_base_example/repositories/push_notifications_repository.dart';

void main() {
  bootstrap(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await dotenv.load();
    final client = GraphQlApi(apiUrl: dotenv.env['PROD_API_URL']!);
    // TODO: Load other variables from .env file if needed.

    try {
      await PushNotificationRepository.initialize();
    } catch (e) {
      log('❌ Error initializing push notifications', error: e);
    }

    return App(
      notificationsRepository: PushNotificationRepository(),
      authApi: AuthApi(
        graphQlClient: client,
        plugin: const FlutterSecureStorage(),
      ),
      userApi: UserApi(client: client),
      // TODO: Other repositories and variables...
    );
  });
}

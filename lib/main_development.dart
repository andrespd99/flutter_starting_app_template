import 'package:auth_api/auth_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_starting_app/app/app.dart';
import 'package:flutter_starting_app/bootstrap.dart';
import 'package:graphql_api/graphql_api.dart';

void main() {
  bootstrap(() async {
    await dotenv.load();
    final client = GraphQlApi(apiUrl: dotenv.env['DEV_API_URL']!);
    // TODO: Load other variables from .env file if needed.

    return App(
      authApi: AuthApi(
        graphQlClient: client,
        plugin: const FlutterSecureStorage(),
      ),
      userApi: UserApi(client: client),
      // TODO: Other repositories and variables...
    );
  });
}

import 'package:auth_api/auth_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_api/graphql_api.dart';
import 'package:graphql_base_example/app/app.dart';
import 'package:graphql_base_example/bootstrap.dart';

void main() {
  bootstrap(() {
    final _client = GraphqlApi(apiUrl: '');

    return App(
      authApi: AuthApi(
        graphQLClient: _client,
        plugin: const FlutterSecureStorage(),
      ),
      userApi: UserApi(client: _client),
      // TODO: Other repositories and variables...
    );
  });
}

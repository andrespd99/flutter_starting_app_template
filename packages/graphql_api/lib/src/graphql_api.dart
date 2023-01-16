import 'dart:developer';

import 'package:graphql/client.dart';

/// {@template graphql_api}
/// [GraphQLClient] wrapper that exposes simplified methods for executing
/// queries and mutations.
///
/// This class also handles authentication by adding the `Authorization` header,
/// if needed.
/// {@endtemplate}
class GraphQlApi {
  /// {@macro graphql_api}
  GraphQlApi({
    required String apiUrl,
    String? token,
  }) {
    _httpLink = HttpLink(apiUrl);

    final authLink = AuthLink(getToken: () async => 'Bearer ${token ?? ''}');

    final link = authLink.concat(_httpLink);

    _gql = GraphQLClient(
      link: link,
      cache: GraphQLCache(),
    );
  }
  static const _source = 'GraphqlApi';

  late GraphQLClient _gql;
  late final HttpLink _httpLink;

  /// GraphQL client
  GraphQLClient get client => _gql;

  /// Updates current GraphQL client with the new [token]
  void setToken(String? token) {
    final authLink = AuthLink(getToken: () async => 'Bearer ${token ?? ''}');

    final link = authLink.concat(_httpLink);

    _gql = GraphQLClient(
      link: link,
      cache: GraphQLCache(),
    );
  }

  /// Executes a GraphQL query and builds the resulting data. If the query
  /// fails, an [OperationException] is thrown.
  ///
  ///
  /// {@template graphql_api.query}
  /// `query` is the GraphQL query as a String.
  ///
  /// `builder` converts the resulting data into an object of type [T]. If
  /// no general [T] type is provided, the resulting data is returned as a
  /// [Map].
  ///
  /// You can pass variables to the query via the `variables` parameter. The
  /// name of the variable must match the name of the variable in `query`.
  ///
  /// {@endtemplate}
  ///
  /// `pollInteval` is the time interval on which this query should be
  /// re-fetched from the server.
  Future<T> query<T>({
    required String query,
    required T Function(Map<String, dynamic> data) builder,
    Map<String, dynamic>? variables,
    FetchPolicy? fetchPolicy,
    CacheRereadPolicy? cacheRereadPolicy,
    ErrorPolicy? errorPolicy,
    Duration? pollInterval,
  }) async {
    try {
      final options = QueryOptions(
        document: gql(query),
        variables: variables ?? <String, dynamic>{},
        fetchPolicy: fetchPolicy,
        cacheRereadPolicy: cacheRereadPolicy,
        errorPolicy: errorPolicy,
        pollInterval: pollInterval,
      );

      final res = await _gql.query(options);

      if (res.hasException) {
        throw res.exception!;
      }

      return builder(res.data ?? <String, dynamic>{});
    } catch (e) {
      log(
        '❌ Exception thrown when executing query',
        name: '$_source.query',
        error: e,
      );
      rethrow;
    }
  }

  /// Executes a GraphQL query mutation and builds the resulting data.
  /// If the query fails, an [OperationException] is thrown.
  ///
  /// {@macro graphql_api.query}
  Future<T> mutate<T>({
    required String query,
    required T Function(Map<String, dynamic> data) builder,
    Map<String, dynamic>? variables,
    FetchPolicy? fetchPolicy,
    CacheRereadPolicy? cacheRereadPolicy,
    ErrorPolicy? errorPolicy,
  }) async {
    try {
      final options = MutationOptions(
        document: gql(query),
        variables: variables ?? <String, dynamic>{},
        fetchPolicy: fetchPolicy,
        cacheRereadPolicy: cacheRereadPolicy,
        errorPolicy: errorPolicy,
      );

      final res = await _gql.mutate(options);

      if (res.hasException) {
        throw res.exception!;
      }

      return builder(res.data ?? <String, dynamic>{});
    } catch (e) {
      log(
        '❌ Exception thrown when executing query',
        name: '$_source.mutate',
        error: e,
      );
      rethrow;
    }
  }
}

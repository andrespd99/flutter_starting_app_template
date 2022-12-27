// ignore_for_file: public_member_api_docs

/// {@template auth_api.query_params}
/// Base class for query parameters.
/// {@endtemplate}
abstract class QueryParams<T> {
  /// {@macro auth_api.query_params}
  QueryParams();

  /// Converts the parameters to a [Map] that can be used to build a GraphQL
  /// query variables.
  Map<String, dynamic> toMap();

  /// Builder function that converts the data returned by the GraphQL query to
  /// the desired type [T].
  T builder(Map<String, dynamic> data);
}

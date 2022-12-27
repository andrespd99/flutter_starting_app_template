// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_api/graphql_api.dart';

void main() {
  group('GraphqlApi', () {
    test('can be instantiated', () {
      expect(GraphqlApi(), isNotNull);
    });
  });
}

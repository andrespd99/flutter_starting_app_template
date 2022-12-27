import 'package:flutter/material.dart';
import 'package:graphql_base_example/auth/bloc/bloc.dart';

/// {@template auth_body}
/// Body of the AuthPage.
///
/// Add what it does
/// {@endtemplate}
class AuthBody extends StatelessWidget {
  /// {@macro auth_body}
  const AuthBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Text(state.customProperty);
      },
    );
  }
}

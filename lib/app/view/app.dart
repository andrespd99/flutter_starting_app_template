import 'package:auth_api/auth_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starting_app/l10n/l10n.dart';
import 'package:flutter_starting_app/repositories/auth_repository.dart';
import 'package:flutter_starting_app/repositories/push_notifications_repository.dart';
import 'package:flutter_starting_app/repositories/user_repository.dart';
import 'package:flutter_starting_app/user/user.dart';

class App extends StatelessWidget {
  const App({
    required this.userApi,
    required this.authApi,
    this.notificationsRepository,
    super.key,
  });

  final PushNotificationRepository? notificationsRepository;

  final UserApi userApi;
  final AuthApi authApi;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => UserRepository(userApi: userApi)),
        RepositoryProvider(create: (_) => AuthRepository(authApi: authApi)),
      ],
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
          colorScheme: ColorScheme.fromSwatch(
            accentColor: const Color(0xFF13B9FF),
          ),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider(
          create: (context) => UserBloc(
            context.read<AuthRepository>(),
            context.read<UserRepository>(),
            notificationsRepository,
          ),
          child: Container(),
        ),
      ),
    );
  }
}

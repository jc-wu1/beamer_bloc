import 'package:authentication_repository/authentication_repository.dart';
import 'package:beamer/beamer.dart';
import 'package:beamer_bloc/logged_in_locations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:user_repository/user_repository.dart';

import 'bloc/authentication_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  HydratedBlocOverrides.runZoned(
    () => runApp(
      MyApp(
        authenticationRepository: AuthenticationRepository(),
        userRepository: UserRepository(),
      ),
    ),
    storage: storage,
  );
}

class MyApp extends StatelessWidget {
  MyApp({
    Key? key,
    required this.authenticationRepository,
    required this.userRepository,
  }) : super(key: key);

  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  final routerDelegate = BeamerDelegate(
    guards: [
      // Guard /logged_in_page by beaming to /login if the user is unauthenticated:
      BeamGuard(
        pathPatterns: [
          '/logged_in_page',
          '/books/*',
          '/books',
        ],
        check: (context, state) =>
            context.read<AuthenticationBloc>().isAuthenticated(),
        beamToNamed: (_, __) => '/login',
      ),
      // Guard /login by beaming to /logged_in_page if the user is authenticated:
      BeamGuard(
        pathPatterns: ['/login'],
        check: (context, state) =>
            !context.read<AuthenticationBloc>().isAuthenticated(),
        beamToNamed: (_, __) => '/logged_in_page',
      ),
    ],
    initialPath: '/login',
    locationBuilder: BeamerLocationBuilder(
      beamLocations: [
        UnauthenticatedLocations(),
        LoggedInLocations(),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider<AuthenticationBloc>(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,
        ),
        child: Builder(builder: (context) {
          return BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              routerDelegate.update();
            },
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerDelegate: routerDelegate,
              routeInformationParser: BeamerParser(),
            ),
          );
        }),
      ),
    );
  }
}

import 'package:auto_route/annotations.dart';
import 'package:scanner/pages/home.dart';
import 'package:scanner/pages/login.dart';
import 'package:scanner/pages/splash.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: SplashPage , initial: true),
    AutoRoute(page: LoginPage),
    AutoRoute(page: HomePage),
  ],
)
class $AppRouter {}

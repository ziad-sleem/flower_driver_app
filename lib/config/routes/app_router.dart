import 'package:tracking_app/config/routes/page_transitions.dart';
import 'package:tracking_app/config/routes/routes.dart';
import 'package:tracking_app/core/widgets/not_found_screen.dart';
import 'package:tracking_app/features/auth/presentation/login/pages/login_screen.dart';
import 'package:tracking_app/features/home/presentation/pages/home_page.dart';
import 'package:tracking_app/features/splash/presentation/pages/splash_screen.dart';
import 'package:flutter/material.dart';

abstract class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    try {
      switch (settings.name) {
        case Routes.splash:
          return PageTransitions.fade(const SplashScreen());

        case Routes.login:
          return PageTransitions.fade(const LoginScreen());

        case Routes.home:
          return PageTransitions.fade(const HomePage());

        default:
          return PageTransitions.fade(
            NotFoundScreen(route: settings.name ?? ''),
          );
      }
    } catch (_) {
      return PageTransitions.fade(NotFoundScreen(route: settings.name ?? ''));
    }
  }
}

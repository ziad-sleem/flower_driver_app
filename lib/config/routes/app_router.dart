import 'package:tracking_app/config/routes/page_transitions.dart';
import 'package:tracking_app/config/routes/routes.dart';
import 'package:tracking_app/core/widgets/not_found_screen.dart';
import 'package:tracking_app/core/widgets/app_loading_widget.dart';
import 'package:flutter/material.dart';

abstract class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    try {
      switch (settings.name) {
        case Routes.splash:
          return PageTransitions.fade(const AppLoadingWidget());

        case Routes.home:
          return PageTransitions.fade(const AppLoadingWidget());

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

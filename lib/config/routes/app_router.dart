import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/config/dependency_injection/di.dart';
import 'package:tracking_app/config/routes/page_transitions.dart';
import 'package:tracking_app/config/routes/routes.dart';
import 'package:tracking_app/core/widgets/not_found_screen.dart';
import 'package:tracking_app/core/widgets/app_loading_widget.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/cubit/forget_password_cubit.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/pages/forget_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_cubit.dart';
import 'package:tracking_app/features/auth/presentation/apply/pages/apply_page.dart';
import 'package:tracking_app/features/auth/presentation/apply/pages/success_apply_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    try {
      switch (settings.name) {
        case Routes.splash:
          return PageTransitions.fade(const AppLoadingWidget());

        case Routes.home:
          return PageTransitions.fade(const AppLoadingWidget());

        case Routes.applyNow:
          return PageTransitions.fade(
            BlocProvider<ApplyCubit>(
              create: (_) => getIt<ApplyCubit>(),
              child: const ApplyNowPage(),
            ),
          );
        case Routes.succesApply:
          return PageTransitions.fade(SuccessApplyScreen());
        case Routes.forgetPassword:
          return PageTransitions.fade(
            BlocProvider(
              create: (_) => getIt<ForgetPasswordCubit>(),
              child: const ForgetPasswordScreen(),
            ),
          );

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

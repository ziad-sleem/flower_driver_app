import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/config/dependency_injection/di.dart';
import 'package:tracking_app/config/routes/page_transitions.dart';
import 'package:tracking_app/config/routes/routes.dart';
import 'package:tracking_app/core/widgets/not_found_screen.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_cubit.dart';
import 'package:tracking_app/features/auth/presentation/apply/pages/apply_page.dart';
import 'package:tracking_app/features/auth/presentation/apply/pages/success_apply_page.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/cubit/forget_password_cubit.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/pages/forget_password_screen.dart';
import 'package:tracking_app/features/auth/presentation/login/pages/login_screen.dart';
import 'package:tracking_app/features/app_section/presentation/page/app_section_page.dart';
import 'package:tracking_app/features/edit_vehical_info/presentation/cubit/edit_vehicle_info_cubit.dart';
import 'package:tracking_app/features/edit_vehical_info/presentation/pages/edit_vehicle_info_page.dart';
import 'package:tracking_app/features/onboarding/page/onboarding_screen.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_details_args.dart';
import 'package:tracking_app/features/splash/presentation/pages/splash_screen.dart';
import 'package:tracking_app/features/profile/presentation/reset_password/cubit/reset_password_cubit.dart';
import 'package:tracking_app/features/profile/presentation/reset_password/pages/reset_password_page.dart';
import 'package:tracking_app/features/edit_profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:tracking_app/features/edit_profile/presentation/pages/edit_profile_page.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/oreder_details/presentation/cubit/order_details_cubit.dart';
import 'package:tracking_app/features/oreder_details/presentation/cubit/order_details_intents.dart';
import 'package:tracking_app/features/oreder_details/presentation/pages/order_detail_page.dart';
import 'package:tracking_app/features/oreder_details/presentation/pages/order_details_screen.dart';
import 'package:tracking_app/features/splash/presentation/pages/splash_screen.dart';

abstract class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    try {
      switch (settings.name) {
        case Routes.splash:
          return PageTransitions.fade(const SplashScreen());

        case Routes.onboarding:
          return PageTransitions.fade(const OnboardingScreen());

        case Routes.login:
          return PageTransitions.slide(const LoginScreen());

        case Routes.appSection:
          return PageTransitions.fade(const AppSectionsPage());

        case Routes.applyNow:
          return PageTransitions.slide(
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

        case Routes.editProfile:
          return PageTransitions.slide(
            BlocProvider(
              create: (_) => getIt<EditProfileCubit>(),
              child: const EditProfilePage(),
            ),
          );

        case Routes.resetPassword:
          return PageTransitions.fade(
            BlocProvider(
              create: (_) => getIt<ResetPasswordCubit>(),
              child: const ResetPasswordPage(),
            ),
          );

        case Routes.editVehicleInfo:
          return PageTransitions.slide(
            BlocProvider(
              create: (_) => getIt<EditVehicleInfoCubit>(),
              child: const EditVehicleInfoPage(),
            ),
          );

        case Routes.orderDetail:
          final order = settings.arguments as OrderEntity;
          return PageTransitions.slide(OrderDetailPage(order: order));

        case Routes.orderDetails:
          final args = settings.arguments as OrderDetailsArgs;

          return PageTransitions.slide(
            BlocProvider(
              create: (_) => getIt<OrderDetailsCubit>()
                ..doIntent(
                  StartOrderDetailsIntent(
                    order: args.order,
                    initialState: args.state,
                  ),
                ),
              child: const OrderDetailsScreen(),
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

import 'package:tracking_app/config/dependency_injection/di.dart';
import 'package:tracking_app/config/routes/routes.dart';
import 'package:tracking_app/core/localization_constants/error_massage_constants.dart';
import 'package:tracking_app/core/localization_constants/localization_extensions.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/widgets/custom_appbar.dart';
import 'package:tracking_app/core/widgets/custom_snack_bar.dart';
import 'package:tracking_app/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:tracking_app/features/auth/presentation/login/widgets/login_forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: context.login, buttonEnable: false),
        body: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            final loginData = state.loginState.data;

            if (loginData != null) {
              CustomSnackBar.success(context, ErrorConstants.loginSuccessfully);
              Navigator.pushReplacementNamed(context, Routes.appSection);
            }

            if (state.loginState.errorMessage != null) {
              CustomSnackBar.error(context, state.loginState.errorMessage!);
            }
          },
          child: const SingleChildScrollView(child: LoginForm()),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/config/routes/routes.dart';
import 'package:tracking_app/core/layout/app_padding.dart';
import 'package:tracking_app/core/localization_constants/auth_constants.dart';
import 'package:tracking_app/core/widgets/custom_appbar.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/cubit/forget_password_cubit.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/widgets/forget_password_email_step.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/widgets/new_password_step.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/widgets/verify_code_step.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AuthConstants.password),
      body: BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
        listenWhen: (prev, curr) =>
            prev.step != curr.step ||
            prev.resetState.data != curr.resetState.data,
        listener: (context, state) {
          if (state.resetState.data != null) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.login,
              (_) => false,
            );
            return;
          }
          _pageController.animateToPage(
            state.step.index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              ForgetPasswordEmailStep(),
              VerifyCodeStep(),
              NewPasswordStep(),
            ],
          ),
        ),
      ),
    );
  }
}

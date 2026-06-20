import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:tracking_app/core/layout/app_size.dart';
import 'package:tracking_app/core/localization_constants/auth_constants.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/theme/font_size_manager.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';
import 'package:tracking_app/core/widgets/auth_header.dart';
import 'package:tracking_app/core/widgets/custom_snack_bar.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/cubit/forget_password_cubit.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/cubit/forget_password_intents.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/widgets/resend_code_row.dart';

class VerifyCodeStep extends StatefulWidget {
  const VerifyCodeStep({super.key});

  @override
  State<VerifyCodeStep> createState() => _VerifyCodeStepState();
}

class _VerifyCodeStepState extends State<VerifyCodeStep> {
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseDecoration = BoxDecoration(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(AppSize.s10),
      border: Border.all(color: AppColors.border, width: 2),
    );
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: getBoldStyle(
        context: context,
        fontSize: FontSizeManager.s24,
        color: AppColors.textPrimary,
      ),
      decoration: baseDecoration,
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
          listenWhen: (p, c) =>
              p.verifyState.errorMessage != c.verifyState.errorMessage &&
              c.verifyState.errorMessage != null,
          listener: (context, state) => _pinController.clear(),
        ),
        BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
          listenWhen: (p, c) =>
              p.resendState.data != c.resendState.data &&
              c.resendState.data != null,
          listener: (context, state) =>
              CustomSnackBar.success(context, AuthConstants.codeSentAgain),
        ),
        BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
          listenWhen: (p, c) =>
              p.resendState.errorMessage != c.resendState.errorMessage &&
              c.resendState.errorMessage != null,
          listener: (context, state) => CustomSnackBar.error(
            context,
            state.resendState.errorMessage!.tr(),
          ),
        ),
      ],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppSizedBox(height: AppSize.s28),
            AuthHeader(
              title: AuthConstants.emailVerification,
              subtitle: AuthConstants.enterCodeSent,
            ),
            const AppSizedBox(height: AppSize.s28),
            BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
              buildWhen: (p, c) => p.verifyState != c.verifyState,
              builder: (context, state) {
                return Pinput(
                  length: 4,
                  controller: _pinController,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: baseDecoration.copyWith(
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                  ),
                  errorPinTheme: defaultPinTheme.copyWith(
                    decoration: baseDecoration.copyWith(
                      color: AppColors.error.withValues(alpha: 0.05),
                      border: Border.all(color: AppColors.error, width: 2),
                    ),
                  ),
                  forceErrorState: state.verifyState.errorMessage != null,
                  errorText: state.verifyState.errorMessage,
                  onCompleted: (pin) => context
                      .read<ForgetPasswordCubit>()
                      .doIntent(VerifyCodeIntent(pin)),
                );
              },
            ),
            const AppSizedBox(height: AppSize.s24),
            const ResendCodeRow(),
          ],
        ),
      ),
    );
  }
}

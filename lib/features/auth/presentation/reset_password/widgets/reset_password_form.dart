import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/layout/app_size.dart';
import 'package:tracking_app/core/localization_constants/auth_constants.dart';
import 'package:tracking_app/core/localization_constants/general_constants.dart';
import 'package:tracking_app/core/utils/app_validator.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';
import 'package:tracking_app/core/widgets/auth_header.dart';
import 'package:tracking_app/core/widgets/button_loading_widget.dart';
import 'package:tracking_app/core/widgets/custom_text_field.dart';
import 'package:tracking_app/core/widgets/primary_button.dart';
import 'package:tracking_app/features/auth/presentation/reset_password/cubit/reset_password_cubit.dart';
import 'package:tracking_app/features/auth/presentation/reset_password/cubit/reset_password_intents.dart';

class ResetPasswordForm extends StatelessWidget {
  final String email;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> formKey;

  const ResetPasswordForm({
    super.key,
    required this.email,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppSizedBox(height: AppSize.s28),
            AuthHeader(
              title: AuthConstants.resetPassword,
              subtitle: AuthConstants.resetPasswordCondition,
            ),
            const AppSizedBox(height: AppSize.s28),
            CustomTextField(
              controller: passwordController,
              labelText: AuthConstants.newPassword,
              hintText: AuthConstants.enterYourPassword,
              isPassword: true,
              validator: (v) => AppValidator.password(v)?.tr(),
            ),
            const AppSizedBox(height: AppSize.s28),
            CustomTextField(
              controller: confirmPasswordController,
              labelText: AuthConstants.confirmPassword,
              hintText: AuthConstants.confirmPassword,
              isPassword: true,
              validator: (v) => AppValidator.confirmPassword(
                v,
                passwordController.text,
              )?.tr(),
            ),
            const AppSizedBox(height: AppSize.s50),
            BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
              buildWhen: (prev, curr) =>
                  prev.base.isLoading != curr.base.isLoading,
              builder: (context, state) {
                if (state.base.isLoading) return const ButtonLoadingWidget();
                return PrimaryButton(
                  text: GeneralConstants.confirm,
                  onTap: () {
                    if (formKey.currentState?.validate() ?? false) {
                      context.read<ResetPasswordCubit>().doIntent(
                        SubmitResetPasswordIntent(
                          email: email,
                          newPassword: passwordController.text,
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

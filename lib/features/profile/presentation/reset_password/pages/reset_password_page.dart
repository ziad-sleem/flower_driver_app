import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/config/routes/routes.dart';
import 'package:tracking_app/core/layout/app_padding.dart';
import 'package:tracking_app/core/layout/app_size.dart';
import 'package:tracking_app/core/localization_constants/auth_constants.dart';
import 'package:tracking_app/core/localization_constants/general_constants.dart';
import 'package:tracking_app/core/localization_constants/profile_constants.dart';
import 'package:tracking_app/core/utils/app_validator.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';
import 'package:tracking_app/core/widgets/auth_header.dart';
import 'package:tracking_app/core/widgets/button_loading_widget.dart';
import 'package:tracking_app/core/widgets/custom_appbar.dart';
import 'package:tracking_app/core/widgets/custom_snack_bar.dart';
import 'package:tracking_app/core/widgets/custom_text_field.dart';
import 'package:tracking_app/core/widgets/primary_button.dart';
import 'package:tracking_app/features/profile/presentation/reset_password/cubit/reset_password_cubit.dart';


class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ResetPasswordCubit>().doEvent(
            SubmitResetPasswordEvent(
              password: _passwordController.text,
              newPassword: _newPasswordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: ProfileConstants.resetPassword),
      body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listenWhen: (prev, curr) =>
            prev.resetPasswordState.data != curr.resetPasswordState.data ||
            (prev.resetPasswordState.errorMessage !=
                    curr.resetPasswordState.errorMessage &&
                curr.resetPasswordState.errorMessage != null),
        listener: (context, state) {
          if (state.resetPasswordState.errorMessage != null) {
            CustomSnackBar.error(
              context,
              state.resetPasswordState.errorMessage!.tr(),
            );
          }
          if (state.resetPasswordState.data != null) {
            CustomSnackBar.success(
              context,
              state.resetPasswordState.data!.message,
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.login,
              (_) => false,
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AppSizedBox(height: AppSize.s28),
                    AuthHeader(
                      title: ProfileConstants.resetPassword,
                      subtitle: AuthConstants.resetPasswordCondition,
                    ),
                    const AppSizedBox(height: AppSize.s28),
                    CustomTextField(
                      controller: _passwordController,
                      labelText: AuthConstants.password,
                      hintText: AuthConstants.enterYourPassword,
                      isPassword: true,
                      validator: (v) => AppValidator.password(v)?.tr(),
                    ),
                    const AppSizedBox(height: AppSize.s28),
                    CustomTextField(
                      controller: _newPasswordController,
                      labelText: AuthConstants.newPassword,
                      hintText: AuthConstants.enterYourPassword,
                      isPassword: true,
                      validator: (v) => AppValidator.newPassword(
                        v,
                        _passwordController.text,
                      )?.tr(),
                    ),
                    const AppSizedBox(height: AppSize.s28),
                    CustomTextField(
                      controller: _confirmPasswordController,
                      labelText: AuthConstants.confirmPassword,
                      hintText: AuthConstants.confirmPassword,
                      isPassword: true,
                      validator: (v) => AppValidator.confirmPassword(
                        v,
                        _newPasswordController.text,
                      )?.tr(),
                    ),
                    const AppSizedBox(height: AppSize.s50),
                    if (state.resetPasswordState.isLoading)
                      const ButtonLoadingWidget()
                    else
                      PrimaryButton(
                        text: GeneralConstants.confirm,
                        onTap: _submit,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

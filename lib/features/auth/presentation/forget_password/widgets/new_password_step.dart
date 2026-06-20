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
import 'package:tracking_app/core/widgets/custom_snack_bar.dart';
import 'package:tracking_app/core/widgets/custom_text_field.dart';
import 'package:tracking_app/core/widgets/primary_button.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/cubit/forget_password_cubit.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/cubit/forget_password_intents.dart';

class NewPasswordStep extends StatefulWidget {
  const NewPasswordStep({super.key});

  @override
  State<NewPasswordStep> createState() => _NewPasswordStepState();
}

class _NewPasswordStepState extends State<NewPasswordStep> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ForgetPasswordCubit>().doIntent(
        SubmitNewPasswordIntent(_passwordController.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
      listenWhen: (prev, curr) =>
          prev.resetState.errorMessage != curr.resetState.errorMessage &&
          curr.resetState.errorMessage != null,
      listener: (context, state) =>
          CustomSnackBar.error(context, state.resetState.errorMessage!.tr()),
      child: Form(
        key: _formKey,
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
                controller: _passwordController,
                labelText: AuthConstants.newPassword,
                hintText: AuthConstants.enterYourPassword,
                isPassword: true,
                validator: (v) => AppValidator.password(v)?.tr(),
              ),
              const AppSizedBox(height: AppSize.s28),
              CustomTextField(
                controller: _confirmPasswordController,
                labelText: AuthConstants.confirmPassword,
                hintText: AuthConstants.confirmPassword,
                isPassword: true,
                validator: (v) =>
                    AppValidator.confirmPassword(
                      v,
                      _passwordController.text,
                    )?.tr(),
              ),
              const AppSizedBox(height: AppSize.s50),
              BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
                buildWhen: (p, c) =>
                    p.resetState.isLoading != c.resetState.isLoading,
                builder: (context, state) {
                  if (state.resetState.isLoading) {
                    return const ButtonLoadingWidget();
                  }
                  return PrimaryButton(
                    text: GeneralConstants.confirm,
                    onTap: _submit,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

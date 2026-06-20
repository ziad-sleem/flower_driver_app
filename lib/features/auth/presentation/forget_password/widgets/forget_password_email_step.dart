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

class ForgetPasswordEmailStep extends StatefulWidget {
  const ForgetPasswordEmailStep({super.key});

  @override
  State<ForgetPasswordEmailStep> createState() =>
      _ForgetPasswordEmailStepState();
}

class _ForgetPasswordEmailStepState extends State<ForgetPasswordEmailStep> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ForgetPasswordCubit>().doIntent(
        SendResetCodeIntent(_emailController.text.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
      listenWhen: (prev, curr) =>
          prev.sendCodeState.errorMessage != curr.sendCodeState.errorMessage &&
          curr.sendCodeState.errorMessage != null,
      listener: (context, state) =>
          CustomSnackBar.error(context, state.sendCodeState.errorMessage!.tr()),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppSizedBox(height: AppSize.s28),
              AuthHeader(
                title: AuthConstants.forgetPasswordTitle,
                subtitle: AuthConstants.forgetPasswordSubtitle,
              ),
              const AppSizedBox(height: AppSize.s28),
              CustomTextField(
                controller: _emailController,
                labelText: AuthConstants.email,
                hintText: AuthConstants.enterYourEmail,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => AppValidator.email(v)?.tr(),
              ),
              const AppSizedBox(height: AppSize.s50),
              BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
                buildWhen: (p, c) =>
                    p.sendCodeState.isLoading != c.sendCodeState.isLoading,
                builder: (context, state) {
                  if (state.sendCodeState.isLoading) {
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

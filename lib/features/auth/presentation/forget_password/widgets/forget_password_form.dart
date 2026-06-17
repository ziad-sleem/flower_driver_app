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
import 'package:tracking_app/features/auth/presentation/forget_password/cubit/forget_password_cubit.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/cubit/forget_password_intents.dart';

class ForgetPasswordForm extends StatelessWidget {
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;

  const ForgetPasswordForm({
    super.key,
    required this.emailController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
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
            controller: emailController,
            labelText: AuthConstants.email,
            hintText: AuthConstants.enterYourEmail,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => AppValidator.email(v)?.tr(),
          ),
          const AppSizedBox(height: AppSize.s50),
          BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
            buildWhen: (prev, curr) =>
                prev.base.isLoading != curr.base.isLoading,
            builder: (context, state) {
              if (state.base.isLoading) return const ButtonLoadingWidget();
              return PrimaryButton(
                text: GeneralConstants.confirm,
                onTap: () {
                  if (formKey.currentState?.validate() ?? false) {
                    context.read<ForgetPasswordCubit>().doIntent(
                      SubmitForgetPasswordIntent(emailController.text.trim()),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

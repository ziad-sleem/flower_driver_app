import 'package:tracking_app/config/routes/routes.dart';
import 'package:tracking_app/core/localization_constants/localization_extensions.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';
import 'package:tracking_app/core/widgets/button_loading_widget.dart';
import 'package:tracking_app/core/widgets/primary_button.dart';
import 'package:tracking_app/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:tracking_app/features/auth/presentation/login/cubit/login_event.dart';
import 'package:tracking_app/features/auth/presentation/login/widgets/login_text_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<LoginCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const AppSizedBox(height: 30),

            /// fields
            LoginTextFields(
              emailController: emailController,
              passwordController: passwordController,
            ),

            const AppSizedBox(height: 12),

            /// remember me + forgot
            BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: state.rememberMe,
                          onChanged: (value) {
                            vm.doEvent(RememberMeChanged(value!));
                          },
                        ),
                        Text(
                          context.rememberMe,
                          style: getRegularStyle(
                            context: context,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.forgetPassword);
                      },
                      child: Text(
                        context.forgotPassword,
                        style: getTextWithLine(context: context),
                      ),
                    ),
                  ],
                );
              },
            ),

            const AppSizedBox(height: 30),

            /// LOGIN BUTTON
            BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                if (state.loginState.isLoading) {
                  return const ButtonLoadingWidget();
                }
                return PrimaryButton(
                  text: context.login,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      vm.doEvent(
                        Login(
                          email: emailController.text,
                          password: passwordController.text,
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/layout/app_size.dart';
import 'package:tracking_app/core/localization_constants/auth_constants.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/cubit/forget_password_cubit.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/cubit/forget_password_intents.dart';

class ResendCodeRow extends StatelessWidget {
  const ResendCodeRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
      buildWhen: (p, c) =>
          p.resendState.isLoading != c.resendState.isLoading,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AuthConstants.didntReceiveCode,
              style: getRegularStyle(
                context: context,
                color: AppColors.textPrimary,
              ),
            ),
            const AppSizedBox(width: AppSize.s4),
            if (state.resendState.isLoading)
              const SizedBox(
                width: AppSize.s16,
                height: AppSize.s16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              InkWell(
                onTap: () => context.read<ForgetPasswordCubit>().doIntent(
                  const ResendCodeIntent(),
                ),
                child: Text(
                  AuthConstants.resend,
                  style:
                      getSemiBoldStyle(
                        context: context,
                        color: AppColors.primary,
                      ).copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary,
                      ),
                ),
              ),
          ],
        );
      },
    );
  }
}

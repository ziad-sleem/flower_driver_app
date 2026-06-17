import 'package:flutter/material.dart';
import 'package:tracking_app/core/layout/app_size.dart';
import 'package:tracking_app/core/localization_constants/auth_constants.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';

class ResendCodeRow extends StatelessWidget {
  final VoidCallback? onResend;
  final bool isLoading;

  const ResendCodeRow({super.key, this.onResend, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
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
        if (isLoading)
          const SizedBox(
            width: AppSize.s16,
            height: AppSize.s16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        else
          InkWell(
            onTap: onResend,
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
  }
}

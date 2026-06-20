import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tracking_app/core/localization_constants/auth_constants.dart';
import 'package:tracking_app/core/localization_constants/delivery_application_constants.dart';
import 'package:tracking_app/core/resources/app_lottie.dart';
import 'package:tracking_app/core/resources/app_png.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';
import 'package:tracking_app/core/widgets/primary_button.dart';

class SuccessApplyScreen extends StatelessWidget {
  const SuccessApplyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _BackgroundWave(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: const _Content(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Lottie.asset(
            AppLottie.succes,
            repeat: false,
            fit: BoxFit.contain,
          ),
        ),
        Text(
          DeliveryApplicationConstants.submittedTitle,
          textAlign: TextAlign.center,
          style: getSemiBoldStyle(
            context: context,
            color: AppColors.textPrimary,
            fontSize: 18,
          ),
        ),
        const AppSizedBox(height: 16),
        Text(
          DeliveryApplicationConstants.submittedMessage,

          textAlign: TextAlign.center,
          style: getRegularStyle(
            context: context,
            color: AppColors.grey800,
            fontSize: 16,
          ),
        ),
        const AppSizedBox(height: 24),
        PrimaryButton(text: AuthConstants.login, onTap: () {}),
        const Spacer(),
      ],
    );
  }
}

class _BackgroundWave extends StatelessWidget {
  const _BackgroundWave();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Image.asset(
        AppPng.wave,
        width: MediaQuery.sizeOf(context).width,
        fit: BoxFit.cover,
      ),
    );
  }
}

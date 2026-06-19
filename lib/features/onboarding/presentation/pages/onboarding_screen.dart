import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tracking_app/config/routes/routes.dart';
import 'package:tracking_app/core/localization_constants/auth_constants.dart';
import 'package:tracking_app/core/localization_constants/general_constants.dart';
import 'package:tracking_app/core/localization_constants/onboarding_constants.dart';
import 'package:tracking_app/core/resources/app_lottie.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/theme/font_size_manager.dart';
import 'package:tracking_app/core/widgets/primary_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final height = size.height;
    final width = size.width;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.05),
              ClipRect(
                child: SizedBox(
                  width: double.infinity,
                  height: height / 3,
                  child: Transform.scale(
                    scale: 2.1,
                    alignment: const Alignment(0.15, -0.07),
                    child: Lottie.asset(
                      AppLottie.onboarding,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.03),
              Text(
                OnboardingConstants.title,
                style: getMediumStyle(
                  context: context,
                  fontSize: FontSizeManager.s20,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                OnboardingConstants.description,
                style: getMediumStyle(
                  context: context,
                  fontSize: FontSizeManager.s20,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              PrimaryButton(
                text: AuthConstants.login,
                onTap: () => Navigator.pushNamed(context, Routes.login),
              ),
              SizedBox(height: height * 0.015),
              OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, Routes.applyNow),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  foregroundColor: AppColors.grey900,
                  side: const BorderSide(color: AppColors.grey600),
                ),
                child: Text(GeneralConstants.applyNow),
              ),
              SizedBox(height: height * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}

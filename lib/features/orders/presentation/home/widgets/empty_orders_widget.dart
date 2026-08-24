import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/resources/app_lottie.dart';

class EmptyOrdersWidget extends StatelessWidget {
  const EmptyOrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            AppLottie.empty2,
            width: 250,
            height: 250,
            fit: BoxFit.contain,
            repeat: true,
            animate: true,
          ),

          Text(
            "No Pending Orders",
            style: getMediumStyle(
              context: context,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

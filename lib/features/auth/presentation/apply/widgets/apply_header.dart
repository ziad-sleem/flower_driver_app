import 'package:flutter/material.dart';
import 'package:tracking_app/core/localization_constants/delivery_application_constants.dart';
import 'package:tracking_app/core/localization_constants/general_constants.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';

class ApplyHeader extends StatelessWidget {
  const ApplyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          GeneralConstants.welcome,
          style: getMediumStyle(
            context: context,
            fontSize: 20,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "${DeliveryApplicationConstants.title}\n${DeliveryApplicationConstants.joinOurTeam}",
          style: getRegularStyle(
            context: context,
            fontSize: 15,
            color: AppColors.grey900,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tracking_app/core/localization_constants/delivery_application_constants.dart';
import 'package:tracking_app/core/resources/app_value.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';

class GenderSelector extends StatelessWidget {
  final String? selectedGender;

  final ValueChanged<String> onChanged;

  const GenderSelector({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          DeliveryApplicationConstants.gender,
          style: getMediumStyle(
            context: context,
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
        ),
        const Spacer(),
        Radio<String>(
          value: AppKeys.female,
          groupValue: selectedGender,
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
        Text(DeliveryApplicationConstants.female),
        const AppSizedBox(width: 12),
        Radio<String>(
          value: AppKeys.male,
          groupValue: selectedGender,
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
        Text(DeliveryApplicationConstants.male),
      ],
    );
  }
}

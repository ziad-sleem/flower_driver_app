import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/theme/font_size_manager.dart';

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const SummaryRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: getMediumStyle(
              context: context,
              color: AppColors.textPrimary,
              fontSize: FontSizeManager.s14,
            ),
          ),
          Text(
            value,
            style: getMediumStyle(
              context: context,
              color: AppColors.textSecondary,
              fontSize: FontSizeManager.s14,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/theme/font_size_manager.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final double? fontSize;

  const SectionTitle(this.title, {super.key, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: getBoldStyle(
        context: context,
        color: AppColors.textPrimary,
        fontSize: fontSize ?? FontSizeManager.s16,
      ),
    );
  }
}

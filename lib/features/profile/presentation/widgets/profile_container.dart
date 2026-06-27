import 'package:flutter/material.dart';
import 'package:tracking_app/core/layout/app_padding.dart';
import 'package:tracking_app/core/theme/app_colors.dart';

class ProfileContainer extends StatelessWidget {
  final Widget child;
  final VoidCallback? onArrowPressed;
  const ProfileContainer({super.key, required this.child, this.onArrowPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppPadding.p12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          Expanded(child: child),
          if (onArrowPressed != null) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: onArrowPressed,
              icon: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';

class EmptyOrderPageWidget extends StatelessWidget {
  const EmptyOrderPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 70,
            color: Colors.grey.shade500,
          ),

          const SizedBox(height: 20),

          Text(
            "No orders yet",
            style: getSemiBoldStyle(
              context: context,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

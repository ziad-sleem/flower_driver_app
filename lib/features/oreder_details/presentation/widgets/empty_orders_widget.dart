import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';

class EmptyOrdersWidget extends StatelessWidget {
  const EmptyOrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 70,
            color: Colors.grey.shade500,
          ),

          const SizedBox(height: 20),

          Text(
            "No Pending Orders",
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

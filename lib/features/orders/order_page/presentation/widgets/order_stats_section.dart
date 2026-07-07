import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tracking_app/core/localization_constants/status_constants.dart';
import 'package:tracking_app/core/resources/app_svgs.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';

class OrderStatsSection extends StatelessWidget {
  final int cancelledCount;
  final int completedCount;

  const OrderStatsSection({
    super.key,
    required this.cancelledCount,
    required this.completedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            count: cancelledCount,
            label: StatusConstants.cancelled,
            icon: AppSvgs.cancel,
            color: AppColors.primaryLight,
            iconColor: AppColors.error,
          ),
        ),
        const AppSizedBox(width: 12),
        Expanded(
          child: _StatCard(
            count: completedCount,
            label: StatusConstants.completed,
            icon: AppSvgs.checkCircle,
            color: AppColors.primaryLight,
            iconColor: AppColors.success,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final int count;
  final String label;
  final String icon;
  final Color color;
  final Color iconColor;
  const _StatCard({
    required this.count,
    required this.label,
    required this.icon,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$count',
            style: getBoldStyle(
              context: context,
              color: AppColors.textPrimary,
              fontSize: 22,
            ),
          ),
          const AppSizedBox(height: 6),
          Row(
            children: [
              SvgPicture.asset(
                icon,
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
              const AppSizedBox(width: 6),
              Text(
                label,
                style: getMediumStyle(context: context, color: AppColors.textPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

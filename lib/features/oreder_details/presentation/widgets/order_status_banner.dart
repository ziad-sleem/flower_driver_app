import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/theme/font_size_manager.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/oreder_details/presentation/cubit/order_step.dart';

class OrderStatusBanner extends StatelessWidget {
  final OrderEntity order;
  final OrderStep step;

  const OrderStatusBanner({
    super.key,
    required this.order,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    final createdAt = order.createdAt;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Status : ',
                style: getMediumStyle(
                  context: context,
                  color: AppColors.primary,
                  fontSize: FontSizeManager.s14,
                ),
              ),
              Text(
                step.statusLabel,
                style: getMediumStyle(
                  context: context,
                  color: AppColors.success,
                  fontSize: FontSizeManager.s14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Order ID : ${order.orderNumber ?? order.id ?? ''}',
            style: getBoldStyle(
              context: context,
              color: AppColors.textPrimary,
              fontSize: FontSizeManager.s14,
            ),
          ),
          if (createdAt != null) ...[
            const SizedBox(height: 6),
            Text(
              DateFormat('EEE, dd MMM yyyy, hh:mm a').format(createdAt),
              style: getRegularStyle(
                context: context,
                color: AppColors.textSecondary,
                fontSize: FontSizeManager.s12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

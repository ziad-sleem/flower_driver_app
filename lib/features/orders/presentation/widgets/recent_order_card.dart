import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tracking_app/config/routes/routes.dart';
import 'package:tracking_app/core/localization_constants/orders_constants.dart';
import 'package:tracking_app/core/localization_constants/status_constants.dart';
import 'package:tracking_app/core/resources/app_svgs.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_details_response_entity.dart';
import 'package:tracking_app/features/oreder_details/presentation/widgets/address_tile.dart';
import 'package:tracking_app/features/orders/domain/entities/driver_order_entity.dart';

class RecentOrderCard extends StatelessWidget {
  final DriverOrderEntity driverOrder;

  const RecentOrderCard({super.key, required this.driverOrder});

  @override
  Widget build(BuildContext context) {
    final order = driverOrder.order;
    final store = driverOrder.store;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Navigator.pushNamed(
        context,
        Routes.driverOrderDetails,
        arguments: driverOrder,
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  OrdersConstants.flowerOrder,
                  style: getSemiBoldStyle(
                    context: context,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  order?.orderNumber ?? '',
                  style: getMediumStyle(
                    context: context,
                    color: AppColors.grey800,
                  ),
                ),
              ],
            ),

            const AppSizedBox(height: 8),

            _StatusBadge(state: order?.state),

            const AppSizedBox(height: 12),

            Text(OrdersConstants.pickupAddress),
            const AppSizedBox(height: 8),
            AddressTile(
              title: store?.name ?? '',
              address: store?.address ?? '',
              image: store?.image,
            ),

            const AppSizedBox(height: 12),

            Text(OrdersConstants.userAddress),
            const AppSizedBox(height: 8),
            AddressTile(
              title: 'Customer',
              address: order?.shippingAddress?.street ?? '',
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final OrderState? state;

  const _StatusBadge({required this.state});

  @override
  Widget build(BuildContext context) {
    final isCompleted = state == OrderState.completed;
    final color = isCompleted ? AppColors.success : AppColors.error;
    final label = isCompleted
        ? StatusConstants.completed
        : StatusConstants.cancelled;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          isCompleted ? AppSvgs.checkCircle : AppSvgs.cancel,
          width: 16,
          height: 16,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        const AppSizedBox(width: 6),
        Text(
          label,
          style: getMediumStyle(context: context, color: color),
        ),
      ],
    );
  }
}

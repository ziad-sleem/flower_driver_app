import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_Item_entity.dart';

class DriverOrderItemTile extends StatelessWidget {
  final OrderItemEntity item;

  const DriverOrderItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final image = item.product?.imgCover;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 48,
              height: 48,
              child: (image != null && image.isNotEmpty)
                  ? Image.network(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.local_florist),
                    )
                  : const Icon(Icons.local_florist),
            ),
          ),
          const AppSizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product?.title ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: getMediumStyle(
                    context: context,
                    color: AppColors.textPrimary,
                  ),
                ),
                const AppSizedBox(height: 2),
                Text(
                  'EGP ${item.price?.toInt() ?? 0}',
                  style: getBoldStyle(
                    context: context,
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'X${item.quantity ?? 0}',
            style: getMediumStyle(context: context, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

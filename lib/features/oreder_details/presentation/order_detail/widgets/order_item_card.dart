import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/widgets/cached_network_image.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_Item_entity.dart';

class OrderItemCard extends StatelessWidget {
  final OrderItemEntity item;

  const OrderItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          if (item.product?.imgCover != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImageWidget(
                urlToImage: item.product!.imgCover!,
                width: 60,
                height: 60,
              ),
            )
          else
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade100,
              ),
              child: const Icon(Icons.image, color: Colors.grey),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product?.title ?? "Product",
                  style: getMediumStyle(
                    context: context,
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "Qty: ${item.quantity ?? 1}",
                  style: getRegularStyle(
                    context: context,
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "EGP ${(item.price ?? 0).toInt()}",
            style: getMediumStyle(
              context: context,
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/theme/font_size_manager.dart';
import 'package:tracking_app/core/widgets/cached_network_image.dart';
import 'package:tracking_app/features/orders/domain/entities/order_Item_entity.dart';

class OrderItemRow extends StatelessWidget {
  final OrderItemEntity item;

  const OrderItemRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final image = item.product?.imgCover;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 44,
              height: 44,
              child: (image != null && image.isNotEmpty)
                  ? CachedNetworkImageWidget(
                      urlToImage: image,
                      width: 44,
                      height: 44,
                    )
                  : const Icon(Icons.local_florist),
            ),
          ),
          const SizedBox(width: 10),
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
                    fontSize: FontSizeManager.s14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'EGP ${item.price?.toInt() ?? 0}',
                  style: getRegularStyle(
                    context: context,
                    color: AppColors.textSecondary,
                    fontSize: FontSizeManager.s12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'X${item.quantity ?? 0}',
            style: getMediumStyle(
              context: context,
              color: AppColors.primary,
              fontSize: FontSizeManager.s14,
            ),
          ),
        ],
      ),
    );
  }
}

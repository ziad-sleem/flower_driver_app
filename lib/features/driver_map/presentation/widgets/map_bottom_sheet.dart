import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tracking_app/core/localization_constants/orders_constants.dart';
import 'package:tracking_app/core/resources/app_svgs.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/theme/font_size_manager.dart';
import 'package:tracking_app/core/utils/launch_utils.dart';
import 'package:tracking_app/core/widgets/cached_network_image.dart';
import 'package:tracking_app/features/driver_map/domain/entities/driver_map_params.dart';

class MapBottomSheet extends StatelessWidget {
  final DriverMapParams params;
  final double? distance;
  final double? duration;
  final VoidCallback? onDestinationTap;

  const MapBottomSheet({
    super.key,
    required this.params,
    this.distance,
    this.duration,
    this.onDestinationTap,
  });

  @override
  Widget build(BuildContext context) {
    final isToStore = params.mode == MapMode.toStore;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          if (params.orderNumber != null) ...[
            Row(
              children: [
                const Icon(
                  Icons.receipt,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Order #${params.orderNumber}',
                  style: getSemiBoldStyle(
                    context: context,
                    color: AppColors.textPrimary,
                    fontSize: FontSizeManager.s16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
          ],
          _LocationSection(
            icon: AppSvgs.myLocation,
            iconBgColor: const Color(0xFF4CAF50),
            title: OrdersConstants.yourLocation.tr(),
            subtitle: OrdersConstants.yourLocation.tr(),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onDestinationTap,
            child: isToStore
                ? _LocationSection(
                    icon: AppSvgs.floweryLocation,
                    iconBgColor: AppColors.primary,
                    title: params.storeName,
                    subtitle: params.storeAddress.isNotEmpty
                        ? params.storeAddress
                        : null,
                    phone: params.storePhone,
                    distance: distance,
                    duration: duration,
                  )
                : _LocationSection(
                    icon: AppSvgs.userLocation,
                    iconBgColor: const Color(0xFF2196F3),
                    title: params.userName?.isNotEmpty == true
                        ? params.userName!
                        : OrdersConstants.userAddress.tr(),
                    subtitle: params.userAddress,
                    phone: params.userPhone,
                    image: params.userImage,
                    distance: distance,
                    duration: duration,
                  ),
          ),
          if (params.totalPrice != null || params.paymentType != null) ...[
            const SizedBox(height: 14),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 12),
            Row(
              children: [
                if (params.totalPrice != null) ...[
                  _InfoChip(
                    icon: Icons.attach_money,
                    label: '\$${params.totalPrice!.toStringAsFixed(2)}',
                  ),
                  const SizedBox(width: 16),
                ],
                if (params.paymentType != null)
                  _InfoChip(
                    icon: Icons.payment,
                    label: params.paymentType!,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _LocationSection extends StatelessWidget {
  final String icon;
  final Color iconBgColor;
  final String title;
  final String? subtitle;
  final String? phone;
  final String? image;
  final double? distance;
  final double? duration;

  const _LocationSection({
    required this.icon,
    required this.iconBgColor,
    required this.title,
    this.subtitle,
    this.phone,
    this.image,
    this.distance,
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        image != null && image!.isNotEmpty
            ? ClipOval(
                child: CachedNetworkImageWidget(
                  urlToImage: image!,
                  width: 36,
                  height: 36,
                ),
              )
            : CircleAvatar(
                radius: 18,
                backgroundColor: iconBgColor.withValues(alpha: 0.12),
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: SvgPicture.asset(
                    icon,
                    fit: BoxFit.contain,
                    colorFilter: ColorFilter.mode(
                      iconBgColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: getSemiBoldStyle(
                  context: context,
                  color: AppColors.textPrimary,
                  fontSize: FontSizeManager.s14,
                ),
              ),
              if (subtitle != null && subtitle!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: getRegularStyle(
                    context: context,
                    color: AppColors.textSecondary,
                    fontSize: FontSizeManager.s12,
                  ),
                ),
              ],
              if (phone != null && phone!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => makePhoneCall(phone!),
                      child: Icon(
                        Icons.call,
                        size: 14,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => openWhatsApp(phone!),
                      child: Icon(
                        Icons.chat,
                        size: 14,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      phone!,
                      style: getMediumStyle(
                        context: context,
                        color: AppColors.primary,
                        fontSize: FontSizeManager.s12,
                      ),
                    ),
                  ],
                ),
              ],
              if (distance != null && duration != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.route,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDistance(distance!),
                      style: getMediumStyle(
                        context: context,
                        color: AppColors.textPrimary,
                        fontSize: FontSizeManager.s12,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDuration(duration!),
                      style: getMediumStyle(
                        context: context,
                        color: AppColors.textPrimary,
                        fontSize: FontSizeManager.s12,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _formatDistance(double meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
    return '${meters.toStringAsFixed(0)} m';
  }

  String _formatDuration(double seconds) {
    final minutes = (seconds / 60).round();
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      return '${hours}h ${mins}min';
    }
    return '$minutes min';
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(
          label,
          style: getSemiBoldStyle(
            context: context,
            color: AppColors.textPrimary,
            fontSize: FontSizeManager.s12,
          ),
        ),
      ],
    );
  }
}

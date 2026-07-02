import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tracking_app/core/localization_constants/orders_constants.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/theme/font_size_manager.dart';
import 'package:tracking_app/features/driver_map/domain/entities/driver_map_params.dart';

class MapBottomSheet extends StatelessWidget {
  final DriverMapParams params;
  final double? distance;
  final double? duration;

  const MapBottomSheet({
    super.key,
    required this.params,
    this.distance,
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final targetLabel = params.mode == MapMode.toStore
        ? OrdersConstants.pickupAddress.tr()
        : OrdersConstants.userAddress.tr();
    final targetName = params.mode == MapMode.toStore
        ? params.storeName
        : params.userAddress;
    final targetSvg = params.mode == MapMode.toStore
        ? 'assets/svgs/flowery_location.svg'
        : 'assets/svgs/user_location.svg';

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
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
          _LocationRow(
            icon: 'assets/svgs/my_location.svg',
            label: OrdersConstants.yourLocation.tr(),
            value: OrdersConstants.yourLocation.tr(),
            iconWidth: 90,
            iconHeight: 20,
          ),
          const SizedBox(height: 12),
          _LocationRow(
            icon: targetSvg,
            label: targetLabel,
            value: targetName,
            iconWidth: params.mode == MapMode.toStore ? 56 : 44,
            iconHeight: params.mode == MapMode.toStore ? 20 : 24,
          ),
          if (distance != null && duration != null) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.route, size: 18, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  _formatDistance(distance!),
                  style: getMediumStyle(
                    context: context,
                    color: AppColors.textPrimary,
                    fontSize: FontSizeManager.s14,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.access_time, size: 18, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  _formatDuration(duration!),
                  style: getMediumStyle(
                    context: context,
                    color: AppColors.textPrimary,
                    fontSize: FontSizeManager.s14,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
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

class _LocationRow extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final double iconWidth;
  final double iconHeight;

  const _LocationRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconWidth,
    required this.iconHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          width: iconWidth,
          height: iconHeight,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: getRegularStyle(
                  context: context,
                  color: AppColors.textSecondary,
                  fontSize: FontSizeManager.s12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getMediumStyle(
                  context: context,
                  color: AppColors.textPrimary,
                  fontSize: FontSizeManager.s14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

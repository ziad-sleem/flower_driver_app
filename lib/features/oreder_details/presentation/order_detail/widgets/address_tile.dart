import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/theme/font_size_manager.dart';
import 'package:tracking_app/core/utils/launch_utils.dart';
import 'package:tracking_app/core/widgets/cached_network_image.dart';

class AddressTile extends StatelessWidget {
  final String title;
  final String address;
  final String? image;
  final String? phone;
  final VoidCallback? onNavigate;

  const AddressTile({
    super.key,
    required this.title,
    required this.address,
    this.image,
    this.phone,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          image != null && image!.isNotEmpty
              ? ClipOval(
                  child: CachedNetworkImageWidget(
                    urlToImage: image!,
                    width: 36,
                    height: 36,
                  ),
                )
              : const CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.background,
                  child: Icon(Icons.store, size: 18),
                ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getMediumStyle(
                    context: context,
                    color: AppColors.textPrimary,
                    fontSize: FontSizeManager.s14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        address,
                        overflow: TextOverflow.ellipsis,
                        style: getRegularStyle(
                          context: context,
                          color: AppColors.textSecondary,
                          fontSize: FontSizeManager.s12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (onNavigate != null)
            GestureDetector(
              onTap: onNavigate,
              child: const Icon(
                Icons.map,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          if (phone != null && phone!.isNotEmpty) ...[
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => makePhoneCall(phone!),
              child: const Icon(
                Icons.call,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => openWhatsApp(phone!),
              child: const Icon(
                Icons.chat,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

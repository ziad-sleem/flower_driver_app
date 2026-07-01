import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/widgets/app_shimmer.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';

class OrderCardShimmer extends StatelessWidget {
  const OrderCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey900),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _line(width: 110, height: 16),

            const AppSizedBox(height: 16),

            _line(width: 100, height: 13),

            const AppSizedBox(height: 10),

            _addressCard(),

            const AppSizedBox(height: 16),

            _line(width: 88, height: 13),

            const AppSizedBox(height: 10),

            _addressCard(),

            const AppSizedBox(height: 16),

            Row(
              children: [
                _line(width: 72, height: 16),
                const Spacer(),
                _outlineButton(),
                const AppSizedBox(width: 10),
                _filledButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _addressCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.grey900),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.grey600,
              shape: BoxShape.circle,
            ),
          ),
          const AppSizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line(width: 110, height: 13),
                const AppSizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.grey600,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const AppSizedBox(width: 6),
                    Expanded(child: _line(width: double.infinity, height: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _outlineButton() {
    return Container(
      width: 88,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.grey600,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.grey900, width: 1.5),
      ),
    );
  }

  Widget _filledButton() {
    return Container(
      width: 88,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.grey600,
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }

  Widget _line({required double width, double height = 12}) {
    return Container(
      width: width == double.infinity ? null : width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.grey600,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

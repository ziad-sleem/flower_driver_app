import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/widgets/app_shimmer.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';

class OrderDetailsScreenShimmer extends StatelessWidget {
  const OrderDetailsScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _progressBar(),
            const AppSizedBox(height: 20),
            _statusBanner(),
            const AppSizedBox(height: 20),
            _line(width: 120, height: 16),
            const AppSizedBox(height: 10),
            _addressCard(),
            const AppSizedBox(height: 20),
            _line(width: 100, height: 16),
            const AppSizedBox(height: 10),
            _addressCard(),
            const AppSizedBox(height: 20),
            _line(width: 110, height: 16),
            const AppSizedBox(height: 10),
            _orderItemRow(),
            const AppSizedBox(height: 8),
            _orderItemRow(),
            const AppSizedBox(height: 8),
            const Divider(),
            _summaryRow(),
            const Divider(),
            _summaryRow(),
          ],
        ),
      ),
    );
  }

  Widget _progressBar() {
    return Row(
      children: List.generate(
        4,
        (_) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey600,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.grey900),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _line(width: 60, height: 14),
              const AppSizedBox(width: 8),
              _line(width: 80, height: 14),
            ],
          ),
          const AppSizedBox(height: 8),
          _line(width: 140, height: 14),
          const AppSizedBox(height: 8),
          _line(width: 180, height: 12),
        ],
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
            width: 36,
            height: 36,
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
                _line(width: 100, height: 13),
                const AppSizedBox(height: 6),
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

  Widget _orderItemRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.grey600,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const AppSizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line(width: 120, height: 13),
                const AppSizedBox(height: 4),
                _line(width: 60, height: 12),
              ],
            ),
          ),
          _line(width: 30, height: 13),
        ],
      ),
    );
  }

  Widget _summaryRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _line(width: 100, height: 14),
          _line(width: 70, height: 14),
        ],
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

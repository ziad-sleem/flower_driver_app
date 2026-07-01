import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tracking_app/core/theme/app_colors.dart';

class AppShimmer extends StatelessWidget {
  final Widget child;

  const AppShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 1100),
      baseColor: AppColors.grey600.withAlpha(60),
      highlightColor: AppColors.background,
      child: child,
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/widgets/order_card_shimmer.dart';

class LoadingOrdersWidget extends StatelessWidget {
  const LoadingOrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) => const OrderCardShimmer(),
    );
  }
}

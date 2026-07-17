import 'package:flutter/material.dart';
import 'package:tracking_app/core/widgets/order_card_shimmer.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';
import 'order_card.dart';

class OrdersList extends StatelessWidget {
  final List<OrderEntity> orders;
  final ScrollController controller;
  final bool isLoadingMore;

  const OrdersList({
    super.key,
    required this.orders,
    required this.controller,
    required this.isLoadingMore,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: controller,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: orders.length + (isLoadingMore ? 1 : 0),
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, index) {
        if (index == orders.length) {
          return OrderCardShimmer();
        }

        return OrderCard(order: orders[index]);
      },
    );
  }
}

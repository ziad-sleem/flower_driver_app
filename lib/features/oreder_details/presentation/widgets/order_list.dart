import 'package:flutter/material.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';
import 'order_card.dart';

class OrdersList extends StatelessWidget {
  final List<OrderEntity> orders;

  const OrdersList({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, index) {
        return OrderCard(order: orders[index]);
      },
    );
  }
}

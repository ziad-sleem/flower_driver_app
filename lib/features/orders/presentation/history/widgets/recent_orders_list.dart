import 'package:flutter/material.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';
import 'package:tracking_app/features/orders/domain/entities/driver_order_entity.dart';
import 'recent_order_card.dart';

/// Renders as a plain [Column] (not its own scroll view) so the parent page
/// can host a single scrollable that [RefreshIndicator] can attach to.
class RecentOrdersList extends StatelessWidget {
  final List<DriverOrderEntity> orders;

  const RecentOrdersList({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final order in orders) ...[
          RecentOrderCard(driverOrder: order),
          if (order != orders.last) const AppSizedBox(height: 12),
        ],
      ],
    );
  }
}

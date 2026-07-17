import 'package:flutter/material.dart';
import 'package:tracking_app/core/localization_constants/orders_constants.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';
import 'package:tracking_app/core/widgets/custom_appbar.dart';
import 'package:tracking_app/features/oreder_details/presentation/order_detail/widgets/address_tile.dart';
import 'package:tracking_app/features/oreder_details/presentation/order_detail/widgets/section_title.dart';
import 'package:tracking_app/features/orders/presentation/widgets/driver_order_details_shimmer.dart';
import 'package:tracking_app/features/orders/presentation/widgets/driver_order_item_tile.dart';
import 'package:tracking_app/features/orders/presentation/widgets/driver_order_status_row.dart';
import 'package:tracking_app/features/orders/presentation/widgets/driver_order_summary_section.dart';
import 'package:tracking_app/features/orders/domain/entities/driver_order_entity.dart';

class DriverOrderDetailsPage extends StatelessWidget {
  final DriverOrderEntity driverOrder;

  const DriverOrderDetailsPage({super.key, required this.driverOrder});

  @override
  Widget build(BuildContext context) {
    final order = driverOrder.order;
    final store = driverOrder.store;

    return Scaffold(
      appBar: CustomAppBar(title: OrdersConstants.orderDetails),
      body: SafeArea(
        child: order == null
            ? const DriverOrderDetailsShimmer()
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DriverOrderStatusRow(
                state: order.state,
                orderNumber: order.orderNumber ?? '',
              ),

              const AppSizedBox(height: 20),

              SectionTitle(OrdersConstants.pickupAddress),
              const AppSizedBox(height: 8),
              AddressTile(
                title: store?.name ?? '',
                address: store?.address ?? '',
                image: store?.image,
              ),

              const AppSizedBox(height: 20),

              SectionTitle(OrdersConstants.userAddress),
              const AppSizedBox(height: 8),
              AddressTile(
                title: _userName(order.user),
                address: order.shippingAddress?.street ?? '',
              ),

              const AppSizedBox(height: 20),

              SectionTitle(OrdersConstants.orderDetails),
              const AppSizedBox(height: 8),
              for (final item in order.orderItems ?? [])
                DriverOrderItemTile(item: item),

              const AppSizedBox(height: 8),
              DriverOrderSummarySection(
                totalPrice: order.totalPrice,
                paymentType: order.paymentType,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _userName(Object? user) {
    if (user is Map) {
      final name = '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'
          .trim();
      if (name.isNotEmpty) return name;
    }
    return 'Customer';
  }
}

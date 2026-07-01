import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';
import 'package:tracking_app/core/widgets/custom_appbar.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_Item_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_details_response_entity.dart';
import 'package:tracking_app/features/oreder_details/presentation/cubit/home_cubit.dart';
import 'package:tracking_app/features/oreder_details/presentation/cubit/home_event.dart';
import 'package:tracking_app/features/oreder_details/presentation/widgets/address_tile.dart';

class OrderDetailPage extends StatelessWidget {
  final OrderEntity order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final acceptLoading = context.select<HomeCubit, bool>(
      (cubit) =>
          cubit.state.acceptOrderState.isLoading &&
          cubit.state.acceptingOrderId == order.id,
    );

    final rejectLoading = context.select<HomeCubit, bool>(
      (cubit) =>
          cubit.state.rejectOrderState.isLoading &&
          cubit.state.rejectingOrderId == order.id,
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: "Order #${order.orderNumber ?? order.id?.substring(0, 8) ?? ""}",
        subtitle: _statusLabel(order.state),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(title: "Pickup address"),
              const AppSizedBox(height: 8),
              AddressTile(
                title: order.store?.name ?? "",
                address: order.store?.address ?? "",
                image: order.store?.image,
              ),

              const AppSizedBox(height: 20),

              _SectionHeader(title: "Delivery address"),
              const AppSizedBox(height: 8),
              AddressTile(
                title: "Customer",
                address: order.shippingAddress?.street ?? "",
              ),
              if (order.shippingAddress?.city != null) ...[
                const AppSizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    "City: ${order.shippingAddress!.city}",
                    style: getRegularStyle(
                      context: context,
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],

              const AppSizedBox(height: 20),

              _SectionHeader(
                title: "Order items (${order.orderItems?.length ?? 0})",
              ),
              const AppSizedBox(height: 8),
              if (order.orderItems != null && order.orderItems!.isNotEmpty)
                ...order.orderItems!.map((item) => _OrderItemTile(item: item))
              else
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "No items",
                    style: getRegularStyle(
                      context: context,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

              const AppSizedBox(height: 20),

              _SectionHeader(title: "Payment"),
              const AppSizedBox(height: 8),
              _PaymentInfoRow(
                label: "Payment method",
                value: _paymentLabel(order.paymentType),
              ),
              _PaymentInfoRow(
                label: "Paid",
                value: order.isPaid == true ? "Yes" : "No",
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: getBoldStyle(
                      context: context,
                      color: AppColors.textPrimary,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "EGP ${order.totalPrice?.toInt() ?? 0}",
                    style: getBoldStyle(
                      context: context,
                      color: AppColors.primary,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),

              const AppSizedBox(height: 32),

              if (order.state == OrderState.pending)
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: rejectLoading
                              ? null
                              : () {
                                  context.read<HomeCubit>().doEvent(
                                    RejectOrder(order: order),
                                  );
                                },
                          child: rejectLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  "Reject",
                                  style: getMediumStyle(
                                    context: context,
                                    color: AppColors.primary,
                                    fontSize: 15,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const AppSizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.background,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                          ),
                          onPressed: acceptLoading
                              ? null
                              : () {
                                  context.read<HomeCubit>().doEvent(
                                    AcceptOrder(order: order),
                                  );
                                },
                          child: acceptLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  "Accept",
                                  style: getMediumStyle(
                                    context: context,
                                    color: AppColors.background,
                                    fontSize: 15,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),

              const AppSizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  String _paymentLabel(PaymentType? type) {
    switch (type) {
      case PaymentType.cash:
        return "Cash";
      case PaymentType.visa:
        return "Visa";
      case PaymentType.wallet:
        return "Wallet";
      case null:
        return "N/A";
    }
  }

  String _statusLabel(OrderState? state) {
    switch (state) {
      case OrderState.pending:
        return "Pending";
      case OrderState.inProgress:
        return "In Progress";
      case OrderState.completed:
        return "Delivered";
      case OrderState.canceled:
        return "Cancelled";
      case null:
        return "";
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: getBoldStyle(
        context: context,
        color: AppColors.textPrimary,
        fontSize: 16,
      ),
    );
  }
}

class _OrderItemTile extends StatelessWidget {
  final OrderItemEntity item;

  const _OrderItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          if (item.product?.imgCover != null)
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(item.product!.imgCover!),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade100,
              ),
              child: const Icon(Icons.image, color: Colors.grey),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product?.title ?? "Product",
                  style: getMediumStyle(
                    context: context,
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const AppSizedBox(height: 4),
                Text(
                  "Qty: ${item.quantity ?? 1}",
                  style: getRegularStyle(
                    context: context,
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "EGP ${(item.price ?? 0).toInt()}",
            style: getMediumStyle(
              context: context,
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _PaymentInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: getRegularStyle(
              context: context,
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: getMediumStyle(
              context: context,
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

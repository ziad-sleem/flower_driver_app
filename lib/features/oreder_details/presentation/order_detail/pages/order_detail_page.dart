import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';
import 'package:tracking_app/core/widgets/custom_appbar.dart';
import 'package:tracking_app/features/oreder_details/data/models/order_user_info_model.dart';
import 'package:tracking_app/features/oreder_details/presentation/order_detail/cubit/order_user_info_cubit.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_details_response_entity.dart';
import 'package:tracking_app/features/oreder_details/presentation/home/cubit/home_cubit.dart';
import 'package:tracking_app/features/oreder_details/presentation/home/widgets/accept_reject_buttons.dart';
import 'package:tracking_app/features/oreder_details/presentation/order_detail/widgets/address_tile.dart';
import 'package:tracking_app/features/oreder_details/presentation/order_detail/widgets/order_item_card.dart';
import 'package:tracking_app/features/oreder_details/presentation/order_detail/widgets/section_title.dart';
import 'package:tracking_app/features/oreder_details/presentation/order_detail/widgets/summary_row.dart';
import 'package:tracking_app/core/utils/launch_utils.dart';

class OrderDetailPage extends StatelessWidget {
  final OrderEntity order;

  const OrderDetailPage({super.key, required this.order});

  static String? _userId(Object? user) {
    if (user is Map) {
      final id = user['_id']?.toString();
      if (id != null && id.isNotEmpty) return id;
    }
    return null;
  }

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

    final userInfo = context.select<OrderUserInfoCubit, OrderUserInfoModel?>(
      (cubit) => cubit.state.userInfoMap[order.id] ??
          cubit.state.userInfoMap[_userId(order.user)],
    );
    final userName =
        userInfo?.userName.isNotEmpty == true ? userInfo!.userName : null;
    final userCity = order.shippingAddress?.city ?? userInfo?.city;

    return Scaffold(
      appBar: CustomAppBar(
        title:
            "Order #${order.orderNumber ?? order.id?.substring(0, 8) ?? ""}",
        subtitle: _statusLabel(order.state),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle("Pickup address"),
              const AppSizedBox(height: 8),
              AddressTile(
                title: order.store?.name ?? "",
                address: order.store?.address ?? "",
                image: order.store?.image,
              ),

              const AppSizedBox(height: 20),

              SectionTitle("Delivery address"),
              const AppSizedBox(height: 8),
              AddressTile(
                title: userName ?? "Customer",
                address: order.shippingAddress?.street ??
                    userInfo?.street ??
                    "",
                image: userInfo?.userImage,
              ),
              if (userInfo?.userPhone.isNotEmpty == true) ...[
                const AppSizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.phone,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        userInfo!.userPhone,
                        style: getRegularStyle(
                          context: context,
                          color: AppColors.primary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => makePhoneCall(userInfo.userPhone),
                        child: const Icon(
                          Icons.call,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => openWhatsApp(userInfo.userPhone),
                        child: const Icon(
                          Icons.chat,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (userCity != null && userCity.isNotEmpty) ...[
                const AppSizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    "City: $userCity",
                    style: getRegularStyle(
                      context: context,
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],

              const AppSizedBox(height: 20),

              SectionTitle(
                  "Order items (${order.orderItems?.length ?? 0})"),
              const AppSizedBox(height: 8),
              if (order.orderItems != null &&
                  order.orderItems!.isNotEmpty)
                ...order.orderItems!
                    .map((item) => OrderItemCard(item: item))
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

              SectionTitle("Payment"),
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

              AcceptRejectButtons(
                order: order,
                acceptLoading: acceptLoading,
                rejectLoading: rejectLoading,
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

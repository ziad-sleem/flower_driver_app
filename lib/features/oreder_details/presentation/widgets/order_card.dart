import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/config/routes/routes.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/oreder_details/presentation/cubit/home_cubit.dart';
import 'package:tracking_app/features/oreder_details/presentation/cubit/home_event.dart';
import 'package:tracking_app/features/oreder_details/presentation/widgets/address_tile.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;

  const OrderCard({super.key, required this.order});

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
    return InkWell(
      onTap: () => Navigator.pushNamed(context, Routes.orderDetail, arguments: order),
      borderRadius: BorderRadius.circular(12),
      child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Flower order",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          const Text("Pickup address"),

          const SizedBox(height: 8),

          AddressTile(
            title: order.store?.name ?? "",
            address: order.store?.address ?? "",
            image: order.store?.image,
          ),

          const SizedBox(height: 12),

          const Text("User address"),

          const SizedBox(height: 8),

          AddressTile(
            title: "Customer",
            address: order.shippingAddress?.street ?? "",
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Text(
                "EGP ${order.totalPrice?.toInt() ?? 0}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),

              SizedBox(
                width: 90,
                height: 35,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.zero,
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
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          "Reject",
                          style: getMediumStyle(
                            context: context,
                            color: AppColors.primary,
                            fontSize: 14,
                          ),
                        ),
                ),
              ),

              AppSizedBox(width: 10),

              SizedBox(
                width: 90,
                height: 35,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.zero,
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
                          width: 18,
                          height: 18,
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
                            fontSize: 14,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}

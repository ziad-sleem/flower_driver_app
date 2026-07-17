import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';
import 'package:tracking_app/features/oreder_details/data/models/enums/order_details_enums.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/oreder_details/presentation/home/cubit/home_cubit.dart';
import 'package:tracking_app/features/oreder_details/presentation/home/cubit/home_event.dart';

class AcceptRejectButtons extends StatelessWidget {
  final OrderEntity order;
  final bool acceptLoading;
  final bool rejectLoading;

  const AcceptRejectButtons({
    super.key,
    required this.order,
    required this.acceptLoading,
    required this.rejectLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (order.state != OrderState.pending) return const SizedBox.shrink();

    return Row(
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
                      child: CircularProgressIndicator(strokeWidth: 2),
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
    );
  }
}

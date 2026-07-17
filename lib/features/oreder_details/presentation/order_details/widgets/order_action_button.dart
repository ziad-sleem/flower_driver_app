import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/config/routes/routes.dart';
import 'package:tracking_app/core/localization_constants/orders_constants.dart';
import 'package:tracking_app/core/widgets/button_loading_widget.dart';
import 'package:tracking_app/features/oreder_details/presentation/order_details/cubit/order_details_cubit.dart';
import 'package:tracking_app/features/oreder_details/presentation/order_details/cubit/order_details_intents.dart';
import 'package:tracking_app/features/oreder_details/presentation/order_details/cubit/order_step.dart';

class OrderActionButton extends StatelessWidget {
  const OrderActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
      buildWhen: (p, c) =>
          p.step != c.step ||
          p.updateState.isLoading != c.updateState.isLoading ||
          p.updateState.data != c.updateState.data,
      builder: (context, state) {
        final step = state.step;
        if (step == null) return const SizedBox.shrink();

        final loading = state.updateState.isLoading;

        final waiting =
            step == OrderStep.arrived && state.updateState.data == true;

        final disabled = loading || waiting;

        if (loading) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: ButtonLoadingWidget(),
          );
        }

        return SafeArea(
          minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: disabled
                  ? null
                  : () {
                      if (step == OrderStep.delivered) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.appSection,
                          (route) => false,
                        );
                        return;
                      }

                      context.read<OrderDetailsCubit>().doIntent(
                        const AdvanceOrderStepIntent(),
                      );
                    },
              child: Text(
                waiting
                    ? OrdersConstants.waitingForCustomerConfirmation
                    : step.buttonLabel,
              ),
            ),
          ),
        );
      },
    );
  }
}

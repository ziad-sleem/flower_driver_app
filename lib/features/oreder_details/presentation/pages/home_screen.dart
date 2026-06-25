import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tracking_app/config/routes/routes.dart';
import 'package:tracking_app/core/resources/app_svgs.dart';
import 'package:tracking_app/core/widgets/app_error_widget.dart';
import 'package:tracking_app/features/oreder_details/presentation/cubit/home_cubit.dart';
import 'package:tracking_app/features/oreder_details/presentation/cubit/home_event.dart';
import 'package:tracking_app/features/oreder_details/presentation/widgets/loading_order.dart';
import 'package:tracking_app/features/oreder_details/presentation/widgets/order_list.dart';
import '../widgets/empty_orders_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state.acceptOrderState.data == true) {
              Navigator.pushNamed(context, Routes.succesApply);
            }

            if (state.rejectOrderState.data == true) {
              context.read<HomeCubit>().doEvent(GetPendingOrders());
            }

            /// Reject Error
            if (state.rejectOrderState.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.rejectOrderState.errorMessage!)),
              );
            }

            /// Accept Error
            if (state.acceptOrderState.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.acceptOrderState.errorMessage!)),
              );
            }
          },
          builder: (context, state) {
            final ordersState = state.ordersState;

            if (ordersState.isLoading) {
              return const LoadingOrdersWidget();
            }

            if (ordersState.errorMessage != null) {
              return AppErrorWidget(
                errorMessage: ordersState.errorMessage!,
                onRetry: () {
                  context.read<HomeCubit>().doEvent(GetPendingOrders());
                },
              );
            }

            final orders = ordersState.data?.orders ?? [];

            if (orders.isEmpty) {
              return const EmptyOrdersWidget();
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeCubit>().doEvent(GetPendingOrders());
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SvgPicture.asset(AppSvgs.homeLogo),
                    ),
                  ),
                  Expanded(child: OrdersList(orders: orders)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

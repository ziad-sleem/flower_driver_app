import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/localization_constants/orders_constants.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/widgets/app_error_widget.dart';
import 'package:tracking_app/core/widgets/app_loading_widget.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';
import 'package:tracking_app/features/orders/presentation/cubit/order_page_cubit.dart';
import 'package:tracking_app/features/orders/presentation/widgets/empty_order_page_widget.dart';
import 'package:tracking_app/features/orders/presentation/widgets/order_stats_section.dart';
import 'package:tracking_app/features/orders/presentation/widgets/recent_orders_list.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<OrderPageCubit, OrderPageState>(
          builder: (context, state) {
            if (state.isLoading && state.orders.isEmpty) {
              return const AppLoadingWidget();
            }

            if (state.errorMessage != null && state.orders.isEmpty) {
              return AppErrorWidget(
                errorMessage: state.errorMessage!,
                onRetry: () =>
                    context.read<OrderPageCubit>().loadDriverOrders(),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<OrderPageCubit>().loadDriverOrders(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    OrdersConstants.myOrders,
                    style: getSemiBoldStyle(
                      context: context,
                      color: AppColors.textPrimary,
                      fontSize: 20,
                    ),
                  ),
                  const AppSizedBox(height: 16),
                  OrderStatsSection(
                    cancelledCount: state.cancelledCount,
                    completedCount: state.completedCount,
                  ),
                  const AppSizedBox(height: 20),
                  Text(
                    OrdersConstants.recentOrders,
                    style: getSemiBoldStyle(
                      context: context,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const AppSizedBox(height: 12),
                  if (state.orders.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: EmptyOrderPageWidget(),
                    )
                  else
                    RecentOrdersList(orders: state.orders),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tracking_app/config/routes/routes.dart';
import 'package:tracking_app/core/resources/app_svgs.dart';
import 'package:tracking_app/core/widgets/app_error_widget.dart';
import 'package:tracking_app/core/widgets/order_card_shimmer.dart';
import 'package:tracking_app/features/orders/domain/entities/order_details_args.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_event.dart';
import '../widgets/loading_order_widget.dart';
import '../widgets/order_card.dart';
import '../widgets/empty_orders_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();

    _controller = ScrollController()
      ..addListener(() {
        final cubit = context.read<HomeCubit>();

        if (_controller.position.pixels >=
                _controller.position.maxScrollExtent - 250 &&
            !cubit.state.isLoadingMore &&
            cubit.state.hasMore) {
          cubit.doEvent(const LoadMoreOrders());
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state.acceptOrderState.data == true &&
                state.acceptedOrder != null) {
              Navigator.pushNamed(
                context,
                Routes.orderDetails,
                arguments: OrderDetailsArgs(
                  order: state.acceptedOrder!,
                  state: "inProgress",
                ),
              );
            }

            if (state.acceptOrderState.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.acceptOrderState.errorMessage!)),
              );
            }

            if (state.rejectOrderState.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.rejectOrderState.errorMessage!)),
              );
            }
          },
          listenWhen: (previous, current) {
            return previous.acceptOrderState != current.acceptOrderState ||
                previous.rejectOrderState != current.rejectOrderState;
          },
          builder: (context, state) {
            final ordersState = state.ordersState;

            if (ordersState.isLoading && state.orders.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 50,
                ),
                child: LoadingOrdersWidget(),
              );
            }

            if (ordersState.errorMessage != null) {
              return AppErrorWidget(
                errorMessage: ordersState.errorMessage!,
                onRetry: () {
                  context.read<HomeCubit>().doEvent(const GetPendingOrders());
                },
              );
            }

            if (state.orders.isEmpty) {
              return RefreshIndicator(
                onRefresh: () => context.read<HomeCubit>().refresh(),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: const EmptyOrdersWidget(),
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<HomeCubit>().refresh(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _controller,
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SvgPicture.asset(AppSvgs.homeLogo),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == state.orders.length) {
                            return const OrderCardShimmer();
                          }
                          return OrderCard(order: state.orders[index]);
                        },
                        childCount: state.orders.length +
                            (state.isLoadingMore ? 1 : 0),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/config/routes/routes.dart';
import 'package:latlong2/latlong.dart';
import 'package:tracking_app/core/localization_constants/orders_constants.dart';
import 'package:tracking_app/core/utils/geocoding_helper.dart';
import 'package:tracking_app/core/widgets/custom_appbar.dart';
import 'package:tracking_app/core/widgets/custom_snack_bar.dart';
import 'package:tracking_app/features/driver_map/domain/entities/driver_map_params.dart';
import 'package:tracking_app/features/oreder_details/data/models/order_user_info_model.dart';
import 'package:tracking_app/features/oreder_details/presentation/cubit/order_user_info_cubit.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_Item_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_details_response_entity.dart';
import 'package:tracking_app/features/oreder_details/presentation/cubit/order_details_cubit.dart';
import 'package:tracking_app/features/oreder_details/presentation/widgets/address_tile.dart';
import 'package:tracking_app/features/oreder_details/presentation/widgets/order_action_button.dart';
import 'package:tracking_app/features/oreder_details/presentation/widgets/order_item_row.dart';
import 'package:tracking_app/features/oreder_details/presentation/widgets/order_progress_bar.dart';
import 'package:tracking_app/features/oreder_details/presentation/widgets/order_status_banner.dart';
import 'package:tracking_app/features/oreder_details/presentation/widgets/order_details_screen_shimmer.dart';
import 'package:tracking_app/features/oreder_details/presentation/widgets/section_title.dart';
import 'package:tracking_app/features/oreder_details/presentation/widgets/summary_row.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            appBar: CustomAppBar(
              title: OrdersConstants.orderDetails,
              showBackButton: false,
            ),
            body: BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
              listenWhen: (previous, current) {
                return previous.step != current.step ||
                    previous.updateState.errorMessage !=
                        current.updateState.errorMessage;
              },
              listener: (context, state) {
                if (state.updateState.errorMessage != null) {
                  CustomSnackBar.error(
                    context,
                    state.updateState.errorMessage!,
                  );
                }
              },
              builder: (context, state) {
                final order = state.order;
                final step = state.step;

                if (order == null || step == null) {
                  return const OrderDetailsScreenShimmer();
                }

                final userInfo = context
                    .select<OrderUserInfoCubit, OrderUserInfoModel?>(
                      (cubit) => cubit.state.userInfoMap[order.id] ??
                          cubit.state.userInfoMap[_userId(order.user)],
                    );

                return Column(
                  children: [
                    OrderProgressBar(step: step),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            OrderStatusBanner(order: order, step: step),
                            const SizedBox(height: 20),
                            SectionTitle(OrdersConstants.pickupAddress),
                            const SizedBox(height: 10),
                            AddressTile(
                              title: order.store?.name ?? '',
                              address: order.store?.address ?? '',
                              image: order.store?.image,
                              phone: order.store?.phoneNumber,
                              onNavigate: () =>
                                  _openMap(context, MapMode.toStore),
                            ),
                            const SizedBox(height: 20),
                            SectionTitle(OrdersConstants.userAddress),
                            const SizedBox(height: 10),
                            AddressTile(
                              title: _userName(
                                order.user,
                                userInfo?.city ??
                                    order.shippingAddress?.city,
                                userInfo,
                              ),
                              address: order.shippingAddress?.street ??
                                  userInfo?.street ??
                                  '',
                              image: userInfo?.userImage,
                              phone: userInfo?.userPhone.isNotEmpty == true
                                  ? userInfo!.userPhone
                                  : order.shippingAddress?.phone,
                              onNavigate: () =>
                                  _openMap(context, MapMode.toUser),
                            ),
                            const SizedBox(height: 20),
                            SectionTitle(OrdersConstants.orderDetails),
                            const SizedBox(height: 10),
                            _OrderItemsSection(
                              items: order.orderItems ?? const [],
                            ),
                            const SizedBox(height: 8),
                            const Divider(),
                            SummaryRow(
                              label: OrdersConstants.total,
                              value:
                                  'EGP ${order.totalPrice?.toInt() ?? 0}',
                            ),
                            const Divider(),
                            SummaryRow(
                              label: OrdersConstants.paymentMethod,
                              value: _paymentLabel(order.paymentType),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const OrderActionButton(),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  static String? _userId(Object? user) {
    if (user is Map) {
      final id = user['_id']?.toString();
      if (id != null && id.isNotEmpty) return id;
    }
    return null;
  }

  static String _userName(
    Object? user,
    String? fallback,
    OrderUserInfoModel? userInfo,
  ) {
    if (userInfo?.userName.isNotEmpty == true) {
      return userInfo!.userName;
    }
    if (user is Map) {
      final name = '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'
          .trim();
      if (name.isNotEmpty) return name;
    }
    return fallback ?? '';
  }

  Future<void> _openMap(BuildContext context, MapMode mode) async {
    final order = context.read<OrderDetailsCubit>().state.order;
    if (order == null) return;

    final userInfo = context
            .read<OrderUserInfoCubit>()
            .state
            .userInfoMap[order.id] ??
        context
            .read<OrderUserInfoCubit>()
            .state
            .userInfoMap[_userId(order.user)];

    LatLng? storeLoc;
    LatLng? userLoc;

    final storeLat = double.tryParse(order.store?.lat ?? '');
    final storeLng = double.tryParse(order.store?.long ?? '');
    if (storeLat != null && storeLng != null) {
      storeLoc = LatLng(storeLat, storeLng);
    }
    storeLoc ??= await GeocodingHelper.geocodeAddress(
      [
        order.store?.name,
        order.store?.address,
      ].where((s) => s != null && s.isNotEmpty).join(', '),
    );

    final userInfoLat = double.tryParse(userInfo?.lat ?? '');
    final userInfoLng = double.tryParse(userInfo?.long ?? '');
    if (userInfoLat != null && userInfoLng != null) {
      userLoc = LatLng(userInfoLat, userInfoLng);
    } else {
      final userLat = double.tryParse(order.shippingAddress?.lat ?? '');
      final userLng = double.tryParse(order.shippingAddress?.long ?? '');
      if (userLat != null && userLng != null) {
        userLoc = LatLng(userLat, userLng);
      }
    }
    userLoc ??= await GeocodingHelper.geocodeAddress(
      [
        order.shippingAddress?.street ?? userInfo?.street,
        order.shippingAddress?.city ?? userInfo?.city,
      ].where((s) => s != null && s.isNotEmpty).join(', '),
    );

    if (!context.mounted) return;

    if (storeLoc == null && userLoc == null) {
      CustomSnackBar.error(
        context,
        'Could not find store or user location',
      );
      return;
    }
    final paymentLabel = switch (order.paymentType) {
      PaymentType.cash => 'Cash on Delivery',
      PaymentType.visa => 'Visa',
      PaymentType.wallet => 'Wallet',
      null => '-',
    };

    Navigator.pushNamed(
      context,
      Routes.driverMap,
      arguments: DriverMapParams(
        mode: mode,
        storeLat: storeLoc?.latitude,
        storeLng: storeLoc?.longitude,
        userLat: userLoc?.latitude,
        userLng: userLoc?.longitude,
        storeName: order.store?.name ?? '',
        storeAddress: order.store?.address ?? '',
        storePhone: order.store?.phoneNumber,
        userAddress: [
          order.shippingAddress?.street ?? userInfo?.street,
          order.shippingAddress?.city ?? userInfo?.city,
        ].where((s) => s != null && s.isNotEmpty).join(', '),
        userPhone: userInfo?.userPhone.isNotEmpty == true
            ? userInfo!.userPhone
            : (order.shippingAddress?.phone ?? userInfo?.phone),
        userImage: userInfo?.userImage,
        userName: userInfo?.userName,
        orderNumber: order.orderNumber,
        totalPrice: order.totalPrice,
        paymentType: paymentLabel,
      ),
    );
  }

  static String _paymentLabel(PaymentType? type) => switch (type) {
    PaymentType.cash => OrdersConstants.cashOnDelivery,
    PaymentType.visa => 'Visa',
    PaymentType.wallet => 'Wallet',
    null => '-',
  };
}

class _OrderItemsSection extends StatelessWidget {
  final List<OrderItemEntity> items;
  const _OrderItemsSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) => OrderItemRow(item: item)).toList(),
    );
  }
}

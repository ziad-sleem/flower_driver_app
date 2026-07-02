import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:tracking_app/config/routes/routes.dart';
import 'package:tracking_app/core/localization_constants/orders_constants.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/theme/font_size_manager.dart';
import 'package:tracking_app/core/utils/geocoding_helper.dart';
import 'package:tracking_app/core/widgets/custom_appbar.dart';
import 'package:tracking_app/core/widgets/custom_snack_bar.dart';
import 'package:tracking_app/features/driver_map/domain/entities/driver_map_params.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_Item_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_details_response_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/oreder_details/presentation/cubit/order_details_cubit.dart';
import 'package:tracking_app/features/oreder_details/presentation/cubit/order_details_intents.dart';
import 'package:tracking_app/features/oreder_details/presentation/cubit/order_step.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _handleBack(context);
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: OrdersConstants.orderDetails,
          onBack: () => _handleBack(context),
        ),
        body: BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
          listenWhen: (p, c) =>
              p.updateState.errorMessage != c.updateState.errorMessage &&
              c.updateState.errorMessage != null,
          listener: (context, state) => CustomSnackBar.error(
            context,
            state.updateState.errorMessage!.tr(),
          ),
          builder: (context, state) {
            final order = state.order;
            final step = state.step;
            if (order == null || step == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                _OrderProgressBar(step: step),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _OrderStatusBanner(order: order, step: step),
                        const SizedBox(height: 20),
                        _SectionTitle(OrdersConstants.pickupAddress),
                        const SizedBox(height: 10),
                        _AddressCard(
                          title: order.store?.name ?? '',
                          address: order.store?.address ?? '',
                          image: order.store?.image,
                          onNavigate: () {
                            _openMap(context, MapMode.toStore);
                          },
                        ),
                        const SizedBox(height: 20),
                        _SectionTitle(OrdersConstants.userAddress),
                        const SizedBox(height: 10),
                        _AddressCard(
                          title: _userName(
                            order.user,
                            order.shippingAddress?.city,
                          ),
                          address: order.shippingAddress?.street ?? '',
                          onNavigate: () {
                            _openMap(context, MapMode.toUser);
                          },
                        ),
                        const SizedBox(height: 20),
                        _SectionTitle(OrdersConstants.orderDetails),
                        const SizedBox(height: 10),
                        _OrderItemsSection(items: order.orderItems ?? const []),
                        const SizedBox(height: 8),
                        const Divider(),
                        _SummaryRow(
                          label: OrdersConstants.total,
                          value: 'EGP ${order.totalPrice?.toInt() ?? 0}',
                        ),
                        const Divider(),
                        _SummaryRow(
                          label: OrdersConstants.paymentMethod,
                          value: _paymentLabel(order.paymentType),
                        ),
                      ],
                    ),
                  ),
                ),
                const _OrderActionButton(),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleBack(BuildContext context) {
    final delivered =
        context.read<OrderDetailsCubit>().state.step == OrderStep.delivered;
    Navigator.pop(context, delivered);
  }

  static String _userName(Object? user, String? fallback) {
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

    LatLng? storeLoc;
    LatLng? userLoc;

    final storeParts = order.store?.latLong?.split(',');
    if (storeParts != null && storeParts.length == 2) {
      final lat = double.tryParse(storeParts[0].trim());
      final lng = double.tryParse(storeParts[1].trim());
      if (lat != null && lng != null) storeLoc = LatLng(lat, lng);
    }
    storeLoc ??= await GeocodingHelper.geocodeAddress(
      [
        order.store?.name,
        order.store?.address,
      ].where((s) => s != null && s.isNotEmpty).join(', '),
    );

    final userLat = double.tryParse(order.shippingAddress?.lat ?? '');
    final userLng = double.tryParse(order.shippingAddress?.long ?? '');
    if (userLat != null && userLng != null) {
      userLoc = LatLng(userLat, userLng);
    }
    userLoc ??= await GeocodingHelper.geocodeAddress(
      [
        order.shippingAddress?.street,
        order.shippingAddress?.city,
      ].where((s) => s != null && s.isNotEmpty).join(', '),
    );

    if (!context.mounted) return;

    if (storeLoc == null || userLoc == null) {
      CustomSnackBar.error(
        context,
        'Could not find location for ${storeLoc == null ? 'store' : 'user'}',
      );
      return;
    }
    Navigator.pushNamed(
      context,
      Routes.driverMap,
      arguments: DriverMapParams(
        mode: mode,
        storeLat: storeLoc.latitude,
        storeLng: storeLoc.longitude,
        userLat: userLoc.latitude,
        userLng: userLoc.longitude,
        storeName: order.store?.name ?? '',
        userAddress: [
          order.shippingAddress?.street,
          order.shippingAddress?.city,
        ].where((s) => s != null && s.isNotEmpty).join(', '),
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

class _OrderProgressBar extends StatelessWidget {
  final OrderStep step;
  const _OrderProgressBar({required this.step});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: List.generate(OrderStep.values.length, (index) {
          final active = index <= step.index;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 4,
              decoration: BoxDecoration(
                color: active ? AppColors.success : AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _OrderStatusBanner extends StatelessWidget {
  final OrderEntity order;
  final OrderStep step;
  const _OrderStatusBanner({required this.order, required this.step});

  @override
  Widget build(BuildContext context) {
    final createdAt = order.createdAt;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Status : ',
                style: getMediumStyle(
                  context: context,
                  color: AppColors.primary,
                  fontSize: FontSizeManager.s14,
                ),
              ),
              Text(
                step.statusLabel,
                style: getMediumStyle(
                  context: context,
                  color: AppColors.success,
                  fontSize: FontSizeManager.s14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Order ID : ${order.orderNumber ?? order.id ?? ''}',
            style: getBoldStyle(
              context: context,
              color: AppColors.textPrimary,
              fontSize: FontSizeManager.s14,
            ),
          ),
          if (createdAt != null) ...[
            const SizedBox(height: 6),
            Text(
              DateFormat('EEE, dd MMM yyyy, hh:mm a').format(createdAt),
              style: getRegularStyle(
                context: context,
                color: AppColors.textSecondary,
                fontSize: FontSizeManager.s12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: getBoldStyle(
        context: context,
        color: AppColors.textPrimary,
        fontSize: FontSizeManager.s16,
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final String title;
  final String address;
  final String? image;
  final VoidCallback? onNavigate;
  const _AddressCard({
    required this.title,
    required this.address,
    this.image,
    this.onNavigate,
  });

  static bool _isValidUrl(String url) =>
      url.startsWith('http://') || url.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.background,
            backgroundImage:
                (image != null && image!.isNotEmpty && _isValidUrl(image!))
                ? NetworkImage(image!)
                : null,
            child: (image == null || image!.isEmpty || !_isValidUrl(image!))
                ? const Icon(Icons.store, size: 18)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getMediumStyle(
                    context: context,
                    color: AppColors.textPrimary,
                    fontSize: FontSizeManager.s14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        address,
                        overflow: TextOverflow.ellipsis,
                        style: getRegularStyle(
                          context: context,
                          color: AppColors.textSecondary,
                          fontSize: FontSizeManager.s12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (onNavigate != null)
            GestureDetector(
              onTap: onNavigate,
              child: const Icon(Icons.map, color: AppColors.primary, size: 20),
            ),
          const SizedBox(width: 12),
          const Icon(Icons.call, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          const Icon(Icons.chat, color: AppColors.primary, size: 20),
        ],
      ),
    );
  }
}

class _OrderItemsSection extends StatelessWidget {
  final List<OrderItemEntity> items;
  const _OrderItemsSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) => _OrderItemRow(item: item)).toList(),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  final OrderItemEntity item;
  const _OrderItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final image = item.product?.imgCover;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 44,
              height: 44,
              child: (image != null && image.isNotEmpty)
                  ? Image.network(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.local_florist),
                    )
                  : const Icon(Icons.local_florist),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product?.title ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: getMediumStyle(
                    context: context,
                    color: AppColors.textPrimary,
                    fontSize: FontSizeManager.s14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'EGP ${item.price?.toInt() ?? 0}',
                  style: getRegularStyle(
                    context: context,
                    color: AppColors.textSecondary,
                    fontSize: FontSizeManager.s12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'X${item.quantity ?? 0}',
            style: getMediumStyle(
              context: context,
              color: AppColors.primary,
              fontSize: FontSizeManager.s14,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: getMediumStyle(
              context: context,
              color: AppColors.textPrimary,
              fontSize: FontSizeManager.s14,
            ),
          ),
          Text(
            value,
            style: getMediumStyle(
              context: context,
              color: AppColors.textSecondary,
              fontSize: FontSizeManager.s14,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderActionButton extends StatelessWidget {
  const _OrderActionButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
      buildWhen: (p, c) =>
          p.step != c.step ||
          p.updateState.isLoading != c.updateState.isLoading,
      builder: (context, state) {
        final step = state.step;
        if (step == null) return const SizedBox.shrink();
        final loading = state.updateState.isLoading;
        final disabled = step.isTerminal || loading;
        return SafeArea(
          minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: disabled
                  ? null
                  : () => context.read<OrderDetailsCubit>().doIntent(
                      const AdvanceOrderStepIntent(),
                    ),
              child: loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.surface,
                      ),
                    )
                  : Text(step.buttonLabel),
            ),
          ),
        );
      },
    );
  }
}

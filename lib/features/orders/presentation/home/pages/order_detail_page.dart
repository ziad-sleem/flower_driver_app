import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/utils/launch_utils.dart';
import 'package:tracking_app/core/widgets/custom_appbar.dart';

import 'package:tracking_app/features/orders/data/models/order_user_info_model.dart';
import 'package:tracking_app/features/orders/domain/entities/order_entity.dart';
import 'package:tracking_app/features/orders/domain/entities/order_details_response_entity.dart';

import '../cubit/order_user_info_cubit.dart';

import '../widgets/order_item_card.dart';
import '../widgets/section_title.dart';

class OrderDetailPage extends StatelessWidget {
  final OrderEntity order;

  const OrderDetailPage({super.key, required this.order});

  static String? _userId(Object? user) {
    if (user is Map) {
      final id = user['_id']?.toString();

      if (id != null && id.isNotEmpty) {
        return id;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = context.select<OrderUserInfoCubit, OrderUserInfoModel?>(
      (cubit) =>
          cubit.state.userInfoMap[order.id] ??
          cubit.state.userInfoMap[_userId(order.user)],
    );

    final userName = userInfo?.userName.isNotEmpty == true
        ? userInfo!.userName
        : 'Customer';

    final userAddress = order.shippingAddress?.street?.isNotEmpty == true
        ? order.shippingAddress!.street!
        : (userInfo?.street ?? '').isNotEmpty
        ? userInfo!.street
        : 'Customer address';

    final userCity = order.shippingAddress?.city?.isNotEmpty == true
        ? order.shippingAddress!.city
        : userInfo?.city;

    final hasPhone = userInfo?.userPhone.isNotEmpty == true;
    final hasCity = userCity?.isNotEmpty == true;

    final storeName = order.store?.name?.isNotEmpty == true
        ? order.store!.name!
        : 'Flowery Store';

    final storeAddress = order.store?.address?.isNotEmpty == true
        ? order.store!.address!
        : 'Store address';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Order #${order.orderNumber ?? order.id?.substring(0, 8) ?? ''}',
        subtitle: _statusLabel(order.state),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PICKUP ADDRESS
              SectionTitle('Pickup address'),

              const SizedBox(height: 8),

              _SectionCard(
                child: _OrderAddressTile(
                  title: storeName,
                  address: storeAddress,
                  image: order.store?.image,
                ),
              ),

              const SizedBox(height: 20),

              // DELIVERY ADDRESS
              SectionTitle('Delivery address'),

              const SizedBox(height: 8),

              _SectionCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    // Customer
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: _OrderAddressTile(
                        title: userName,
                        address: userAddress,
                        image: userInfo?.userImage,
                      ),
                    ),

                    if (hasPhone || hasCity) const _Divider(),

                    // Phone
                    if (hasPhone)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
                        child: Row(
                          children: [
                            _SmallInfoIcon(
                              icon: FontAwesomeIcons.info,
                              color: Colors.blue,
                              iconSize: 18,
                            ),

                            const SizedBox(width: 11),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Phone number',
                                    style: getRegularStyle(
                                      context: context,
                                      color: AppColors.textSecondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    userInfo!.userPhone,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: getMediumStyle(
                                      context: context,
                                      color: AppColors.textPrimary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 8),

                            _ContactButton(
                              color: const Color(0xFF1976D2),
                              icon: FontAwesomeIcons.phone,
                              iconSize: 15,
                              onTap: () {
                                makePhoneCall(userInfo.userPhone);
                              },
                            ),

                            const SizedBox(width: 6),

                            _ContactButton(
                              color: const Color(0xFF25D366),
                              icon: FontAwesomeIcons.whatsapp,
                              iconSize: 22,
                              onTap: () {
                                openWhatsApp(userInfo.userPhone);
                              },
                            ),
                          ],
                        ),
                      ),

                    if (hasPhone && hasCity) const _Divider(),

                    // City
                    if (hasCity)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
                        child: Row(
                          children: [
                            _SmallInfoIcon(
                              icon: FontAwesomeIcons.locationArrow,
                              color: AppColors.primary,
                              iconSize: 17,
                            ),
                            const SizedBox(width: 11),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Delivery city',
                                    style: getRegularStyle(
                                      context: context,
                                      color: AppColors.textSecondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${userCity ?? 'N/A'}📍',
                                    style: getMediumStyle(
                                      context: context,
                                      color: AppColors.textPrimary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // ORDER ITEMS
              SectionTitle('Order items (${order.orderItems?.length ?? 0})'),
              const SizedBox(height: 8),
              _SectionCard(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                child: order.orderItems != null && order.orderItems!.isNotEmpty
                    ? Column(
                        spacing: 5,
                        children: List.generate(order.orderItems!.length, (
                          index,
                        ) {
                          final item = order.orderItems![index];

                          return OrderItemCard(item: item);
                        }),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            'No items',
                            style: getRegularStyle(
                              context: context,
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
              ),

              const SizedBox(height: 10),

              // PAYMENT
              SectionTitle('Payment'),
              const SizedBox(height: 8),
              _SectionCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: [
                          _PaymentInfoRow(
                            icon: FontAwesomeIcons.creditCard,
                            label: 'Payment method',
                            value: _paymentLabel(order.paymentType),
                            iconSize: 18,
                          ),
                          const SizedBox(height: 13),
                          const _Divider(),
                          const SizedBox(height: 13),

                          _PaymentInfoRow(
                            icon: FontAwesomeIcons.receipt,
                            label: 'Payment status',
                            value: order.isPaid == true ? 'Paid' : 'Not paid',
                            valueColor: order.isPaid == true
                                ? Colors.green
                                : Colors.red,
                            iconSize: 18,
                          ),
                        ],
                      ),
                    ),

                    const _Divider(),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 13, 14, 14),
                      child: Row(
                        children: [
                          Text(
                            'Total',
                            style: getSemiBoldStyle(
                              context: context,
                              color: AppColors.textPrimary,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'EGP ${order.totalPrice?.toInt() ?? 0}',
                            style: getBoldStyle(
                              context: context,
                              color: AppColors.primary,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _paymentLabel(PaymentType? type) {
    switch (type) {
      case PaymentType.cash:
        return 'Cash';

      case PaymentType.visa:
        return 'Visa';

      case PaymentType.wallet:
        return 'Wallet';

      case null:
        return 'N/A';
    }
  }

  String _statusLabel(OrderState? state) {
    switch (state) {
      case OrderState.pending:
        return 'Pending';

      case OrderState.inProgress:
        return 'In Progress';

      case OrderState.completed:
        return 'Delivered';

      case OrderState.canceled:
        return 'Cancelled';

      case null:
        return '';
    }
  }
}

// ORDER ADDRESS TILE

class _OrderAddressTile extends StatelessWidget {
  final String title;
  final String address;
  final String? image;

  const _OrderAddressTile({
    required this.title,
    required this.address,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _AddressImage(image: image),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getSemiBoldStyle(
                  context: context,
                  color: AppColors.textPrimary,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                address,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: getRegularStyle(
                  context: context,
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ADDRESS IMAGE

class _AddressImage extends StatelessWidget {
  final String? image;

  const _AddressImage({this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.07),
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      child: image != null && image!.isNotEmpty
          ? Image.network(
              image!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return const Icon(
                  Icons.storefront_outlined,
                  color: AppColors.primary,
                  size: 21,
                );
              },
            )
          : const Icon(
              Icons.storefront_outlined,
              color: AppColors.primary,
              size: 21,
            ),
    );
  }
}

// SECTION CARD

class _SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _SectionCard({
    required this.child,
    this.padding = const EdgeInsets.all(14),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200, width: 0.8),
      ),
      child: child,
    );
  }
}

// DIVIDER

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, thickness: 0.7, color: Colors.grey.shade200);
  }
}

// SMALL INFO ICON

class _SmallInfoIcon extends StatelessWidget {
  final FaIconData icon;
  final Color color;
  final double iconSize;

  const _SmallInfoIcon({
    required this.icon,
    required this.color,
    this.iconSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: FaIcon(icon, color: color, size: iconSize),
      ),
    );
  }
}

// CONTACT BUTTON
class _ContactButton extends StatelessWidget {
  final FaIconData icon;
  final VoidCallback onTap;
  final Color color;
  final double iconSize;

  const _ContactButton({
    required this.icon,
    required this.onTap,
    required this.color,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.10),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: FaIcon(icon, color: color, size: iconSize),
          ),
        ),
      ),
    );
  }
}

// PAYMENT ROW
class _PaymentInfoRow extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final double iconSize;

  const _PaymentInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.iconSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SmallInfoIcon(
          icon: icon,
          color: AppColors.primary,
          iconSize: iconSize,
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            label,
            style: getRegularStyle(
              context: context,
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ),

        Text(
          value,
          style: getMediumStyle(
            context: context,
            color: valueColor ?? AppColors.textPrimary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

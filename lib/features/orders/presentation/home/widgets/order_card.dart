import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tracking_app/config/routes/page_transitions.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/utils/launch_utils.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';
import 'package:tracking_app/features/orders/data/models/order_user_info_model.dart';
import 'package:tracking_app/features/orders/domain/entities/order_entity.dart';
import '../cubit/order_user_info_cubit.dart';
import '../cubit/order_user_info_state.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_event.dart';
import '../pages/order_detail_page.dart';
import '../widgets/address_tile.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;

  const OrderCard({super.key, required this.order});

  static const String _defaultStoreImage =
      'https://images.unsplash.com/photo-1490750967868-88aa4486c946'
      '?auto=format&fit=crop&w=400&q=80';

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

    return BlocSelector<
      OrderUserInfoCubit,
      OrderUserInfoState,
      OrderUserInfoModel?
    >(
      selector: (state) => state.userInfoMap[order.id],
      builder: (context, userInfo) {
        final userName = userInfo?.userName.isNotEmpty == true
            ? userInfo!.userName
            : "Customer";

        final storeName = order.store?.name?.isNotEmpty == true
            ? order.store!.name!
            : "Flowery Store";

        final storeAddress = order.store?.address?.isNotEmpty == true
            ? order.store!.address!
            : "Store address";

        final storeImage = order.store?.image?.isNotEmpty == true
            ? order.store!.image
            : _defaultStoreImage;

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              PageTransitions.slide(
                MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: context.read<HomeCubit>()),
                    BlocProvider.value(
                      value: context.read<OrderUserInfoCubit>(),
                    ),
                  ],
                  child: OrderDetailPage(order: order),
                ),
              ),
            ),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Flower Order",
                    style: getBoldStyle(
                      context: context,
                      color: AppColors.textPrimary,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Pickup Address",
                    style: getMediumStyle(
                      context: context,
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 8),

                  AddressTile(
                    title: storeName,
                    address: storeAddress,
                    image: storeImage,
                  ),

                  const SizedBox(height: 14),

                  Text(
                    "User Address",
                    style: getMediumStyle(
                      context: context,
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 8),

                  AddressTile(
                    title: userName,
                    address: order.shippingAddress?.street?.isNotEmpty == true
                        ? order.shippingAddress!.street!
                        : "Customer address",
                    image: userInfo?.userImage,
                  ),

                  if (userInfo?.userPhone.isNotEmpty == true) ...[
                    const SizedBox(height: 7),

                    Row(
                      children: [
                        Text(
                          "Phone: ",
                          style: getMediumStyle(
                            context: context,
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          userInfo!.userPhone,
                          style: getRegularStyle(
                            context: context,
                            color: AppColors.primaryDark,
                            fontSize: 12,
                          ),
                        ),

                        Spacer(),

                        _ContactButton(
                          color: const Color(0xFF1976D2),
                          icon: FaIcon(FontAwesomeIcons.phone, size: 15),
                          onTap: () {
                            makePhoneCall(userInfo.userPhone);
                          },
                        ),

                        const SizedBox(width: 8),

                        _ContactButton(
                          color: const Color(0xFF25D366),
                          icon: const FaIcon(
                            FontAwesomeIcons.whatsapp,
                            size: 22,
                          ),
                          onTap: () {
                            openWhatsApp(userInfo.userPhone);
                          },
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Text(
                        "EGP ${order.totalPrice?.toInt() ?? 0}",
                        style: getBoldStyle(
                          context: context,
                          color: AppColors.textPrimary,
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
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
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
          ),
        );
      },
    );
  }
}

class _ContactButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onTap;
  final Color color;

  const _ContactButton({
    required this.icon,
    required this.onTap,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: IconTheme(
            data: IconThemeData(color: color, size: 16),
            child: icon,
          ),
        ),
      ),
    );
  }
}

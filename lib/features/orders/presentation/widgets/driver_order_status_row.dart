import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tracking_app/core/localization_constants/status_constants.dart';
import 'package:tracking_app/core/resources/app_svgs.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_details_response_entity.dart';

class DriverOrderStatusRow extends StatelessWidget {
  final OrderState? state;
  final String orderNumber;

  const DriverOrderStatusRow({
    super.key,
    required this.state,
    required this.orderNumber,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = state == OrderState.completed;
    final color = isCompleted ? AppColors.success : AppColors.error;
    final label = isCompleted
        ? StatusConstants.completed
        : StatusConstants.cancelled;

    return Row(
      children: [
        SvgPicture.asset(
          isCompleted ? AppSvgs.checkCircle : AppSvgs.cancel,
          width: 18,
          height: 18,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        const AppSizedBox(width: 6),
        Text(
          label,
          style: getSemiBoldStyle(context: context, color: color),
        ),
        const Spacer(),
        Text(
          orderNumber,
          style: getSemiBoldStyle(
            context: context,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

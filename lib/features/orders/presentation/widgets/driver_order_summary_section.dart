import 'package:flutter/material.dart';
import 'package:tracking_app/core/localization_constants/orders_constants.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_details_response_entity.dart';

class DriverOrderSummarySection extends StatelessWidget {
  final double? totalPrice;
  final PaymentType? paymentType;

  const DriverOrderSummarySection({
    super.key,
    required this.totalPrice,
    required this.paymentType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SummaryRow(
          label: OrdersConstants.total,
          value: 'Egp ${totalPrice?.toInt() ?? 0}',
        ),
        const AppSizedBox(height: 10),
        _SummaryRow(
          label: OrdersConstants.paymentMethod,
          value: _paymentLabel(paymentType),
        ),
      ],
    );
  }

  String _paymentLabel(PaymentType? type) => switch (type) {
    PaymentType.cash => OrdersConstants.cashOnDelivery,
    PaymentType.visa => 'Visa',
    PaymentType.wallet => 'Wallet',
    null => '-',
  };
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: getSemiBoldStyle(context: context, color: AppColors.textPrimary),
          ),
          Text(
            value,
            style: getRegularStyle(
              context: context,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

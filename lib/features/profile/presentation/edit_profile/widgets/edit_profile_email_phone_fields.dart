import 'package:flutter/material.dart';
import 'package:tracking_app/core/localization_constants/auth_constants.dart';
import 'package:tracking_app/core/localization_constants/delivery_application_constants.dart';
import 'package:tracking_app/core/utils/app_validator.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';
import 'package:tracking_app/core/widgets/custom_text_field.dart';

class EditProfileEmailPhoneFields extends StatelessWidget {
  const EditProfileEmailPhoneFields({
    super.key,
    required this.emailController,
    required this.phoneController,
    required this.onEmailChanged,
    required this.onPhoneChanged,
  });

  final TextEditingController emailController;
  final TextEditingController phoneController;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPhoneChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: emailController,
          labelText: AuthConstants.email,
          keyboardType: TextInputType.emailAddress,
          validator: AppValidator.email,
          onChanged: onEmailChanged,
          textInputAction: TextInputAction.next,
        ),
        AppSizedBox(height: 16),
        CustomTextField(
          controller: phoneController,
          labelText: DeliveryApplicationConstants.phoneNumber,
          keyboardType: TextInputType.phone,
          validator: AppValidator.phone,
          onChanged: onPhoneChanged,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}

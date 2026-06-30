import 'package:flutter/material.dart';
import 'package:tracking_app/core/localization_constants/delivery_application_constants.dart';
import 'package:tracking_app/core/utils/app_validator.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';
import 'package:tracking_app/core/widgets/custom_text_field.dart';

class EditProfileNameRow extends StatelessWidget {
  const EditProfileNameRow({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.onFirstNameChanged,
    required this.onLastNameChanged,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final ValueChanged<String> onFirstNameChanged;
  final ValueChanged<String> onLastNameChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: CustomTextField(
            controller: firstNameController,
            labelText: DeliveryApplicationConstants.firstLegalName,
            keyboardType: TextInputType.name,
            validator: AppValidator.name,
            onChanged: onFirstNameChanged,
            textInputAction: TextInputAction.next,
          ),
        ),
        AppSizedBox(width: 12),
        Expanded(
          child: CustomTextField(
            controller: lastNameController,
            labelText: DeliveryApplicationConstants.secondLegalName,
            keyboardType: TextInputType.name,
            validator: AppValidator.name,
            onChanged: onLastNameChanged,
            textInputAction: TextInputAction.next,
          ),
        ),
      ],
    );
  }
}

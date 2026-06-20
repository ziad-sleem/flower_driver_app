import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/localization_constants/auth_constants.dart';
import 'package:tracking_app/core/localization_constants/delivery_application_constants.dart';
import 'package:tracking_app/core/utils/app_validator.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';
import 'package:tracking_app/core/widgets/custom_text_field.dart';
import 'package:tracking_app/features/auth/data/models/country_model.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_cubit.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_event.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_state.dart';
import 'package:tracking_app/features/auth/presentation/apply/widgets/apply_form_controller.dart';
import 'package:tracking_app/features/auth/presentation/apply/widgets/country_dropdown.dart';
import 'package:tracking_app/features/auth/presentation/apply/widgets/gender_selector.dart';
import 'package:tracking_app/features/auth/presentation/apply/widgets/submit_button.dart';
import 'package:tracking_app/features/auth/presentation/apply/widgets/upload_image_field.dart';
import 'package:tracking_app/features/auth/presentation/apply/widgets/vehicle_dropdown.dart';

class ApplyForm extends StatelessWidget {
  final ApplyFormController controller;
  final ApplyState state;

  const ApplyForm({super.key, required this.controller, required this.state});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          CountryDropdown(
            countries: state.countries,
            selectedCountry: state.selectedCountry,
            onChanged: (CountryModel country) {
              context.read<ApplyCubit>().onEvent(SelectCountryEvent(country));
            },
          ),
          AppSizedBox(height: 16),
          CustomTextField(
            controller: controller.firstNameController,
            labelText: DeliveryApplicationConstants.firstLegalName,
            hintText: DeliveryApplicationConstants.enterFirstLegalName,
            validator: AppValidator.name,
            textInputAction: TextInputAction.next,
          ),
          AppSizedBox(height: 16),
          CustomTextField(
            controller: controller.secondNameController,
            labelText: DeliveryApplicationConstants.secondLegalName,
            hintText: DeliveryApplicationConstants.enterSecondLegalName,
            validator: AppValidator.name,
            textInputAction: TextInputAction.next,
          ),
          AppSizedBox(height: 16),

          VehicleDropdown(
            vehicles: state.vehicles,
            selectedVehicle: state.selectedVehicle,
            onChanged: (vehicle) {
              context.read<ApplyCubit>().onEvent(SelectVehicleEvent(vehicle));
            },
          ),

          AppSizedBox(height: 16),
          CustomTextField(
            controller: controller.vehicleNumberController,
            labelText: DeliveryApplicationConstants.vehicleNumber,
            hintText: DeliveryApplicationConstants.enterVehicleNumber,
            textInputAction: TextInputAction.next,
            validator: AppValidator.vehicleNumber,
          ),

          AppSizedBox(height: 16),

          UploadImageField(
            label: DeliveryApplicationConstants.vehicleLicense,
            hint: DeliveryApplicationConstants.uploadLicensePhoto,
            imagePath: state.vehicleLicensePath,
            onTap: () {
              context.read<ApplyCubit>().onEvent(
                const PickVehicleLicenseEvent(),
              );
            },
          ),

          AppSizedBox(height: 16),

          CustomTextField(
            controller: controller.emailController,
            labelText: AuthConstants.email,
            hintText: AuthConstants.enterYourEmail,
            keyboardType: TextInputType.emailAddress,
            validator: AppValidator.email,
            textInputAction: TextInputAction.next,
          ),

          AppSizedBox(height: 16),

          CustomTextField(
            controller: controller.phoneController,
            labelText: DeliveryApplicationConstants.phoneNumber,
            hintText: DeliveryApplicationConstants.enterPhoneNumber,
            keyboardType: TextInputType.phone,
            validator: AppValidator.phone,
            textInputAction: TextInputAction.next,
          ),

          AppSizedBox(height: 16),
          CustomTextField(
            controller: controller.idNumberController,
            labelText: DeliveryApplicationConstants.idNumber,
            hintText: DeliveryApplicationConstants.enterNationalId,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            validator: AppValidator.nationalId,
          ),

          AppSizedBox(height: 16),

          UploadImageField(
            label: DeliveryApplicationConstants.idImage,
            hint: DeliveryApplicationConstants.uploadIdImage,
            imagePath: state.nidImagePath,
            onTap: () {
              context.read<ApplyCubit>().onEvent(const PickNationalIdEvent());
            },
          ),

          AppSizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: controller.passwordController,
                  labelText: AuthConstants.password,
                  hintText: AuthConstants.enterYourPassword,
                  isPassword: true,
                  validator: AppValidator.password,
                  textInputAction: TextInputAction.next,
                ),
              ),

              AppSizedBox(width: 12),

              Expanded(
                child: CustomTextField(
                  controller: controller.confirmPasswordController,
                  labelText: AuthConstants.confirmPassword,
                  hintText: AuthConstants.enterYourPassword,
                  textInputAction: TextInputAction.done,
                  isPassword: true,
                  validator: (value) {
                    return AppValidator.confirmPassword(
                      value,
                      controller.passwordController.text,
                    );
                  },
                ),
              ),
            ],
          ),

          AppSizedBox(height: 24),

          GenderSelector(
            selectedGender: state.selectedGender,
            onChanged: (gender) {
              context.read<ApplyCubit>().onEvent(SelectGenderEvent(gender));
            },
          ),

          AppSizedBox(height: 32),

          SubmitButton(controller: controller, state: state),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/localization_constants/general_constants.dart';
import 'package:tracking_app/core/widgets/button_loading_widget.dart';
import 'package:tracking_app/core/widgets/primary_button.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_now_params.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_cubit.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_event.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_state.dart';
import 'package:tracking_app/features/auth/presentation/apply/widgets/apply_form_controller.dart';

class SubmitButton extends StatelessWidget {
  final ApplyFormController controller;
  final ApplyState state;
  const SubmitButton({
    super.key,
    required this.controller,
    required this.state,
  });
  void _submit(BuildContext context) {
    if (!controller.formKey.currentState!.validate()) {
      return;
    }

    context.read<ApplyCubit>().onEvent(
      ApplyNowEvent(
        ApplyNowParams(
          country: state.selectedCountry!.name,
          firstName: controller.firstNameController.text.trim(),
          lastName: controller.secondNameController.text.trim(),
          vehicleType: state.selectedVehicle!.id,
          vehicleNumber: controller.vehicleNumberController.text.trim(),
          nid: controller.idNumberController.text.trim(),
          email: controller.emailController.text.trim(),
          password: controller.passwordController.text.trim(),
          rePassword: controller.confirmPasswordController.text.trim(),
          gender: state.selectedGender!,
          phone: controller.phoneController.text.trim(),
          vehicleLicensePath: state.vehicleLicensePath!,
          nidImgPath: state.nidImagePath!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: state.isApplying
          ? const ButtonLoadingWidget()
          : PrimaryButton(
              text: GeneralConstants.continue_,
              onTap: !state.isFormReady ? null : () => _submit(context),
            ),
    );
  }
}

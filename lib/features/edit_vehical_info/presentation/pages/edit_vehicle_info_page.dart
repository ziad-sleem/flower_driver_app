import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/localization_constants/delivery_application_constants.dart';
import 'package:tracking_app/core/localization_constants/general_constants.dart';
import 'package:tracking_app/core/localization_constants/profile_constants.dart';
import 'package:tracking_app/core/utils/app_validator.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';
import 'package:tracking_app/core/widgets/button_loading_widget.dart';
import 'package:tracking_app/core/widgets/custom_appbar.dart';
import 'package:tracking_app/core/widgets/custom_snack_bar.dart';
import 'package:tracking_app/core/widgets/custom_text_field.dart';
import 'package:tracking_app/core/widgets/primary_button.dart';
import 'package:tracking_app/features/auth/presentation/apply/widgets/upload_image_field.dart';
import 'package:tracking_app/features/edit_vehical_info/presentation/cubit/edit_vehicle_info_cubit.dart';
import 'package:tracking_app/features/edit_vehical_info/presentation/widgets/vehicle_type_dropdown.dart';

class EditVehicleInfoPage extends StatefulWidget {
  const EditVehicleInfoPage({super.key});

  @override
  State<EditVehicleInfoPage> createState() => _EditVehicleInfoPageState();
}

class _EditVehicleInfoPageState extends State<EditVehicleInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EditVehicleInfoCubit>().loadVehicles();
    });
  }

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditVehicleInfoCubit, EditVehicleInfoState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          CustomSnackBar.error(context, state.errorMessage!);
        }
        if (state.successMessage != null) {
          debugPrint('Update Success: ${state.successMessage}');
          CustomSnackBar.success(context, state.successMessage!);
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final cubit = context.read<EditVehicleInfoCubit>();

        return Scaffold(
          appBar: CustomAppBar(
            title: ProfileConstants.vehicleInfo,
            buttonEnable: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    VehicleTypeDropdown(
                      vehicles: state.vehicles,
                      selectedVehicle: state.selectedVehicle,
                      onChanged: cubit.selectVehicle,
                    ),
                    const AppSizedBox(height: 16),
                    CustomTextField(
                      controller: _vehicleNumberController,
                      labelText: DeliveryApplicationConstants.vehicleNumber,
                      hintText:
                          DeliveryApplicationConstants.enterVehicleNumber,
                      validator: AppValidator.vehicleNumber,
                      textInputAction: TextInputAction.done,
                    ),
                    const AppSizedBox(height: 16),
                    UploadImageField(
                      label: DeliveryApplicationConstants.vehicleLicense,
                      hint: DeliveryApplicationConstants.uploadLicensePhoto,
                      imagePath: state.vehicleLicensePath,
                      onTap: cubit.pickLicenseImage,
                    ),
                    const AppSizedBox(height: 32),
                    state.isUpdating
                        ? const ButtonLoadingWidget()
                        : PrimaryButton(
                            text: GeneralConstants.update,
                            onTap: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                cubit.updateVehicle(
                                  vehicleNumber:
                                      _vehicleNumberController.text.trim(),
                                );
                              }
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

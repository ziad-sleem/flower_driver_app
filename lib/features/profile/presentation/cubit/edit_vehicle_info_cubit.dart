import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/service/image_picker_service.dart';
import 'package:tracking_app/features/profile/domain/entities/all_vehicles_response_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/edit_vehicle_params.dart';
import 'package:tracking_app/features/profile/domain/entities/update_vehicle_response_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_entity.dart';
import 'package:tracking_app/features/profile/domain/use_cases/get_vehicles_use_case.dart';
import 'package:tracking_app/features/profile/domain/use_cases/update_vehicle_use_case.dart';

part 'edit_vehicle_info_state.dart';

@injectable
class EditVehicleInfoCubit extends Cubit<EditVehicleInfoState> {
  final GetVehiclesUseCase getVehiclesUseCase;
  final UpdateVehicleUseCase updateVehicleUseCase;
  final ImagePickerService imagePickerService;

  EditVehicleInfoCubit(
    this.getVehiclesUseCase,
    this.updateVehicleUseCase,
    this.imagePickerService,
  ) : super(const EditVehicleInfoState());

  Future<void> loadVehicles() async {
    emit(state.copyWith(isLoadingVehicles: true, errorMessage: null));

    final response = await getVehiclesUseCase();

    switch (response) {
      case SuccessBaseResponse<AllVehiclesResponseEntity>():
        emit(
          state.copyWith(
            isLoadingVehicles: false,
            vehicles: response.data.vehicles ?? [],
          ),
        );
      case ErrorBaseResponse<AllVehiclesResponseEntity>():
        emit(
          state.copyWith(
            isLoadingVehicles: false,
            errorMessage: response.failure.message,
          ),
        );
    }
  }

  void selectVehicle(VehicleEntity vehicle) {
    emit(state.copyWith(selectedVehicle: vehicle));
  }

  Future<void> pickLicenseImage() async {
    final path = await imagePickerService.pickImage();
    if (path == null) return;
    emit(state.copyWith(vehicleLicensePath: path));
  }

  Future<void> updateVehicle({required String vehicleNumber}) async {
    if (state.selectedVehicle == null) return;

    emit(
      state.copyWith(
        isUpdating: true,
        errorMessage: null,
        successMessage: null,
      ),
    );

    final response = await updateVehicleUseCase(
      EditVehicleParams(
        vehicleType: state.selectedVehicle!.id ?? '',
        vehicleNumber: vehicleNumber,
        vehicleLicensePath: state.vehicleLicensePath,
      ),
    );

    switch (response) {
      case SuccessBaseResponse<UpdateVehicleResponseEntity>():
        emit(
          state.copyWith(
            isUpdating: false,
            successMessage:
                response.data.message ?? 'Updated successfully',
          ),
        );
      case ErrorBaseResponse<UpdateVehicleResponseEntity>():
        emit(
          state.copyWith(
            isUpdating: false,
            errorMessage: response.failure.message,
          ),
        );
    }
  }
}

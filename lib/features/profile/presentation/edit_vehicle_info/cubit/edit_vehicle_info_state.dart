part of 'edit_vehicle_info_cubit.dart';

class EditVehicleInfoState extends Equatable {
  final List<VehicleEntity> vehicles;
  final VehicleEntity? selectedVehicle;
  final String? vehicleLicensePath;
  final bool isLoadingVehicles;
  final bool isUpdating;
  final String? errorMessage;
  final String? successMessage;

  const EditVehicleInfoState({
    this.vehicles = const [],
    this.selectedVehicle,
    this.vehicleLicensePath,
    this.isLoadingVehicles = false,
    this.isUpdating = false,
    this.errorMessage,
    this.successMessage,
  });

  EditVehicleInfoState copyWith({
    List<VehicleEntity>? vehicles,
    VehicleEntity? selectedVehicle,
    String? vehicleLicensePath,
    bool? isLoadingVehicles,
    bool? isUpdating,
    String? errorMessage,
    String? successMessage,
  }) {
    return EditVehicleInfoState(
      vehicles: vehicles ?? this.vehicles,
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
      vehicleLicensePath: vehicleLicensePath ?? this.vehicleLicensePath,
      isLoadingVehicles: isLoadingVehicles ?? this.isLoadingVehicles,
      isUpdating: isUpdating ?? this.isUpdating,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
    vehicles,
    selectedVehicle,
    vehicleLicensePath,
    isLoadingVehicles,
    isUpdating,
    errorMessage,
    successMessage,
  ];
}

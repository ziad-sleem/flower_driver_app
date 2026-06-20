import 'package:equatable/equatable.dart';
import 'package:tracking_app/features/auth/data/models/country_model.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_now_response_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_entity.dart';

class ApplyState extends Equatable {
  final List<CountryModel> countries;
  final List<VehicleEntity> vehicles;
  final VehicleEntity? selectedVehicle;
  final CountryModel? selectedCountry;
  final String? selectedGender;
  final String? vehicleLicensePath;
  final String? nidImagePath;
  final ApplyNowResponseEntity? applyResponse;
  final String? errorMessage;
  final String? successMessage;
  final bool isApplying;

  const ApplyState({
    this.countries = const [],
    this.vehicles = const [],
    this.selectedVehicle,
    this.selectedCountry,
    this.selectedGender,
    this.vehicleLicensePath,
    this.nidImagePath,
    this.applyResponse,
    this.errorMessage,
    this.successMessage,
    this.isApplying = false,
  });

  bool get isFormReady =>
      selectedCountry != null &&
      selectedVehicle != null &&
      selectedGender != null &&
      vehicleLicensePath != null &&
      nidImagePath != null;

  ApplyState copyWith({
    List<CountryModel>? countries,
    List<VehicleEntity>? vehicles,
    VehicleEntity? selectedVehicle,
    CountryModel? selectedCountry,
    String? selectedGender,
    String? vehicleLicensePath,
    String? nidImagePath,
    ApplyNowResponseEntity? applyResponse,
    String? errorMessage,
    String? successMessage,
    bool? isApplying,
  }) {
    return ApplyState(
      countries: countries ?? this.countries,
      vehicles: vehicles ?? this.vehicles,
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedGender: selectedGender ?? this.selectedGender,
      vehicleLicensePath: vehicleLicensePath ?? this.vehicleLicensePath,
      nidImagePath: nidImagePath ?? this.nidImagePath,
      applyResponse: applyResponse ?? this.applyResponse,
      errorMessage: errorMessage,
      successMessage: successMessage,
      isApplying: isApplying ?? this.isApplying,
    );
  }

  @override
  List<Object?> get props => [
    countries,
    vehicles,
    selectedVehicle,
    selectedCountry,
    selectedGender,
    vehicleLicensePath,
    nidImagePath,
    applyResponse,
    errorMessage,
    successMessage,
    isApplying,
  ];
}

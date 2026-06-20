import 'package:tracking_app/features/auth/data/models/country_model.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_now_params.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_entity.dart';

sealed class ApplyEvent {
  const ApplyEvent();
}

class LoadCountriesEvent extends ApplyEvent {
  const LoadCountriesEvent();
}

class GetVehiclesEvent extends ApplyEvent {
  const GetVehiclesEvent();
}

class SelectCountryEvent extends ApplyEvent {
  final CountryModel country;

  const SelectCountryEvent(this.country);
}

class SelectVehicleEvent extends ApplyEvent {
  final VehicleEntity vehicle;

  const SelectVehicleEvent(this.vehicle);
}

class SelectGenderEvent extends ApplyEvent {
  final String gender;

  const SelectGenderEvent(this.gender);
}

class PickVehicleLicenseEvent extends ApplyEvent {
  const PickVehicleLicenseEvent();
}

class PickNationalIdEvent extends ApplyEvent {
  const PickNationalIdEvent();
}

class ApplyNowEvent extends ApplyEvent {
  final ApplyNowParams params;

  const ApplyNowEvent(this.params);
}

class ResetApplyEvent extends ApplyEvent {
  const ResetApplyEvent();
}

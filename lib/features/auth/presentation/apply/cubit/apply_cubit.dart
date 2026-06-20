import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/service/image_picker_service.dart';
import 'package:tracking_app/core/service/load_json_countries.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_now_response_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_response_entity.dart';
import 'package:tracking_app/features/auth/domain/use_cases/apply_now_use_case.dart';
import 'package:tracking_app/features/auth/domain/use_cases/get_vehicles_use_case.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_event.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@injectable
class ApplyCubit extends Cubit<ApplyState> {
  final GetVehiclesUseCase getVehiclesUseCase;
  final ApplyNowUseCase applyNowUseCase;
  final CountryService countryService;
  final ImagePickerService imagePickerService;

  ApplyCubit(
    this.getVehiclesUseCase,
    this.applyNowUseCase,
    this.countryService,
    this.imagePickerService,
  ) : super(const ApplyState());

  Future<void> onEvent(ApplyEvent event) async {
    switch (event) {
      case LoadCountriesEvent():
        await _onLoadCountries();

      case GetVehiclesEvent():
        await _onGetVehicles();

      case SelectCountryEvent():
        _onSelectCountry(event);

      case SelectVehicleEvent():
        _onSelectVehicle(event);

      case SelectGenderEvent():
        _onSelectGender(event);

      case PickVehicleLicenseEvent():
        await _onPickVehicleLicense();

      case PickNationalIdEvent():
        await _onPickNationalId();

      case ApplyNowEvent():
        await _onApplyNow(event);

      case ResetApplyEvent():
        emit(const ApplyState());
    }
  }

  Future<void> _onLoadCountries() async {
    final countries = await countryService.getCountries();

    emit(state.copyWith(countries: countries));
  }

  void _onSelectCountry(SelectCountryEvent event) {
    emit(state.copyWith(selectedCountry: event.country));
  }

  Future<void> _onGetVehicles() async {
    final response = await getVehiclesUseCase();

    switch (response) {
      case SuccessBaseResponse<VehicleResponseEntity>():
        emit(
          state.copyWith(vehicles: response.data.vehicles, errorMessage: null),
        );

      case ErrorBaseResponse<VehicleResponseEntity>():
        emit(state.copyWith(errorMessage: response.failure.message));
    }
  }

  void _onSelectVehicle(SelectVehicleEvent event) {
    emit(state.copyWith(selectedVehicle: event.vehicle));
  }

  void _onSelectGender(SelectGenderEvent event) {
    emit(state.copyWith(selectedGender: event.gender));
  }

  Future<void> _onPickVehicleLicense() async {
    final path = await imagePickerService.pickImage();

    if (path == null) return;

    emit(state.copyWith(vehicleLicensePath: path));
  }

  Future<void> _onPickNationalId() async {
    final path = await imagePickerService.pickImage();

    if (path == null) return;

    emit(state.copyWith(nidImagePath: path));
  }

  Future<void> _onApplyNow(ApplyNowEvent event) async {
    emit(
      state.copyWith(
        isApplying: true,
        errorMessage: null,
        successMessage: null,
      ),
    );

    final response = await applyNowUseCase(event.params);

    switch (response) {
      case SuccessBaseResponse<ApplyNowResponseEntity>():
        emit(
          state.copyWith(
            isApplying: false,
            applyResponse: response.data,
            successMessage: response.data.message,
            errorMessage: null,
          ),
        );

      case ErrorBaseResponse<ApplyNowResponseEntity>():
        emit(
          state.copyWith(
            isApplying: false,
            successMessage: null,
            errorMessage: response.failure.message,
          ),
        );
    }
  }
}

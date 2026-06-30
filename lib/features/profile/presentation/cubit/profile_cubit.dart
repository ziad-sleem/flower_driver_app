import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/core/error/error_handler.dart';
import 'package:tracking_app/core/storage/secure_storage_service.dart';
import 'package:tracking_app/features/profile/domain/entities/all_vehicles_response_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/profile_data_response_entity.dart';
import 'package:tracking_app/features/profile/domain/use_cases/get_driver_data_use_case.dart';
import 'package:tracking_app/features/profile/domain/use_cases/get_vehicles_use_case.dart';
import 'package:tracking_app/features/profile/presentation/cubit/profile_event.dart';

part 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final GetDriverDataUseCase _getDriverDataUseCase;
  final GetVehiclesUseCase _getVehiclesUseCase;

  ProfileCubit(this._getDriverDataUseCase, this._getVehiclesUseCase)
      : super(const ProfileState());

  void doEvent(ProfileEvent event) {
    switch (event) {
      case GetDriverDataEvent():
        _getDriverData();
        break;
      case GetVehiclesEvent():
        _getVehicles();
        break;
      case ToggleLanguageEvent():
        _toggleLanguage();
        break;
      case LogoutEvent():
        _logout();
        break;
    }
  }

  void _toggleLanguage() {
    final current = state.targetLocale ?? const Locale('en');
    final newLocale =
        current.languageCode == 'en' ? const Locale('ar') : const Locale('en');
    emit(state.copyWith(targetLocale: newLocale));
  }

  Future<void> _logout() async {
    await SecureStorageService.deleteToken();
    emit(state.copyWith(loggedOut: true));
  }

  Future<void> _getDriverData() async {
    try {
      emit(state.copyWith(
        driverDataState: const BaseState(isLoading: true),
      ));

      final result = await _getDriverDataUseCase.call();

      if (result is SuccessBaseResponse<ProfileDataResponseEntity>) {
        emit(
          state.copyWith(
            driverDataState: BaseState(
              data: result.data,
              isLoading: false,
            ),
          ),
        );
      } else if (result is ErrorBaseResponse<ProfileDataResponseEntity>) {
        emit(
          state.copyWith(
            driverDataState: BaseState(
              isLoading: false,
              errorMessage: result.failure.message,
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          driverDataState: BaseState(
            isLoading: false,
            errorMessage: ErrorHandler.handle(e).message,
          ),
        ),
      );
    }
  }

  Future<void> _getVehicles() async {
    try {
      emit(state.copyWith(
        vehiclesState: const BaseState(isLoading: true),
      ));

      final result = await _getVehiclesUseCase.call();

      if (result is SuccessBaseResponse<AllVehiclesResponseEntity>) {
        emit(
          state.copyWith(
            vehiclesState: BaseState(
              data: result.data,
              isLoading: false,
            ),
          ),
        );
      } else if (result is ErrorBaseResponse<AllVehiclesResponseEntity>) {
        emit(
          state.copyWith(
            vehiclesState: BaseState(
              isLoading: false,
              errorMessage: result.failure.message,
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          vehiclesState: BaseState(
            isLoading: false,
            errorMessage: ErrorHandler.handle(e).message,
          ),
        ),
      );
    }
  }
}

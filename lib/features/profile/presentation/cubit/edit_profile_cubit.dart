import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/profile/data/models/edit_profile_request.dart';
import 'package:tracking_app/features/profile/domain/use_cases/edit_profile_use_case.dart';
import 'package:tracking_app/features/profile/domain/use_cases/upload_photo_use_case.dart';
import 'package:tracking_app/features/profile/presentation/cubit/edit_profile_event.dart';
import 'package:tracking_app/features/profile/presentation/cubit/edit_profile_state.dart';
import 'package:tracking_app/features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/profile_data_response_entity.dart';
import 'package:tracking_app/features/profile/domain/repositories/profile_repo.dart';

@injectable
class EditProfileCubit extends Cubit<EditProfileState> {
  final EditProfileUseCase _editProfileUseCase;
  final UploadPhotoUseCase _uploadPhotoUseCase;
  final ProfileRepo _profileRepo;

  String _initialFirst = '';
  String _initialLast = '';
  String _initialEmail = '';
  String _initialPhone = '';

  EditProfileCubit(
    this._editProfileUseCase,
    this._uploadPhotoUseCase,
    this._profileRepo,
  ) : super(const EditProfileState());

  bool get hasChanges =>
      state.firstName.trim() != _initialFirst ||
      state.lastName.trim() != _initialLast ||
      state.email.trim() != _initialEmail ||
      state.phone.trim() != _initialPhone ||
      state.photo != null;

  Future<void> doEvent(EditProfileEvent event) async {
    switch (event) {
      case LoadProfileEvent():
        await _loadProfile();
      case EditProfileFirstNameChanged(:final value):
        emit(state.copyWith(firstName: value));
      case EditProfileLastNameChanged(:final value):
        emit(state.copyWith(lastName: value));
      case EditProfileEmailChanged(:final value):
        emit(state.copyWith(email: value));
      case EditProfilePhoneChanged(:final value):
        emit(state.copyWith(phone: value));
      case EditProfilePhotoChanged(:final file):
        await _uploadPhoto(file);
      case EditProfileSubmitted():
        await _submit();
    }
  }

  Future<void> _loadProfile() async {
    emit(state.copyWith(isLoadingProfile: true, errorMessage: null));

    final result = await _profileRepo.getProfileData();

    switch (result) {
      case SuccessBaseResponse<ProfileDataResponseEntity>():
        final driver = result.data.driver;
        _setInitialValues(driver);
        emit(
          state.copyWith(
            isLoadingProfile: false,
            driver: driver,
            firstName: driver?.firstName ?? '',
            lastName: driver?.lastName ?? '',
            email: driver?.email ?? '',
            phone: driver?.phone ?? '',
            profilePhotoUrl: driver?.photo,
            errorMessage: null,
          ),
        );
      case ErrorBaseResponse<ProfileDataResponseEntity>():
        emit(
          state.copyWith(
            isLoadingProfile: false,
            errorMessage: result.failure.message,
          ),
        );
    }
  }

  void _setInitialValues(ProfileDriverEntity? driver) {
    _initialFirst = (driver?.firstName ?? '').trim();
    _initialLast = (driver?.lastName ?? '').trim();
    _initialEmail = (driver?.email ?? '').trim();
    _initialPhone = (driver?.phone ?? '').trim();
  }

  Future<void> _uploadPhoto(File file) async {
    emit(
      state.copyWith(
        photo: file,
        isUploadingPhoto: true,
        photoErrorMessage: null,
      ),
    );

    final result = await _uploadPhotoUseCase(file);

    switch (result) {
      case SuccessBaseResponse<void>():
        emit(state.copyWith(isUploadingPhoto: false, photoErrorMessage: null));
      case ErrorBaseResponse<void>():
        emit(
          state.copyWith(
            isUploadingPhoto: false,
            photoErrorMessage: result.failure.message,
          ),
        );
    }
  }

  Future<void> _submit() async {
    if (!hasChanges) return;

    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
        successMessage: null,
      ),
    );

    final result = await _editProfileUseCase(
      EditProfileParams(
        firstName: state.firstName,
        lastName: state.lastName,
        email: state.email,
        phone: state.phone,
      ),
    );

    switch (result) {
      case SuccessBaseResponse<ProfileDriverEntity>():
        final driver = result.data;
        _setInitialValues(driver);
        emit(
          state.copyWith(
            isSubmitting: false,
            driver: driver,
            firstName: driver.firstName ?? state.firstName,
            lastName: driver.lastName ?? state.lastName,
            email: driver.email ?? state.email,
            phone: driver.phone ?? state.phone,
            profilePhotoUrl: driver.photo ?? state.profilePhotoUrl,
            successMessage: 'Profile updated successfully',
            errorMessage: null,
          ),
        );
      case ErrorBaseResponse<ProfileDriverEntity>():
        emit(
          state.copyWith(
            isSubmitting: false,
            successMessage: null,
            errorMessage: result.failure.message,
          ),
        );
    }
  }
}

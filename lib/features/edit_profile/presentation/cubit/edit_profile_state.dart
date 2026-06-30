import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:tracking_app/features/profile/domain/entities/driver_entity.dart';

class EditProfileState extends Equatable {
  final ProfileDriverEntity? driver;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? profilePhotoUrl;
  final File? photo;
  final bool isLoadingProfile;
  final bool isSubmitting;
  final bool isUploadingPhoto;
  final String? errorMessage;
  final String? successMessage;
  final String? photoErrorMessage;

  const EditProfileState({
    this.driver,
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.profilePhotoUrl,
    this.photo,
    this.isLoadingProfile = false,
    this.isSubmitting = false,
    this.isUploadingPhoto = false,
    this.errorMessage,
    this.successMessage,
    this.photoErrorMessage,
  });

  EditProfileState copyWith({
    ProfileDriverEntity? driver,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? profilePhotoUrl,
    File? photo,
    bool? isLoadingProfile,
    bool? isSubmitting,
    bool? isUploadingPhoto,
    String? errorMessage,
    String? successMessage,
    String? photoErrorMessage,
  }) {
    return EditProfileState(
      driver: driver ?? this.driver,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      photo: photo ?? this.photo,
      isLoadingProfile: isLoadingProfile ?? this.isLoadingProfile,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isUploadingPhoto: isUploadingPhoto ?? this.isUploadingPhoto,
      errorMessage: errorMessage,
      successMessage: successMessage,
      photoErrorMessage: photoErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
        driver,
        firstName,
        lastName,
        email,
        phone,
        profilePhotoUrl,
        photo,
        isLoadingProfile,
        isSubmitting,
        isUploadingPhoto,
        errorMessage,
        successMessage,
        photoErrorMessage,
      ];
}

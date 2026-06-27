import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/error/error_handler.dart';
import 'package:tracking_app/features/edit_profile/api/api_client/edit_profile_api_client.dart';
import 'package:tracking_app/features/edit_profile/data/datasources/edit_profile_remote_data_source.dart';
import 'package:tracking_app/features/edit_profile/data/models/edit_profile_request.dart';
import 'package:tracking_app/features/profile/domain/entities/driver_entity.dart';

@LazySingleton(as: EditProfileRemoteDataSourceContract)
class EditProfileRemoteDataSourceImpl
    implements EditProfileRemoteDataSourceContract {
  final EditProfileApiClient _apiClient;

  EditProfileRemoteDataSourceImpl(this._apiClient);

  @override
  Future<BaseResponse<ProfileDriverEntity>> editProfile(
    EditProfileParams params,
  ) async {
    try {
      final response = await _apiClient.editProfile(
        EditProfileJsonRequest(
          firstName: params.firstName.trim(),
          lastName: params.lastName.trim(),
          email: params.email.trim(),
          phone: params.phone.trim(),
        ),
      );
      final driver = response.driver;
      if (driver != null) {
        return SuccessBaseResponse(data: driver.toEntity());
      }
      return ErrorBaseResponse(
        failure: ErrorHandler.handle(response.message ?? 'Update failed'),
      );
    } catch (e) {
      return ErrorBaseResponse(failure: ErrorHandler.handle(e));
    }
  }

  @override
  Future<BaseResponse<void>> uploadPhoto(File photo) async {
    try {
      await _apiClient.uploadPhoto(photo);
      return SuccessBaseResponse(data: null);
    } catch (e) {
      return ErrorBaseResponse(failure: ErrorHandler.handle(e));
    }
  }
}

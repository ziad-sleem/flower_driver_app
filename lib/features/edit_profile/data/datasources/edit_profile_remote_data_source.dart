import 'dart:io';

import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/edit_profile/data/models/edit_profile_request.dart';
import 'package:tracking_app/features/profile/domain/entities/driver_entity.dart';

abstract interface class EditProfileRemoteDataSourceContract {
  Future<BaseResponse<ProfileDriverEntity>> editProfile(
    EditProfileParams params,
  );
  Future<BaseResponse<void>> uploadPhoto(File photo);
}

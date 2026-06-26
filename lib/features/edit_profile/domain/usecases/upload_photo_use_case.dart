import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/edit_profile/domain/repositories/edit_profile_repository.dart';

@injectable
class UploadPhotoUseCase {
  final EditProfileRepository _repository;

  UploadPhotoUseCase(this._repository);

  Future<BaseResponse<void>> call(File photo) {
    return _repository.uploadPhoto(photo);
  }
}

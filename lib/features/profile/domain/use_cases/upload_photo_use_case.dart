import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/profile/domain/repositories/profile_repo.dart';

@injectable
class UploadPhotoUseCase {
  final ProfileRepo _repository;

  UploadPhotoUseCase(this._repository);

  Future<BaseResponse<void>> call(File photo) {
    return _repository.uploadPhoto(photo);
  }
}

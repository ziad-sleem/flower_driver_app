import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/edit_profile/data/datasources/edit_profile_remote_data_source.dart';
import 'package:tracking_app/features/edit_profile/data/models/edit_profile_request.dart';
import 'package:tracking_app/features/edit_profile/domain/repositories/edit_profile_repository.dart';
import 'package:tracking_app/features/profile/domain/entities/driver_entity.dart';

@Injectable(as: EditProfileRepository)
class EditProfileRepositoryImpl implements EditProfileRepository {
  final EditProfileRemoteDataSourceContract _dataSource;

  EditProfileRepositoryImpl(this._dataSource);

  @override
  Future<BaseResponse<ProfileDriverEntity>> editProfile(
    EditProfileParams params,
  ) {
    return _dataSource.editProfile(params);
  }

  @override
  Future<BaseResponse<void>> uploadPhoto(File photo) {
    return _dataSource.uploadPhoto(photo);
  }
}

import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/edit_profile/data/models/edit_profile_request.dart';
import 'package:tracking_app/features/edit_profile/domain/repositories/edit_profile_repository.dart';
import 'package:tracking_app/features/profile/domain/entities/driver_entity.dart';

@injectable
class EditProfileUseCase {
  final EditProfileRepository _repository;

  EditProfileUseCase(this._repository);

  Future<BaseResponse<ProfileDriverEntity>> call(EditProfileParams params) {
    return _repository.editProfile(params);
  }
}

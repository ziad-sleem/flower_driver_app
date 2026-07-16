import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/profile/data/models/edit_profile_request.dart';
import 'package:tracking_app/features/profile/domain/repositories/profile_repo.dart';
import 'package:tracking_app/features/profile/domain/entities/driver_entity.dart';

@injectable
class EditProfileUseCase {
  final ProfileRepo _repository;

  EditProfileUseCase(this._repository);

  Future<BaseResponse<ProfileDriverEntity>> call(EditProfileParams params) {
    return _repository.editProfile(params);
  }
}

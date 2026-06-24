import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/profile/domain/entities/profile_data_response_entity.dart';
import 'package:tracking_app/features/profile/domain/repositories/profile_repo.dart';

@injectable
class GetDriverDataUseCase {
  final ProfileRepo profileRepo;

  GetDriverDataUseCase({required this.profileRepo});

  Future<BaseResponse<ProfileDataResponseEntity>> call() {
    return profileRepo.getProfileData();
  }
}

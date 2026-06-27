import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/profile/domain/entities/all_vehicles_response_entity.dart';
import 'package:tracking_app/features/profile/domain/repositories/profile_repo.dart';

@injectable
class GetVehiclesUseCase {
  final ProfileRepo profileRepo;

  GetVehiclesUseCase({required this.profileRepo});

  Future<BaseResponse<AllVehiclesResponseEntity>> call() {
    return profileRepo.getVehicles();
  }
}

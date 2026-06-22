import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:tracking_app/features/profile/domain/repositories/profile_repo.dart';

@Injectable(as: ProfileRepo)
class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSourceContract profileRemoteDataSourceContract;

  ProfileRepoImpl({required this.profileRemoteDataSourceContract});
}

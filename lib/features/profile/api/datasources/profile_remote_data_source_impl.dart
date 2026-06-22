import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/profile/api/api_client/profile_api_client.dart';
import 'package:tracking_app/features/profile/data/datasources/profile_remote_data_source.dart';

@LazySingleton(as: ProfileRemoteDataSourceContract)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSourceContract {
  final ProfileApiClient profileApiClient;

  ProfileRemoteDataSourceImpl({required this.profileApiClient});
}

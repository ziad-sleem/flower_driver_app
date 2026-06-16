import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/auth/api/api_client/auth_api_client.dart';
import 'package:tracking_app/features/auth/data/datasources/auth_remote_data_source.dart';

@LazySingleton(as: AuthRemoteDataSourceContract)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSourceContract {
  final AuthApiClient authApiClient;

  AuthRemoteDataSourceImpl({required this.authApiClient});
}

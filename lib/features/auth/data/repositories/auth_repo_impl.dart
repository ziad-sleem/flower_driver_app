import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/domain/repositories/auth_repo.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSourceContract authRemoteDataSourceContract;

  AuthRepoImpl({required this.authRemoteDataSourceContract});
}

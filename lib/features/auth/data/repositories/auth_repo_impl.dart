import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/network/model/user.dart';
import 'package:tracking_app/core/network/model/user_entity.dart';
import 'package:tracking_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/domain/repositories/auth_repo.dart';
import 'package:tracking_app/features/auth/domain/use_cases/login_params.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSourceContract authRemoteDataSourceContract;

  AuthRepoImpl({required this.authRemoteDataSourceContract});

  @override
  Future<BaseResponse<UserEntity>> login(LoginParams params) async {
    final response = await authRemoteDataSourceContract.login(params);

    switch (response) {
      case SuccessBaseResponse<UserDto>():
        return SuccessBaseResponse<UserEntity>(data: response.data.toDomain());

      case ErrorBaseResponse<UserDto>():
        return ErrorBaseResponse<UserEntity>(failure: response.failure);
    }
  }
}

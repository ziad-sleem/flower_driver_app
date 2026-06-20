import 'package:dio/dio.dart';
import 'package:tracking_app/core/network/dio_helper.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/auth/api/api_client/auth_api_client.dart';

@module
abstract class NetworkModule {
  @singleton
  Dio get dio => DioHelper.dio;

  @singleton
  AuthApiClient authApi(Dio dio) => AuthApiClient(dio);
}

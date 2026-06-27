import 'package:dio/dio.dart';
import 'package:tracking_app/core/network/dio_helper.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/auth/api/api_client/auth_api_client.dart';
import 'package:tracking_app/features/edit_profile/api/api_client/edit_profile_api_client.dart';
import 'package:tracking_app/features/edit_vehical_info/api/api_client/edit_vehicle_info_api_client.dart';
import 'package:tracking_app/features/profile/api/api_client/profile_api_client.dart';

@module
abstract class NetworkModule {
  @singleton
  Dio get dio => DioHelper.dio;

  @singleton
  AuthApiClient authApi(Dio dio) => AuthApiClient(dio);

  @singleton
  ProfileApiClient profileApi(Dio dio) => ProfileApiClient(dio);

  @singleton
  EditProfileApiClient editProfileApi(Dio dio) => EditProfileApiClient(dio);

  @singleton
  EditVehicleInfoApiClient editVehicleInfoApi(Dio dio) =>
      EditVehicleInfoApiClient(dio);
}

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/core/network/endpoints.dart';
import 'package:tracking_app/features/profile/data/models/edit_profile_request.dart';
import 'package:tracking_app/features/profile/data/models/requests/reset_password_request_dto.dart';
import 'package:tracking_app/features/profile/data/models/responses/reset_password_response_dto.dart';
import 'package:tracking_app/features/profile/data/models/responses/all_vehicles_response_dto.dart';
import 'package:tracking_app/features/profile/data/models/responses/profile_data_response_dto.dart';
import 'package:tracking_app/features/profile/data/models/responses/single_vehicle_response_dto.dart';
import 'package:tracking_app/features/profile/data/models/responses/update_vehicle_response_dto.dart';

part 'profile_api_client.g.dart';

@RestApi()
abstract interface class ProfileApiClient {
  @factoryMethod
  factory ProfileApiClient(Dio dio, {String baseUrl}) = _ProfileApiClient;

  @GET(ProfileEndPoint.vehicles)
  Future<AllVehiclesResponseDto> getVehicles();

  @GET("${ProfileEndPoint.vehicles}/{id}")
  Future<SingleVehicleResponseDto> getVehicleById(@Path("id") String id);

  @GET(ProfileEndPoint.profileData)
  Future<ProfileDataResponseDto> getProfileData();

  @PATCH(ProfileEndPoint.changePassword)
  Future<ResetPasswordResponseDto> resetPassword(
    @Body() ResetPasswordRequestDto request,
  );

  @PUT(ProfileEndPoint.editProfile)
  Future<ProfileDataResponseDto> editProfile(
    @Body() EditProfileJsonRequest request,
  );

  @PUT(ProfileEndPoint.uploadPhoto)
  @MultiPart()
  Future<void> uploadPhoto(@Part(name: 'photo') File photo);

  @PUT(ProfileEndPoint.updateVehicleInfo)
  @MultiPart()
  Future<UpdateVehicleResponseDto> updateVehicleInfo(@Body() FormData request);
}

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/core/network/endpoints.dart';
import 'package:tracking_app/features/edit_profile/data/models/edit_profile_request.dart';
import 'package:tracking_app/features/profile/data/models/responses/profile_data_response_dto.dart';

part 'edit_profile_api_client.g.dart';

@RestApi()
abstract interface class EditProfileApiClient {
  @factoryMethod
  factory EditProfileApiClient(Dio dio, {String baseUrl}) =
      _EditProfileApiClient;

  @PUT(EditProfileEndPoint.editProfile)
  Future<ProfileDataResponseDto> editProfile(
    @Body() EditProfileJsonRequest request,
  );

  @PUT(EditProfileEndPoint.uploadPhoto)
  @MultiPart()
  Future<void> uploadPhoto(@Part(name: 'photo') File photo);
}

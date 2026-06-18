import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/core/network/endpoints.dart';
import 'package:tracking_app/features/auth/data/models/requests/login_request.dart';
import 'package:tracking_app/features/auth/data/models/response/login_response.dart';

part 'auth_api_client.g.dart';

@RestApi()
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio, {String baseUrl}) = _AuthApiClient;

  @POST(AuthEndPoint.signIn)
  Future<LoginResponse> login(@Body() LoginRequest request);
}

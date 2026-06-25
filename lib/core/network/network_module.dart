import 'package:dio/dio.dart';
import 'package:tracking_app/core/network/dio_helper.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/auth/api/api_client/auth_api_client.dart';
import 'package:tracking_app/features/oreder_details/api/api_client/order_details_api_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@module
abstract class NetworkModule {
  @singleton
  Dio get dio => DioHelper.dio;

  @singleton
  FirebaseFirestore get firebaseFirestore => FirebaseFirestore.instance;

  @singleton
  AuthApiClient authApi(Dio dio) => AuthApiClient(dio);

  @singleton
  OrderDetailsApiClient orderDetailsApiClient(Dio dio) =>
      OrderDetailsApiClient(dio);
}

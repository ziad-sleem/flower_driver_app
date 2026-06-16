import 'package:dio/dio.dart';
import 'package:tracking_app/core/network/dio_helper.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NetworkModule {
  @singleton
  Dio get dio => DioHelper.dio;


}

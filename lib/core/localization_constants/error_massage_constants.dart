import 'package:easy_localization/easy_localization.dart';

abstract class ErrorConstants {
  const ErrorConstants._();

  static String get noInternet => "".tr();
  static String get connectionTimeout => "".tr();
  static String get sendTimeout => "".tr();
  static String get receiveTimeout => "".tr();
  static String get serverError => "".tr();
  static String get unexpectedError => "".tr();
  static String get unknownError => "".tr();
  static String get loginSuccessfully => "".tr();
  static String get signupSuccessfully => "".tr();
}

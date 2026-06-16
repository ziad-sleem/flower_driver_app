import 'package:easy_localization/easy_localization.dart';

abstract class ErrorConstants {
  const ErrorConstants._();

  static String get noInternet => "errors.no_internet".tr();
  static String get connectionTimeout => "errors.connection_timeout".tr();
  static String get sendTimeout => "errors.send_timeout".tr();
  static String get receiveTimeout => "errors.receive_timeout".tr();
  static String get serverError => "errors.server_error".tr();
  static String get unexpectedError => "errors.unexpected_error".tr();
  static String get unknownError => "errors.unknown_error".tr();
  static String get loginSuccessfully => "errors.login_successfully".tr();
  static String get signupSuccessfully => "errors.signup_successfully".tr();
}

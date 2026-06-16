import 'package:easy_localization/easy_localization.dart';

abstract class ValidationConstants {
  ValidationConstants._();

  static String get emailRequired => "".tr();
  static String get invalidEmail => "".tr();
  static String get passwordRequired => "".tr();
  static String get shortPassword => "".tr();
  static String get weakPassword => "".tr();
  static String get nameRequired => "".tr();
  static String get shortName => "".tr();
  static String get invalidName => "".tr();
  static String get phoneRequired => "".tr();
  static String get phoneFormatHint => "".tr();
  static String get confirmPasswordRequired => "".tr();
  static String get passwordNotMatch => "".tr();
  static String get newPasswordSameAsOld => "".tr();
  static String get codeRequired => "".tr();
  static String get invalidCode => "".tr();
}

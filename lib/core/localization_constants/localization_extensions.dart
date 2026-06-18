import 'package:flutter/material.dart';
import 'package:tracking_app/core/localization_constants/auth_constants.dart';

extension LocalizationExtensions on BuildContext {
  String get login => AuthConstants.login;
  String get email => AuthConstants.email;
  String get password => AuthConstants.password;
  String get enterEmail => AuthConstants.enterYourEmail;
  String get enterPassword => AuthConstants.enterYourPassword;
  String get rememberMe => AuthConstants.rememberMe;
  String get forgotPassword => AuthConstants.forgetPassword;
  String get continueAsGuest => AuthConstants.continueAsGuest;
  String get dontHaveAccount => AuthConstants.dontHaveAccount;
  String get signUp => AuthConstants.signUp;
}

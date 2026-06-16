import 'package:easy_localization/easy_localization.dart';
import 'package:tracking_app/app.dart';
import 'package:tracking_app/config/dependency_injection/di.dart';
import 'package:tracking_app/core/network/dio_helper.dart';
import 'package:tracking_app/core/resources/app_value.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  configureDependencies();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale(AppKeys.enLocale),
        Locale(AppKeys.arLocale),
      ],
      path: AppKeys.translationPath,
      child: const TrackingApp(),
    ),
  );
}

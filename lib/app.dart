import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/config/routes/app_router.dart';
import 'package:tracking_app/config/routes/routes.dart';
import 'package:tracking_app/core/theme/app_theme.dart';

class TrackingApp extends StatelessWidget {
  const TrackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      theme: AppTheme.lightTheme,
      initialRoute: Routes.onboarding,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}

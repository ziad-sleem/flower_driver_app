// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../core/network/network_module.dart' as _i234;
import '../../core/network/safe_api_caller.dart' as _i563;
import '../../core/notifications/fcm_service.dart' as _i761;
import '../../core/notifications/local_notification_service.dart' as _i298;
import '../../core/notifications/notification_initializer.dart' as _i838;
import '../../core/service/crashlytics_service.dart' as _i776;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final networkModule = _$NetworkModule();
    gh.factory<_i563.SafeApiCaller>(() => _i563.SafeApiCaller());
    gh.singleton<_i361.Dio>(() => networkModule.dio);
    gh.lazySingleton<_i298.LocalNotificationService>(
      () => _i298.LocalNotificationService(),
    );
    gh.lazySingleton<_i776.CrashlyticsService>(
      () => _i776.CrashlyticsService(),
    );
    gh.lazySingleton<_i761.FcmService>(
      () => _i761.FcmService(gh<_i298.LocalNotificationService>()),
    );
    gh.lazySingleton<_i838.NotificationInitializer>(
      () => _i838.NotificationInitializer(
        gh<_i761.FcmService>(),
        gh<_i298.LocalNotificationService>(),
      ),
    );
    return this;
  }
}

class _$NetworkModule extends _i234.NetworkModule {}

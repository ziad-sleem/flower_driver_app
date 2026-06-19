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
import '../../core/service/crashlytics_service.dart' as _i776;
import '../../core/service/image_picker_service.dart' as _i488;
import '../../core/service/load_json_countries.dart' as _i923;
import '../../features/auth/api/api_client/auth_api_client.dart' as _i824;
import '../../features/auth/api/datasources/auth_remote_data_source_impl.dart'
    as _i723;
import '../../features/auth/data/datasources/auth_remote_data_source.dart'
    as _i107;
import '../../features/auth/data/repositories/auth_repo_impl.dart' as _i662;
import '../../features/auth/domain/repositories/auth_repo.dart' as _i723;
import '../../features/auth/domain/use_cases/apply_now_use_case.dart' as _i724;
import '../../features/auth/domain/use_cases/get_vehicles_use_case.dart'
    as _i817;
import '../../features/auth/presentation/apply/cubit/apply_cubit.dart' as _i650;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final networkModule = _$NetworkModule();
    gh.factory<_i563.SafeApiCaller>(() => _i563.SafeApiCaller());
    gh.factory<_i923.CountryService>(() => _i923.CountryService());
    gh.singleton<_i361.Dio>(() => networkModule.dio);
    gh.lazySingleton<_i776.CrashlyticsService>(
      () => _i776.CrashlyticsService(),
    );
    gh.lazySingleton<_i488.ImagePickerService>(
      () => _i488.ImagePickerServiceImpl(),
    );
    gh.singleton<_i824.AuthApiClient>(
      () => networkModule.authApi(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i107.AuthRemoteDataSourceContract>(
      () => _i723.AuthRemoteDataSourceImpl(
        authApiClient: gh<_i824.AuthApiClient>(),
        safeApiCaller: gh<_i563.SafeApiCaller>(),
      ),
    );
    gh.factory<_i723.AuthRepo>(
      () => _i662.AuthRepoImpl(
        authRemoteDataSourceContract: gh<_i107.AuthRemoteDataSourceContract>(),
      ),
    );
    gh.factory<_i724.ApplyNowUseCase>(
      () => _i724.ApplyNowUseCase(gh<_i723.AuthRepo>()),
    );
    gh.factory<_i817.GetVehiclesUseCase>(
      () => _i817.GetVehiclesUseCase(gh<_i723.AuthRepo>()),
    );
    gh.factory<_i650.ApplyCubit>(
      () => _i650.ApplyCubit(
        gh<_i817.GetVehiclesUseCase>(),
        gh<_i724.ApplyNowUseCase>(),
        gh<_i923.CountryService>(),
        gh<_i488.ImagePickerService>(),
      ),
    );
    return this;
  }
}

class _$NetworkModule extends _i234.NetworkModule {}

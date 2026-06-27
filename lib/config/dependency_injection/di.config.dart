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
import '../../features/app_section/presentation/cubit/app_section_cubit.dart'
    as _i999;
import '../../features/auth/api/api_client/auth_api_client.dart' as _i824;
import '../../features/auth/api/datasources/auth_remote_data_source_impl.dart'
    as _i723;
import '../../features/auth/data/datasources/auth_remote_data_source.dart'
    as _i107;
import '../../features/auth/data/repositories/auth_repo_impl.dart' as _i662;
import '../../features/auth/domain/repositories/auth_repo.dart' as _i723;
import '../../features/auth/domain/use_cases/apply_now_use_case.dart' as _i724;
import '../../features/auth/domain/use_cases/forget_password_usecase.dart'
    as _i27;
import '../../features/auth/domain/use_cases/get_vehicles_use_case.dart'
    as _i817;
import '../../features/auth/domain/use_cases/login_use_case.dart' as _i1038;
import '../../features/auth/domain/use_cases/logout_use_case.dart' as _i698;
import '../../features/auth/domain/use_cases/reset_password_usecase.dart'
    as _i348;
import '../../features/auth/domain/use_cases/verify_reset_code_usecase.dart'
    as _i887;
import '../../features/auth/presentation/apply/cubit/apply_cubit.dart' as _i650;
import '../../features/auth/presentation/forget_password/cubit/forget_password_cubit.dart'
    as _i995;
import '../../features/auth/presentation/login/cubit/login_cubit.dart' as _i179;
import '../../features/edit_profile/api/api_client/edit_profile_api_client.dart'
    as _i690;
import '../../features/edit_profile/api/datasource/edit_profile_remote_data_source_impl.dart'
    as _i458;
import '../../features/edit_profile/data/datasources/edit_profile_remote_data_source.dart'
    as _i261;
import '../../features/edit_profile/data/repositories/edit_profile_repository_impl.dart'
    as _i337;
import '../../features/edit_profile/domain/repositories/edit_profile_repository.dart'
    as _i698;
import '../../features/edit_profile/domain/usecases/edit_profile_use_case.dart'
    as _i620;
import '../../features/edit_profile/domain/usecases/upload_photo_use_case.dart'
    as _i538;
import '../../features/edit_profile/presentation/cubit/edit_profile_cubit.dart'
    as _i657;
import '../../features/profile/api/api_client/profile_api_client.dart' as _i699;
import '../../features/profile/api/datasources/profile_remote_data_source_impl.dart'
    as _i4;
import '../../features/profile/data/datasources/profile_remote_data_source.dart'
    as _i847;
import '../../features/profile/data/repositories/profile_repo_impl.dart'
    as _i988;
import '../../features/profile/domain/repositories/profile_repo.dart' as _i790;
<<<<<<< HEAD
import '../../features/profile/domain/use_cases/reset_password_use_case.dart'
    as _i641;
=======
import '../../features/profile/domain/use_cases/get_driver_data_use_case.dart'
    as _i141;
import '../../features/profile/domain/use_cases/get_vehicles_use_case.dart'
    as _i151;
>>>>>>> feature/SCRUM-62-profile-module
import '../../features/profile/presentation/cubit/profile_cubit.dart' as _i36;
import '../../features/profile/presentation/reset_password/cubit/reset_password_cubit.dart'
    as _i786;

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
    gh.factory<_i999.AppSectionsCubit>(() => _i999.AppSectionsCubit());
    gh.factory<_i698.LogoutUseCase>(() => _i698.LogoutUseCase());
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
    gh.singleton<_i699.ProfileApiClient>(
      () => networkModule.profileApi(gh<_i361.Dio>()),
    );
    gh.singleton<_i690.EditProfileApiClient>(
      () => networkModule.editProfileApi(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i847.ProfileRemoteDataSourceContract>(
      () => _i4.ProfileRemoteDataSourceImpl(
        profileApiClient: gh<_i699.ProfileApiClient>(),
        safeApiCaller: gh<_i563.SafeApiCaller>(),
      ),
    );
    gh.lazySingleton<_i107.AuthRemoteDataSourceContract>(
      () => _i723.AuthRemoteDataSourceImpl(
        authApiClient: gh<_i824.AuthApiClient>(),
        safeApiCaller: gh<_i563.SafeApiCaller>(),
      ),
    );
    gh.lazySingleton<_i261.EditProfileRemoteDataSourceContract>(
      () => _i458.EditProfileRemoteDataSourceImpl(
        gh<_i690.EditProfileApiClient>(),
      ),
    );
    gh.factory<_i723.AuthRepo>(
      () => _i662.AuthRepoImpl(
        authRemoteDataSourceContract: gh<_i107.AuthRemoteDataSourceContract>(),
      ),
    );
    gh.factory<_i790.ProfileRepo>(
      () => _i988.ProfileRepoImpl(
        profileRemoteDataSourceContract:
            gh<_i847.ProfileRemoteDataSourceContract>(),
      ),
    );
    gh.factory<_i641.ResetPasswordUseCase>(
      () => _i641.ResetPasswordUseCase(gh<_i790.ProfileRepo>()),
    );
    gh.factory<_i1038.LoginUseCase>(
      () => _i1038.LoginUseCase(authRepo: gh<_i723.AuthRepo>()),
    );
    gh.factory<_i724.ApplyNowUseCase>(
      () => _i724.ApplyNowUseCase(gh<_i723.AuthRepo>()),
    );
    gh.factory<_i817.GetVehiclesUseCase>(
      () => _i817.GetVehiclesUseCase(gh<_i723.AuthRepo>()),
    );
    gh.factory<_i179.LoginCubit>(
      () => _i179.LoginCubit(gh<_i1038.LoginUseCase>()),
    );
<<<<<<< HEAD
    gh.factory<_i698.EditProfileRepository>(
      () => _i337.EditProfileRepositoryImpl(
        gh<_i261.EditProfileRemoteDataSourceContract>(),
      ),
    );
    gh.factory<_i36.ProfileCubit>(
      () => _i36.ProfileCubit(gh<_i790.ProfileRepo>()),
=======
    gh.factory<_i141.GetDriverDataUseCase>(
      () => _i141.GetDriverDataUseCase(profileRepo: gh<_i790.ProfileRepo>()),
    );
    gh.factory<_i151.GetVehiclesUseCase>(
      () => _i151.GetVehiclesUseCase(profileRepo: gh<_i790.ProfileRepo>()),
    );
    gh.factory<_i786.ResetPasswordCubit>(
      () => _i786.ResetPasswordCubit(gh<_i641.ResetPasswordUseCase>()),
>>>>>>> feature/SCRUM-62-profile-module
    );
    gh.factory<_i620.EditProfileUseCase>(
      () => _i620.EditProfileUseCase(gh<_i698.EditProfileRepository>()),
    );
    gh.factory<_i538.UploadPhotoUseCase>(
      () => _i538.UploadPhotoUseCase(gh<_i698.EditProfileRepository>()),
    );
    gh.factory<_i657.EditProfileCubit>(
      () => _i657.EditProfileCubit(
        gh<_i620.EditProfileUseCase>(),
        gh<_i538.UploadPhotoUseCase>(),
        gh<_i790.ProfileRepo>(),
      ),
    );
    gh.factory<_i27.ForgetPasswordUseCase>(
      () => _i27.ForgetPasswordUseCase(gh<_i723.AuthRepo>()),
    );
    gh.factory<_i348.ResetPasswordUseCase>(
      () => _i348.ResetPasswordUseCase(gh<_i723.AuthRepo>()),
    );
    gh.factory<_i887.VerifyResetCodeUseCase>(
      () => _i887.VerifyResetCodeUseCase(gh<_i723.AuthRepo>()),
    );
    gh.factory<_i650.ApplyCubit>(
      () => _i650.ApplyCubit(
        gh<_i817.GetVehiclesUseCase>(),
        gh<_i724.ApplyNowUseCase>(),
        gh<_i923.CountryService>(),
        gh<_i488.ImagePickerService>(),
      ),
    );
    gh.factory<_i995.ForgetPasswordCubit>(
      () => _i995.ForgetPasswordCubit(
        gh<_i27.ForgetPasswordUseCase>(),
        gh<_i887.VerifyResetCodeUseCase>(),
        gh<_i348.ResetPasswordUseCase>(),
      ),
    );
    gh.factory<_i36.ProfileCubit>(
      () => _i36.ProfileCubit(
        gh<_i141.GetDriverDataUseCase>(),
        gh<_i151.GetVehiclesUseCase>(),
      ),
    );
    return this;
  }
}

class _$NetworkModule extends _i234.NetworkModule {}

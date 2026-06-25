// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
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
import '../../features/auth/domain/use_cases/get_driver_profile_usecase.dart'
    as _i832;
import '../../features/auth/domain/use_cases/get_vehicles_use_case.dart'
    as _i817;
import '../../features/auth/domain/use_cases/login_use_case.dart' as _i1038;
import '../../features/auth/domain/use_cases/reset_password_usecase.dart'
    as _i348;
import '../../features/auth/domain/use_cases/verify_reset_code_usecase.dart'
    as _i887;
import '../../features/auth/presentation/apply/cubit/apply_cubit.dart' as _i650;
import '../../features/auth/presentation/forget_password/cubit/forget_password_cubit.dart'
    as _i995;
import '../../features/auth/presentation/login/cubit/login_cubit.dart' as _i179;
import '../../features/oreder_details/api/api_client/order_details_api_client.dart'
    as _i244;
import '../../features/oreder_details/api/datasources/order_details_firestore_data_source_impl.dart'
    as _i672;
import '../../features/oreder_details/api/datasources/order_details_remote_data_source_impl.dart'
    as _i638;
import '../../features/oreder_details/data/datasources/order_details_firestore_data_source.dart'
    as _i824;
import '../../features/oreder_details/data/datasources/order_details_remote_data_source.dart'
    as _i742;
import '../../features/oreder_details/data/repositories/order_details_repo_impl.dart'
    as _i136;
import '../../features/oreder_details/domain/repositories/order_details_repo.dart'
    as _i1004;
import '../../features/oreder_details/domain/use_cases/delete_current_order_usecase.dart'
    as _i99;
import '../../features/oreder_details/domain/use_cases/get_all_pending_order.dart'
    as _i945;
import '../../features/oreder_details/domain/use_cases/save_current_order_usecase.dart'
    as _i753;
import '../../features/oreder_details/domain/use_cases/update_order_state_usecase.dart'
    as _i386;
import '../../features/oreder_details/presentation/cubit/home_cubit.dart'
    as _i531;

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
    gh.singleton<_i361.Dio>(() => networkModule.dio);
    gh.singleton<_i974.FirebaseFirestore>(
      () => networkModule.firebaseFirestore,
    );
    gh.lazySingleton<_i776.CrashlyticsService>(
      () => _i776.CrashlyticsService(),
    );
    gh.lazySingleton<_i488.ImagePickerService>(
      () => _i488.ImagePickerServiceImpl(),
    );
    gh.singleton<_i824.AuthApiClient>(
      () => networkModule.authApi(gh<_i361.Dio>()),
    );
    gh.singleton<_i244.OrderDetailsApiClient>(
      () => networkModule.orderDetailsApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i742.OrderDetailsRemoteDataSource>(
      () => _i638.OrderDetailsRemoteDataSourceImpl(
        safeApiCaller: gh<_i563.SafeApiCaller>(),
        apiClient: gh<_i244.OrderDetailsApiClient>(),
      ),
    );
    gh.lazySingleton<_i107.AuthRemoteDataSourceContract>(
      () => _i723.AuthRemoteDataSourceImpl(
        authApiClient: gh<_i824.AuthApiClient>(),
        safeApiCaller: gh<_i563.SafeApiCaller>(),
      ),
    );
    gh.factory<_i824.OrderDetailsFireStoreDataSource>(
      () => _i672.OrderDetailsFireStoreDataSourceImpl(
        gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.factory<_i1004.OrderDetailsRepo>(
      () => _i136.OrderDetailsRepoImpl(
        remoteDataSource: gh<_i742.OrderDetailsRemoteDataSource>(),
        firestoreDataSource: gh<_i824.OrderDetailsFireStoreDataSource>(),
      ),
    );
    gh.factory<_i945.GetPendingOrdersUseCase>(
      () => _i945.GetPendingOrdersUseCase(
        orderDetailsRepo: gh<_i1004.OrderDetailsRepo>(),
      ),
    );
    gh.factory<_i99.DeleteCurrentOrderUseCase>(
      () => _i99.DeleteCurrentOrderUseCase(repo: gh<_i1004.OrderDetailsRepo>()),
    );
    gh.factory<_i753.SaveCurrentOrderUseCase>(
      () => _i753.SaveCurrentOrderUseCase(repo: gh<_i1004.OrderDetailsRepo>()),
    );
    gh.factory<_i386.UpdateOrderStateUseCase>(
      () => _i386.UpdateOrderStateUseCase(repo: gh<_i1004.OrderDetailsRepo>()),
    );
    gh.factory<_i723.AuthRepo>(
      () => _i662.AuthRepoImpl(
        authRemoteDataSourceContract: gh<_i107.AuthRemoteDataSourceContract>(),
      ),
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
    gh.factory<_i832.GetDriverProfileUseCase>(
      () => _i832.GetDriverProfileUseCase(gh<_i723.AuthRepo>()),
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
    gh.factory<_i531.HomeCubit>(
      () => _i531.HomeCubit(
        gh<_i945.GetPendingOrdersUseCase>(),
        gh<_i386.UpdateOrderStateUseCase>(),
        gh<_i753.SaveCurrentOrderUseCase>(),
      ),
    );
    return this;
  }
}

class _$NetworkModule extends _i234.NetworkModule {}

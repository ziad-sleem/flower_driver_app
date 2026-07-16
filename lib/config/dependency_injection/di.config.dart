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

import '../../core/firebase/firestore_notification_service.dart' as _i1049;
import '../../core/network/network_module.dart' as _i234;
import '../../core/network/safe_api_caller.dart' as _i563;
import '../../core/notifications/fcm_service.dart' as _i761;
import '../../core/notifications/local_notification_service.dart' as _i298;
import '../../core/notifications/notification_initializer.dart' as _i838;
import '../../core/service/crashlytics_service.dart' as _i776;
import '../../core/service/image_picker_service.dart' as _i488;
import '../../core/service/load_json_countries.dart' as _i923;
import '../../features/app_section/presentation/cubit/app_launch_cubit.dart'
    as _i545;
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
import '../../features/auth/domain/use_cases/logout_use_case.dart' as _i698;
import '../../features/auth/domain/use_cases/reset_password_usecase.dart'
    as _i348;
import '../../features/auth/domain/use_cases/verify_reset_code_usecase.dart'
    as _i887;
import '../../features/auth/presentation/apply/cubit/apply_cubit.dart' as _i650;
import '../../features/auth/presentation/forget_password/cubit/forget_password_cubit.dart'
    as _i995;
import '../../features/auth/presentation/login/cubit/login_cubit.dart' as _i179;
import '../../features/notifications/data_source/notification_queue_firestore_data_source.dart'
    as _i948;
import '../../features/notifications/data_source/notification_queue_firestore_data_source_impl.dart'
    as _i373;
import '../../features/notifications/repository/notification_queue_repo.dart'
    as _i330;
import '../../features/notifications/repository/notification_queue_repo_impl.dart'
    as _i1029;
import '../../features/orders/api/api_client/order_page_api_client.dart'
    as _i454;
import '../../features/orders/api/datasource/order_page_remote_data_source_impl.dart'
    as _i485;
import '../../features/orders/data/datasources/order_page_remote_data_source.dart'
    as _i644;
import '../../features/orders/data/repositories/order_page_repo_impl.dart'
    as _i579;
import '../../features/orders/domain/repositories/order_page_repo.dart' as _i59;
import '../../features/orders/domain/usecases/get_driver_orders_use_case.dart'
    as _i158;
import '../../features/orders/presentation/cubit/order_page_cubit.dart' as _i2;
import '../../features/oreder_details/api/api_client/order_details_api_client.dart'
    as _i244;
import '../../features/oreder_details/api/datasources/order_details_firestore_data_source_impl.dart'
    as _i672;
import '../../features/oreder_details/api/datasources/order_details_remote_data_source_impl.dart'
    as _i638;
import '../../features/oreder_details/api/datasources/order_user_info_remote_data_source_impl.dart'
    as _i442;
import '../../features/oreder_details/data/datasources/order_details_firestore_data_source.dart'
    as _i824;
import '../../features/oreder_details/data/datasources/order_details_remote_data_source.dart'
    as _i742;
import '../../features/oreder_details/data/datasources/order_user_info_remote_data_source.dart'
    as _i772;
import '../../features/oreder_details/data/repositories/order_details_repo_impl.dart'
    as _i136;
import '../../features/oreder_details/data/repositories/order_user_info_repo_impl.dart'
    as _i895;
import '../../features/oreder_details/domain/repositories/order_details_repo.dart'
    as _i1004;
import '../../features/oreder_details/domain/repositories/order_user_info_repo.dart'
    as _i249;
import '../../features/oreder_details/domain/use_cases/create_notification_request_use_case.dart'
    as _i302;
import '../../features/oreder_details/domain/use_cases/delete_current_order_usecase.dart'
    as _i99;
import '../../features/oreder_details/domain/use_cases/get_all_pending_order.dart'
    as _i945;
import '../../features/oreder_details/domain/use_cases/get_current_order_usecase.dart'
    as _i315;
import '../../features/oreder_details/domain/use_cases/get_order_user_info_use_case.dart'
    as _i492;
import '../../features/oreder_details/domain/use_cases/save_current_order_usecase.dart'
    as _i753;
import '../../features/oreder_details/domain/use_cases/update_order_state_usecase.dart'
    as _i386;
import '../../features/oreder_details/domain/use_cases/watch_order_state_usecase.dart'
    as _i941;
import '../../features/oreder_details/presentation/cubit/home_cubit.dart'
    as _i531;
import '../../features/oreder_details/presentation/cubit/order_details_cubit.dart'
    as _i235;
import '../../features/oreder_details/presentation/cubit/order_user_info_cubit.dart'
    as _i199;
import '../../features/profile/api/api_client/profile_api_client.dart' as _i699;
import '../../features/profile/api/datasources/profile_remote_data_source_impl.dart'
    as _i4;
import '../../features/profile/data/datasources/profile_remote_data_source.dart'
    as _i847;
import '../../features/profile/data/repositories/profile_repo_impl.dart'
    as _i988;
import '../../features/profile/domain/repositories/profile_repo.dart' as _i790;
import '../../features/profile/domain/use_cases/edit_profile_use_case.dart'
    as _i199;
import '../../features/profile/domain/use_cases/get_driver_data_use_case.dart'
    as _i141;
import '../../features/profile/domain/use_cases/get_vehicles_use_case.dart'
    as _i151;
import '../../features/profile/domain/use_cases/reset_password_use_case.dart'
    as _i641;
import '../../features/profile/domain/use_cases/update_vehicle_use_case.dart'
    as _i730;
import '../../features/profile/domain/use_cases/upload_photo_use_case.dart'
    as _i967;
import '../../features/profile/presentation/cubit/edit_profile_cubit.dart'
    as _i990;
import '../../features/profile/presentation/cubit/edit_vehicle_info_cubit.dart'
    as _i947;
import '../../features/profile/presentation/cubit/profile_cubit.dart' as _i36;
import '../../features/profile/presentation/reset_password/cubit/reset_password_cubit.dart'
    as _i786;
import 'firestore_module.dart' as _i431;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final firestoreModule = _$FirestoreModule();
    final networkModule = _$NetworkModule();
    gh.factory<_i563.SafeApiCaller>(() => _i563.SafeApiCaller());
    gh.factory<_i923.CountryService>(() => _i923.CountryService());
    gh.factory<_i999.AppSectionsCubit>(() => _i999.AppSectionsCubit());
    gh.factory<_i698.LogoutUseCase>(() => _i698.LogoutUseCase());
    gh.singleton<_i974.FirebaseFirestore>(() => firestoreModule.firestore);
    gh.singleton<_i361.Dio>(() => networkModule.dio);
    gh.lazySingleton<_i1049.FirestoreNotificationService>(
      () => _i1049.FirestoreNotificationService(),
    );
    gh.lazySingleton<_i298.LocalNotificationService>(
      () => _i298.LocalNotificationService(),
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
    gh.singleton<_i699.ProfileApiClient>(
      () => networkModule.profileApi(gh<_i361.Dio>()),
    );
    gh.singleton<_i454.OrderPageApiClient>(
      () => networkModule.orderPageApi(gh<_i361.Dio>()),
    );
    gh.factory<_i742.OrderDetailsRemoteDataSource>(
      () => _i638.OrderDetailsRemoteDataSourceImpl(
        safeApiCaller: gh<_i563.SafeApiCaller>(),
        apiClient: gh<_i244.OrderDetailsApiClient>(),
      ),
    );
    gh.lazySingleton<_i847.ProfileRemoteDataSourceContract>(
      () => _i4.ProfileRemoteDataSourceImpl(
        profileApiClient: gh<_i699.ProfileApiClient>(),
        safeApiCaller: gh<_i563.SafeApiCaller>(),
      ),
    );
    gh.factory<_i948.NotificationQueueFirestoreDataSource>(
      () => _i373.NotificationQueueFirestoreDataSourceImpl(
        gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.factory<_i330.NotificationQueueRepo>(
      () => _i1029.NotificationQueueRepoImpl(
        gh<_i948.NotificationQueueFirestoreDataSource>(),
      ),
    );
    gh.factory<_i302.CreateNotificationRequestUseCase>(
      () => _i302.CreateNotificationRequestUseCase(
        gh<_i330.NotificationQueueRepo>(),
      ),
    );
    gh.lazySingleton<_i772.OrderUserInfoRemoteDataSourceContract>(
      () => _i442.OrderUserInfoRemoteDataSourceImpl(
        firestore: gh<_i974.FirebaseFirestore>(),
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
    gh.lazySingleton<_i761.FcmService>(
      () => _i761.FcmService(
        gh<_i298.LocalNotificationService>(),
        gh<_i1049.FirestoreNotificationService>(),
      ),
    );
    gh.lazySingleton<_i644.OrderPageRemoteDataSourceContract>(
      () => _i485.OrderPageRemoteDataSourceImpl(
        apiClient: gh<_i454.OrderPageApiClient>(),
        safeApiCaller: gh<_i563.SafeApiCaller>(),
      ),
    );
    gh.lazySingleton<_i249.OrderUserInfoRepo>(
      () => _i895.OrderUserInfoRepoImpl(
        gh<_i772.OrderUserInfoRemoteDataSourceContract>(),
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
    gh.factory<_i1004.OrderDetailsRepo>(
      () => _i136.OrderDetailsRepoImpl(
        remoteDataSource: gh<_i742.OrderDetailsRemoteDataSource>(),
        firestoreDataSource: gh<_i824.OrderDetailsFireStoreDataSource>(),
        notificationRequestFirestoreDataSource:
            gh<_i948.NotificationQueueFirestoreDataSource>(),
      ),
    );
    gh.factory<_i1038.LoginUseCase>(
      () => _i1038.LoginUseCase(authRepo: gh<_i723.AuthRepo>()),
    );
    gh.factory<_i199.EditProfileUseCase>(
      () => _i199.EditProfileUseCase(gh<_i790.ProfileRepo>()),
    );
    gh.factory<_i730.UpdateVehicleUseCase>(
      () => _i730.UpdateVehicleUseCase(gh<_i790.ProfileRepo>()),
    );
    gh.factory<_i967.UploadPhotoUseCase>(
      () => _i967.UploadPhotoUseCase(gh<_i790.ProfileRepo>()),
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
    gh.lazySingleton<_i838.NotificationInitializer>(
      () => _i838.NotificationInitializer(
        gh<_i761.FcmService>(),
        gh<_i298.LocalNotificationService>(),
      ),
    );
    gh.factory<_i832.GetDriverProfileUseCase>(
      () => _i832.GetDriverProfileUseCase(gh<_i723.AuthRepo>()),
    );
    gh.factory<_i945.GetPendingOrdersUseCase>(
      () => _i945.GetPendingOrdersUseCase(
        orderDetailsRepo: gh<_i1004.OrderDetailsRepo>(),
      ),
    );
    gh.factory<_i786.ResetPasswordCubit>(
      () => _i786.ResetPasswordCubit(gh<_i641.ResetPasswordUseCase>()),
    );
    gh.factory<_i492.GetOrderUserInfoUseCase>(
      () => _i492.GetOrderUserInfoUseCase(gh<_i249.OrderUserInfoRepo>()),
    );
    gh.factory<_i141.GetDriverDataUseCase>(
      () => _i141.GetDriverDataUseCase(profileRepo: gh<_i790.ProfileRepo>()),
    );
    gh.factory<_i151.GetVehiclesUseCase>(
      () => _i151.GetVehiclesUseCase(profileRepo: gh<_i790.ProfileRepo>()),
    );
    gh.factory<_i59.OrderPageRepo>(
      () => _i579.OrderPageRepoImpl(
        remoteDataSource: gh<_i644.OrderPageRemoteDataSourceContract>(),
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
    gh.factory<_i99.DeleteCurrentOrderUseCase>(
      () => _i99.DeleteCurrentOrderUseCase(repo: gh<_i1004.OrderDetailsRepo>()),
    );
    gh.factory<_i315.GetCurrentOrderUseCase>(
      () => _i315.GetCurrentOrderUseCase(repo: gh<_i1004.OrderDetailsRepo>()),
    );
    gh.factory<_i753.SaveCurrentOrderUseCase>(
      () => _i753.SaveCurrentOrderUseCase(repo: gh<_i1004.OrderDetailsRepo>()),
    );
    gh.factory<_i941.WatchCurrentOrderUseCase>(
      () => _i941.WatchCurrentOrderUseCase(repo: gh<_i1004.OrderDetailsRepo>()),
    );
    gh.factory<_i386.UpdateOrderStateUseCase>(
      () => _i386.UpdateOrderStateUseCase(
        repo: gh<_i1004.OrderDetailsRepo>(),
        createNotificationRequestUseCase:
            gh<_i302.CreateNotificationRequestUseCase>(),
      ),
    );
    gh.factory<_i947.EditVehicleInfoCubit>(
      () => _i947.EditVehicleInfoCubit(
        gh<_i151.GetVehiclesUseCase>(),
        gh<_i730.UpdateVehicleUseCase>(),
        gh<_i488.ImagePickerService>(),
      ),
    );
    gh.factory<_i990.EditProfileCubit>(
      () => _i990.EditProfileCubit(
        gh<_i199.EditProfileUseCase>(),
        gh<_i967.UploadPhotoUseCase>(),
        gh<_i790.ProfileRepo>(),
      ),
    );
    gh.factory<_i235.OrderDetailsCubit>(
      () => _i235.OrderDetailsCubit(
        gh<_i753.SaveCurrentOrderUseCase>(),
        gh<_i941.WatchCurrentOrderUseCase>(),
        gh<_i302.CreateNotificationRequestUseCase>(),
        gh<_i141.GetDriverDataUseCase>(),
      ),
    );
    gh.factory<_i158.GetDriverOrdersUseCase>(
      () => _i158.GetDriverOrdersUseCase(gh<_i59.OrderPageRepo>()),
    );
    gh.factory<_i531.HomeCubit>(
      () => _i531.HomeCubit(
        gh<_i945.GetPendingOrdersUseCase>(),
        gh<_i386.UpdateOrderStateUseCase>(),
        gh<_i315.GetCurrentOrderUseCase>(),
      ),
    );
    gh.factory<_i199.OrderUserInfoCubit>(
      () => _i199.OrderUserInfoCubit(gh<_i492.GetOrderUserInfoUseCase>()),
    );
    gh.factory<_i36.ProfileCubit>(
      () => _i36.ProfileCubit(
        gh<_i141.GetDriverDataUseCase>(),
        gh<_i151.GetVehiclesUseCase>(),
      ),
    );
    gh.factory<_i545.AppLaunchCubit>(
      () => _i545.AppLaunchCubit(gh<_i315.GetCurrentOrderUseCase>()),
    );
    gh.factory<_i2.OrderPageCubit>(
      () => _i2.OrderPageCubit(gh<_i158.GetDriverOrdersUseCase>()),
    );
    return this;
  }
}

class _$FirestoreModule extends _i431.FirestoreModule {}

class _$NetworkModule extends _i234.NetworkModule {}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/config/dependency_injection/di.dart';
import 'package:tracking_app/config/routes/routes.dart';
import 'package:tracking_app/core/localization_constants/general_constants.dart';
import 'package:tracking_app/core/localization_constants/profile_constants.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';
import 'package:tracking_app/core/widgets/app_error_widget.dart';
import 'package:tracking_app/core/widgets/app_loading_widget.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';
import 'package:tracking_app/core/widgets/cached_network_image.dart';
import 'package:tracking_app/features/profile/presentation/profile/cubit/profile_cubit.dart';
import 'package:tracking_app/features/profile/presentation/profile/cubit/profile_event.dart';
import 'package:tracking_app/features/profile/presentation/profile/widgets/profile_container.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>()
        ..doEvent(GetDriverDataEvent())
        ..doEvent(GetVehiclesEvent()),
      child: BlocListener<ProfileCubit, ProfileState>(
        listenWhen: (prev, current) =>
            prev.targetLocale != current.targetLocale,
        listener: (context, state) {
          if (state.targetLocale != null) {
            context.setLocale(state.targetLocale!);
          }
        },
        child: BlocListener<ProfileCubit, ProfileState>(
          listenWhen: (prev, current) => !prev.loggedOut && current.loggedOut,
          listener: (context, state) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.onboarding,
              (_) => false,
            );
          },
          child: const _ProfileBody(),
        ),
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(ProfileConstants.title),
        actions: const [Icon(Icons.notifications_none_rounded)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state.driverDataState.isLoading) {
                  return const AppLoadingWidget();
                }
                if (state.driverDataState.errorMessage != null) {
                  return AppErrorWidget(
                    errorMessage: state.driverDataState.errorMessage!,
                    onRetry: () => context.read<ProfileCubit>().doEvent(
                      GetDriverDataEvent(),
                    ),
                    retryButtonText: GeneralConstants.retry,
                  );
                }
                final driverData = state.driverDataState.data;
                if (driverData?.driver == null) {
                  return const SizedBox.shrink();
                }
                final driver = driverData!.driver!;
                return ProfileContainer(
                  onArrowPressed: () {
                    Navigator.pushNamed(context, Routes.editProfile).then((_) {
                      context.read<ProfileCubit>().doEvent(
                        GetDriverDataEvent(),
                      );
                    });
                  },
                  child: Row(
                    children: [
                      driver.photo != null && driver.photo!.isNotEmpty
                          ? CachedNetworkImageWidget(urlToImage: driver.photo!)
                          : CircleAvatar(
                              radius: 30,
                              backgroundColor: AppColors.primary,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                      const AppSizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              driver.name ?? "",
                              style: getSemiBoldStyle(
                                context: context,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              driver.email ?? "",
                              style: getRegularStyle(
                                context: context,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              driver.phone ?? "",
                              style: getRegularStyle(
                                context: context,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const AppSizedBox(height: 16),
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state.vehiclesState.isLoading) {
                  return const AppLoadingWidget();
                }
                if (state.vehiclesState.errorMessage != null) {
                  return AppErrorWidget(
                    errorMessage: state.vehiclesState.errorMessage!,
                    onRetry: () => context.read<ProfileCubit>().doEvent(
                      GetVehiclesEvent(),
                    ),
                    retryButtonText: GeneralConstants.retry,
                  );
                }
                final vehiclesData = state.vehiclesState.data;
                if (vehiclesData?.vehicles == null ||
                    vehiclesData!.vehicles!.isEmpty) {
                  return const SizedBox.shrink();
                }
                final vehicle = vehiclesData.vehicles!.first;
                return ProfileContainer(
                  onArrowPressed: () =>
                      Navigator.pushNamed(context, Routes.editVehicleInfo),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ProfileConstants.vehicleInfo,
                        style: getSemiBoldStyle(
                          context: context,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const AppSizedBox(height: 8),
                      Text(
                        vehicle.type ?? "",
                        style: getRegularStyle(
                          context: context,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const AppSizedBox(height: 24),
            InkWell(
              onTap: () =>
                  context.read<ProfileCubit>().doEvent(ToggleLanguageEvent()),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: [
                    const Icon(
                      Icons.language,
                      color: AppColors.primary,
                      size: 22,
                    ),
                    const AppSizedBox(width: 12),
                    Text(
                      GeneralConstants.language,
                      style: getRegularStyle(
                        context: context,
                        color: AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      context.locale.languageCode == 'en'
                          ? GeneralConstants.english
                          : GeneralConstants.arabic,
                      style: getRegularStyle(
                        context: context,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: AppColors.divider),
            InkWell(
              onTap: () => context.read<ProfileCubit>().doEvent(LogoutEvent()),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: [
                    const Icon(Icons.logout, color: AppColors.error, size: 22),
                    const AppSizedBox(width: 12),
                    Text(
                      ProfileConstants.logout,
                      style: getRegularStyle(
                        context: context,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

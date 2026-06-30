part of 'app_launch_cubit.dart';

sealed class AppLaunchState {}

class AppLaunchLoading extends AppLaunchState {}

class AppLaunchNoOrder extends AppLaunchState {}

class AppLaunchHasOrder extends AppLaunchState {
  final CurrentOrderEntity order;

  AppLaunchHasOrder(this.order);
}

part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final BaseState<ProfileDataResponseEntity> driverDataState;
  final BaseState<AllVehiclesResponseEntity> vehiclesState;
  final Locale? targetLocale;
  final bool loggedOut;

  const ProfileState({
    this.driverDataState = const BaseState(),
    this.vehiclesState = const BaseState(),
    this.targetLocale,
    this.loggedOut = false,
  });

  ProfileState copyWith({
    BaseState<ProfileDataResponseEntity>? driverDataState,
    BaseState<AllVehiclesResponseEntity>? vehiclesState,
    Locale? targetLocale,
    bool? loggedOut,
  }) {
    return ProfileState(
      driverDataState: driverDataState ?? this.driverDataState,
      vehiclesState: vehiclesState ?? this.vehiclesState,
      targetLocale: targetLocale,
      loggedOut: loggedOut ?? this.loggedOut,
    );
  }

  @override
  List<Object?> get props =>
      [driverDataState, vehiclesState, targetLocale, loggedOut];
}

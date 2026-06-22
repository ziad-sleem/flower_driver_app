import 'package:equatable/equatable.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_entity.dart';

class SingleVehicleResponseEntity extends Equatable {
  final String? message;
  final ProfileVehicleEntity? vehicle;

  const SingleVehicleResponseEntity({this.message, this.vehicle});

  @override
  List<Object?> get props => [message, vehicle];
}

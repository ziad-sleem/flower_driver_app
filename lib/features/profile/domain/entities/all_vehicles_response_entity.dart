import 'package:equatable/equatable.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_entity.dart';

class AllVehiclesResponseEntity extends Equatable {
  final String? message;
  final List<VehicleEntity>? vehicles;

  const AllVehiclesResponseEntity({this.message, this.vehicles});

  @override
  List<Object?> get props => [message, vehicles];
}

import 'package:equatable/equatable.dart';
import 'package:tracking_app/features/edit_vehical_info/domain/entities/vehicle_entity.dart';

class VehiclesResponseEntity extends Equatable {
  final String? message;
  final List<VehicleEntity>? vehicles;

  const VehiclesResponseEntity({this.message, this.vehicles});

  @override
  List<Object?> get props => [message, vehicles];
}

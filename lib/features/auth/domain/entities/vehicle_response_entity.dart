import 'package:equatable/equatable.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_entity.dart';

class VehicleResponseEntity extends Equatable {
  final List<VehicleEntity> vehicles;

  const VehicleResponseEntity({
    required this.vehicles,
  });

  @override
  List<Object?> get props => [vehicles];
}
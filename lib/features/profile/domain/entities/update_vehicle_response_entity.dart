import 'package:equatable/equatable.dart';

class UpdateVehicleResponseEntity extends Equatable {
  final String? message;

  const UpdateVehicleResponseEntity({this.message});

  @override
  List<Object?> get props => [message];
}

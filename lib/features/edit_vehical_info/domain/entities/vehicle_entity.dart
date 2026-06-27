import 'package:equatable/equatable.dart';

class VehicleEntity extends Equatable {
  final String? id;
  final String? type;
  final String? image;

  const VehicleEntity({this.id, this.type, this.image});

  @override
  List<Object?> get props => [id, type, image];
}

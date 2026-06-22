import 'package:equatable/equatable.dart';

class ProfileVehicleEntity extends Equatable {
  final String? id;
  final String? type;
  final String? image;

  const ProfileVehicleEntity({this.id, this.type, this.image});

  @override
  List<Object?> get props => [id, type, image];
}

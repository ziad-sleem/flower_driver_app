import 'package:equatable/equatable.dart';
import 'package:tracking_app/features/profile/domain/entities/driver_entity.dart';

class ProfileDataResponseEntity extends Equatable {
  final String? message;
  final ProfileDriverEntity? driver;

  const ProfileDataResponseEntity({this.message, this.driver});

  @override
  List<Object?> get props => [message, driver];
}

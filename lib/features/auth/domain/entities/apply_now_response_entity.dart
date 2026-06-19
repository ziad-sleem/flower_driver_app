import 'package:equatable/equatable.dart';
import 'package:tracking_app/features/auth/domain/entities/driver_entity.dart';

class ApplyNowResponseEntity extends Equatable {
  final String message;
  final DriverEntity driver;
  final String token;

  const ApplyNowResponseEntity({
    required this.message,
    required this.driver,
    required this.token,
  });

  List<Object?> get props => [message, driver, token];
}

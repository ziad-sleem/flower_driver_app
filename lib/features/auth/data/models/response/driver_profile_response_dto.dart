import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/auth/domain/entities/driver_profile_response_entity.dart'
    as entity;
import 'driver_dto.dart';

part 'driver_profile_response_dto.g.dart';

@JsonSerializable()
class DriverProfileResponseDto {
  @JsonKey(name: "message")
  final String? message;

  @JsonKey(name: "driver")
  final DriverDto? driver;

  const DriverProfileResponseDto({this.message, this.driver});

  factory DriverProfileResponseDto.fromJson(Map<String, dynamic> json) =>
      _$DriverProfileResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DriverProfileResponseDtoToJson(this);

  entity.DriverProfileResponseEntity toEntity() {
    return entity.DriverProfileResponseEntity(
      message: message,
      driver: driver?.toEntity(),
    );
  }
}

import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/profile/data/models/driver_dto.dart';
import 'package:tracking_app/features/profile/domain/entities/profile_data_response_entity.dart';

part 'profile_data_response_dto.g.dart';

@JsonSerializable()
class ProfileDataResponseDto {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "driver")
  final ProfileDriverDto? driver;

  ProfileDataResponseDto({this.message, this.driver});

  factory ProfileDataResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDataResponseDtoToJson(this);

  ProfileDataResponseEntity toEntity() {
    return ProfileDataResponseEntity(
      message: message,
      driver: driver?.toEntity(),
    );
  }
}

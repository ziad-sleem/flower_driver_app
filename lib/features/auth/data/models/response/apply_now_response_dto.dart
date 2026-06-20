import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/auth/data/models/response/driver_dto.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_now_response_entity.dart';
part 'apply_now_response_dto.g.dart';

@JsonSerializable()
class ApplyNowResponseDto {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "driver")
  DriverDto? driver;
  @JsonKey(name: "token")
  String? token;

  ApplyNowResponseDto({this.message, this.driver, this.token});

  factory ApplyNowResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ApplyNowResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ApplyNowResponseDtoToJson(this);
  ApplyNowResponseEntity toEntity() => ApplyNowResponseEntity(
    message: message ?? "",
    driver: driver!.toEntity(),
    token: token ?? "",
  );
}

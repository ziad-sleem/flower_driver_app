import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/auth/domain/entities/verify_reset_code_entity.dart';
part 'verify_reset_code_response.g.dart';

@JsonSerializable(createToJson: false)
class VerifyResetCodeResponseDto {
  @JsonKey(name: "status")
  final String? status;

  const VerifyResetCodeResponseDto({this.status});

  factory VerifyResetCodeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$VerifyResetCodeResponseDtoFromJson(json);

  VerifyResetCodeEntity toEntity() {
    if (status == null) {
      throw const FormatException(
        'VerifyResetCodeResponseDto: required field "status" is missing',
      );
    }
    return VerifyResetCodeEntity(status: status!);
  }
}

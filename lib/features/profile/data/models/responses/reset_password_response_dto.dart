import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/profile/domain/entities/reset_password_response_entity.dart';

part 'reset_password_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class ResetPasswordResponseDto {
  final String? message;
  final String? token;

  const ResetPasswordResponseDto({this.message, this.token});

  factory ResetPasswordResponseDto.fromJson(Map<String, dynamic> json) {
    if (json['message'] == null || json['token'] == null) {
      throw ArgumentError(
        'API response is missing required fields "message" and/or "token"',
      );
    }
    return _$ResetPasswordResponseDtoFromJson(json);
  }

  ResetPasswordResponseEntity toEntity() {
    return ResetPasswordResponseEntity(message: message!, token: token!);
  }
}

import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/auth/domain/entities/reset_password_entity.dart';
part 'reset_password_response.g.dart';

@JsonSerializable()
class ResetPasswordResponseDto {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "token")
  final String? token;

  const ResetPasswordResponseDto({this.message, this.token});

  factory ResetPasswordResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordResponseDtoToJson(this);

  ResetPasswordEntity toEntity() {
    return ResetPasswordEntity(message: message ?? '', token: token ?? '');
  }
}

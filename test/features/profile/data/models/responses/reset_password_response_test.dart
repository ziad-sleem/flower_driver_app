import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/profile/data/models/responses/reset_password_response_dto.dart';
import 'package:tracking_app/features/profile/domain/entities/reset_password_response_entity.dart';

void main() {
  group('ResetPasswordResponseDto', () {
    const tMessage = "Password changed";
    const tToken = "new_token_456";
    final tJson = {"message": tMessage, "token": tToken};

    test('fromJson creates correct object', () {
      final response = ResetPasswordResponseDto.fromJson(tJson);
      expect(response.message, tMessage);
      expect(response.token, tToken);
    });

    test('toEntity produces correct entity', () {
      final response = ResetPasswordResponseDto(message: tMessage, token: tToken);
      final entity = response.toEntity();
      expect(entity, isA<ResetPasswordResponseEntity>());
      expect(entity.message, tMessage);
      expect(entity.token, tToken);
    });

    test('fromJson throws ArgumentError when message is null', () {
      expect(
        () => ResetPasswordResponseDto.fromJson({"token": tToken}),
        throwsArgumentError,
      );
    });

    test('fromJson throws ArgumentError when token is null', () {
      expect(
        () => ResetPasswordResponseDto.fromJson({"message": tMessage}),
        throwsArgumentError,
      );
    });

    test('fromJson throws ArgumentError when both fields are null', () {
      expect(
        () => ResetPasswordResponseDto.fromJson({}),
        throwsArgumentError,
      );
    });
  });
}

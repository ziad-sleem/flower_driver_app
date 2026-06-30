import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/profile/data/models/requests/reset_password_request_dto.dart';

void main() {
  group('ResetPasswordRequestDto', () {
    const tPassword = "oldPass123";
    const tNewPassword = "newPass456";
    final tJson = {"password": tPassword, "newPassword": tNewPassword};

    test('fromJson creates correct object', () {
      final request = ResetPasswordRequestDto.fromJson(tJson);
      expect(request.password, tPassword);
      expect(request.newPassword, tNewPassword);
    });

    test('toJson produces correct map', () {
      final request = ResetPasswordRequestDto(
        password: tPassword,
        newPassword: tNewPassword,
      );
      expect(request.toJson(), tJson);
    });

    test('fromJson handles null fields', () {
      expect(
        () => ResetPasswordRequestDto.fromJson({}),
        throwsA(isA<TypeError>()),
      );
    });
  });
}

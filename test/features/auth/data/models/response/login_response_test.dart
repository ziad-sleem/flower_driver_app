import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/auth/data/models/response/login_response.dart';

void main() {
  group('LoginResponse', () {
    const tMessage = "Login successful";
    const tToken = "test_token_123";
    final tJson = {"message": tMessage, "token": tToken};

    test('fromJson creates correct object', () {
      final response = LoginResponse.fromJson(tJson);
      expect(response.message, tMessage);
      expect(response.token, tToken);
    });

    test('toJson produces correct map', () {
      final response = LoginResponse(message: tMessage, token: tToken);
      expect(response.toJson(), tJson);
    });

    test('fromJson handles null fields', () {
      final response = LoginResponse.fromJson({});
      expect(response.message, isNull);
      expect(response.token, isNull);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/auth/data/models/requests/login_request.dart';

void main() {
  group('LoginRequest', () {
    const tEmail = "test@example.com";
    const tPassword = "password123";
    final tJson = {"email": tEmail, "password": tPassword};

    test('fromJson creates correct object', () {
      final request = LoginRequest.fromJson(tJson);
      expect(request.email, tEmail);
      expect(request.password, tPassword);
    });

    test('toJson produces correct map', () {
      final request = LoginRequest(email: tEmail, password: tPassword);
      expect(request.toJson(), tJson);
    });

    test('fromJson handles null fields', () {
      final request = LoginRequest.fromJson({});
      expect(request.email, isNull);
      expect(request.password, isNull);
    });
  });
}

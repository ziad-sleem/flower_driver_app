import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/auth/domain/use_cases/login_params.dart';

void main() {
  group('LoginParams', () {
    const tParams1 = LoginParams(email: "test@example.com", password: "password123");
    const tParams2 = LoginParams(email: "test@example.com", password: "password123");
    const tParams3 = LoginParams(email: "other@example.com", password: "password123");

    test('have correct props', () {
      expect(tParams1.props, [tParams1.email, tParams1.password]);
    });

    test('equality works correctly', () {
      expect(tParams1, equals(tParams2));
      expect(tParams1, isNot(equals(tParams3)));
    });

    test('hashCode is consistent', () {
      expect(tParams1.hashCode, equals(tParams2.hashCode));
      expect(tParams1.hashCode, isNot(equals(tParams3.hashCode)));
    });
  });
}

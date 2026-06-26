import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/profile/domain/entities/driver_entity.dart';

void main() {
  group('ProfileDriverEntity', () {
    group('name getter', () {
      test('returns combined firstName and lastName when both present', () {
        const entity = ProfileDriverEntity(
          firstName: 'John',
          lastName: 'Doe',
        );

        expect(entity.name, 'John Doe');
      });

      test('returns firstName when lastName is null', () {
        const entity = ProfileDriverEntity(firstName: 'John');

        expect(entity.name, 'John');
      });

      test('returns lastName when firstName is null', () {
        const entity = ProfileDriverEntity(lastName: 'Doe');

        expect(entity.name, 'Doe');
      });

      test('returns null when both are null', () {
        const entity = ProfileDriverEntity();

        expect(entity.name, isNull);
      });
    });
  });
}

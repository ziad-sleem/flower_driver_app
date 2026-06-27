import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/profile/data/models/driver_dto.dart';
import 'package:tracking_app/features/profile/domain/entities/driver_entity.dart';

void main() {
  group('ProfileDriverDto', () {
    const tId = "123";
    const tFirstName = "John";
    const tLastName = "Doe";
    const tEmail = "john@example.com";
    const tPhone = "1234567890";
    const tPhoto = "https://example.com/photo.jpg";

    final tJson = {
      "_id": tId,
      "firstName": tFirstName,
      "lastName": tLastName,
      "email": tEmail,
      "phone": tPhone,
      "photo": tPhoto,
    };

    test('fromJson creates correct object', () {
      final dto = ProfileDriverDto.fromJson(tJson);

      expect(dto.id, tId);
      expect(dto.firstName, tFirstName);
      expect(dto.lastName, tLastName);
      expect(dto.email, tEmail);
      expect(dto.phone, tPhone);
      expect(dto.photo, tPhoto);
    });

    test('toJson produces correct map', () {
      final dto = ProfileDriverDto(
        id: tId,
        firstName: tFirstName,
        lastName: tLastName,
        email: tEmail,
        phone: tPhone,
        photo: tPhoto,
      );

      final json = dto.toJson();
      expect(json["_id"], tId);
      expect(json["firstName"], tFirstName);
      expect(json["lastName"], tLastName);
      expect(json["email"], tEmail);
      expect(json["phone"], tPhone);
      expect(json["photo"], tPhoto);
    });

    test('fromJson handles null fields', () {
      final dto = ProfileDriverDto.fromJson({});

      expect(dto.id, isNull);
      expect(dto.firstName, isNull);
      expect(dto.lastName, isNull);
      expect(dto.email, isNull);
      expect(dto.phone, isNull);
      expect(dto.photo, isNull);
    });

    test('toEntity maps all fields correctly', () {
      final dto = ProfileDriverDto(
        id: tId,
        firstName: tFirstName,
        lastName: tLastName,
        email: tEmail,
        phone: tPhone,
        photo: tPhoto,
      );

      final entity = dto.toEntity();

      expect(entity, isA<ProfileDriverEntity>());
      expect(entity.id, tId);
      expect(entity.firstName, tFirstName);
      expect(entity.lastName, tLastName);
      expect(entity.email, tEmail);
      expect(entity.phone, tPhone);
      expect(entity.photo, tPhoto);
    });

    test('toEntity handles null fields', () {
      final dto = ProfileDriverDto();
      final entity = dto.toEntity();

      expect(entity.id, isNull);
      expect(entity.firstName, isNull);
    });
  });
}

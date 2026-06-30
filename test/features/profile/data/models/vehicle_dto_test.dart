import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/profile/data/models/vehicle_dto.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_entity.dart';

void main() {
  group('ProfileVehicleDto', () {
    const tId = "1";
    const tType = "car";
    const tImage = "https://example.com/car.jpg";

    final tJson = {
      "_id": tId,
      "type": tType,
      "image": tImage,
    };

    test('fromJson creates correct object', () {
      final dto = ProfileVehicleDto.fromJson(tJson);

      expect(dto.id, tId);
      expect(dto.type, tType);
      expect(dto.image, tImage);
    });

    test('toJson produces correct map', () {
      final dto = ProfileVehicleDto(
        id: tId,
        type: tType,
        image: tImage,
      );

      final json = dto.toJson();
      expect(json["_id"], tId);
      expect(json["type"], tType);
      expect(json["image"], tImage);
    });

    test('fromJson handles null fields', () {
      final dto = ProfileVehicleDto.fromJson({});

      expect(dto.id, isNull);
      expect(dto.type, isNull);
      expect(dto.image, isNull);
    });

    test('toEntity maps all fields correctly', () {
      final dto = ProfileVehicleDto(
        id: tId,
        type: tType,
        image: tImage,
      );

      final entity = dto.toEntity();

      expect(entity, isA<ProfileVehicleEntity>());
      expect(entity.id, tId);
      expect(entity.type, tType);
      expect(entity.image, tImage);
    });

    test('toEntity handles null fields', () {
      final dto = ProfileVehicleDto();
      final entity = dto.toEntity();

      expect(entity.id, isNull);
      expect(entity.type, isNull);
      expect(entity.image, isNull);
    });
  });
}

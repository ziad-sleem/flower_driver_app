import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/profile/data/models/driver_dto.dart';
import 'package:tracking_app/features/profile/data/models/responses/profile_data_response_dto.dart';
import 'package:tracking_app/features/profile/domain/entities/profile_data_response_entity.dart';

void main() {
  group('ProfileDataResponseDto', () {
    const tMessage = "success";
    final tDriverDto = ProfileDriverDto(
      id: "1",
      firstName: "John",
      email: "john@example.com",
    );

    final tJson = {
      "message": tMessage,
      "driver": {
        "_id": "1",
        "firstName": "John",
        "email": "john@example.com",
      },
    };

    test('fromJson creates correct object', () {
      final response = ProfileDataResponseDto.fromJson(tJson);

      expect(response.message, tMessage);
      expect(response.driver, isA<ProfileDriverDto>());
      expect(response.driver?.id, "1");
      expect(response.driver?.firstName, "John");
    });

    test('toJson produces correct map', () {
      final response = ProfileDataResponseDto(
        message: tMessage,
        driver: tDriverDto,
      );

      final json = response.toJson();
      expect(json["message"], tMessage);
      expect(json["driver"], tDriverDto);
    });

    test('fromJson handles null fields', () {
      final response = ProfileDataResponseDto.fromJson({});

      expect(response.message, isNull);
      expect(response.driver, isNull);
    });

    test('toEntity maps correctly', () {
      final response = ProfileDataResponseDto(
        message: tMessage,
        driver: tDriverDto,
      );

      final entity = response.toEntity();

      expect(entity, isA<ProfileDataResponseEntity>());
      expect(entity.message, tMessage);
      expect(entity.driver?.id, "1");
      expect(entity.driver?.firstName, "John");
    });

    test('toEntity handles null driver', () {
      final response = ProfileDataResponseDto(message: tMessage);

      final entity = response.toEntity();

      expect(entity.message, tMessage);
      expect(entity.driver, isNull);
    });
  });
}

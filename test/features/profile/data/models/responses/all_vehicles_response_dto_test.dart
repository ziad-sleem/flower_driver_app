import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/profile/data/models/vehicle_dto.dart';
import 'package:tracking_app/features/profile/data/models/responses/all_vehicles_response_dto.dart';
import 'package:tracking_app/features/profile/domain/entities/all_vehicles_response_entity.dart';

void main() {
  group('AllVehiclesResponseDto', () {
    const tMessage = "success";
    final tVehicles = <VehicleDto>[
      VehicleDto(id: "1", type: "car", image: "car.jpg"),
      VehicleDto(id: "2", type: "truck", image: "truck.jpg"),
    ];

    final tJson = {
      "message": tMessage,
      "vehicles": [
        {"_id": "1", "type": "car", "image": "car.jpg"},
        {"_id": "2", "type": "truck", "image": "truck.jpg"},
      ],
    };

    test('fromJson creates correct object', () {
      final response = AllVehiclesResponseDto.fromJson(tJson);

      expect(response.message, tMessage);
      expect(response.vehicles, hasLength(2));
      expect(response.vehicles?.first.id, "1");
      expect(response.vehicles?.first.type, "car");
    });

    test('toJson produces correct map', () {
      final response = AllVehiclesResponseDto(
        message: tMessage,
        vehicles: tVehicles,
      );

      final json = response.toJson();
      expect(json["message"], tMessage);
      expect(json["vehicles"], tVehicles);
    });

    test('fromJson handles null fields', () {
      final response = AllVehiclesResponseDto.fromJson({});

      expect(response.message, isNull);
      expect(response.vehicles, isNull);
    });

    test('toEntity maps correctly', () {
      final response = AllVehiclesResponseDto(
        message: tMessage,
        vehicles: tVehicles,
      );

      final entity = response.toEntity();

      expect(entity, isA<AllVehiclesResponseEntity>());
      expect(entity.message, tMessage);
      expect(entity.vehicles, hasLength(2));
      expect(entity.vehicles?.first.id, "1");
      expect(entity.vehicles?.first.type, "car");
    });

    test('toEntity handles null vehicles', () {
      final response = AllVehiclesResponseDto(message: tMessage);

      final entity = response.toEntity();

      expect(entity.message, tMessage);
      expect(entity.vehicles, isNull);
    });
  });
}

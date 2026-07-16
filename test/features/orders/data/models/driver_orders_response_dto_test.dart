import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/orders/data/models/driver_orders_response_dto.dart';
import 'package:tracking_app/features/orders/domain/entities/driver_orders_response_entity.dart';

void main() {
  group('DriverOrdersResponseDto', () {
    final tJson = {
      "message": "success",
      "metadata": {
        "currentPage": 1,
        "totalPages": 1,
        "totalItems": 2,
        "limit": 1000,
      },
      "orders": [
        {
          "_id": "6a3cb1ca992612ae599b4691",
          "driver": "6a3678a3992612ae599afc38",
          "order": {"_id": "69e5f1996bbaf1588bbcd6ba", "state": "completed"},
          "store": {"name": "Elevate FlowerApp Store"},
        },
        {
          "_id": "6a3ff421992612ae599bb070",
          "driver": "6a3678a3992612ae599afc38",
          "order": {"_id": "69e5f1996bbaf1588bbcd6ba", "state": "completed"},
          "store": {"name": "Elevate FlowerApp Store"},
        },
      ],
    };

    test('fromJson parses message, metadata, and the orders list', () {
      final dto = DriverOrdersResponseDto.fromJson(tJson);

      expect(dto.message, "success");
      expect(dto.metadata?.currentPage, 1);
      expect(dto.metadata?.totalItems, 2);
      expect(dto.orders, hasLength(2));
    });

    test('fromJson handles an empty orders list', () {
      final dto = DriverOrdersResponseDto.fromJson({
        "message": "success",
        "metadata": {
          "currentPage": 1,
          "totalPages": 0,
          "totalItems": 0,
          "limit": 1000,
        },
        "orders": [],
      });

      expect(dto.orders, isEmpty);
    });

    test('toEntity maps message, metadata, and each order to entities', () {
      final dto = DriverOrdersResponseDto.fromJson(tJson);

      final entity = dto.toEntity();

      expect(entity, isA<DriverOrdersResponseEntity>());
      expect(entity.message, "success");
      expect(entity.metadata?.totalItems, 2);
      expect(entity.orders, hasLength(2));
      expect(entity.orders?.first.id, "6a3cb1ca992612ae599b4691");
    });

    test('toJson round-trips the top-level fields', () {
      final dto = DriverOrdersResponseDto.fromJson(tJson);

      final json = dto.toJson();

      expect(json["message"], "success");
      expect(json["metadata"], isNotNull);
      expect(json["orders"], hasLength(2));
    });
  });
}

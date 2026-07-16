import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_details_response_entity.dart';
import 'package:tracking_app/features/orders/data/models/driver_order_dto.dart';
import 'package:tracking_app/features/orders/domain/entities/driver_order_entity.dart';

void main() {
  group('DriverOrderDto', () {
    final tJson = {
      "_id": "6a3cb1ca992612ae599b4691",
      "driver": "6a3678a3992612ae599afc38",
      "order": {
        "_id": "69e5f1996bbaf1588bbcd6ba",
        "orderItems": [],
        "totalPrice": 198.4,
        "paymentType": "cash",
        "isPaid": false,
        "isDelivered": false,
        "state": "completed",
        "createdAt": "2026-04-20T09:27:53.157Z",
        "updatedAt": "2026-06-27T16:02:41.816Z",
        "orderNumber": "#123539",
        "__v": 0,
      },
      "store": {
        "name": "Elevate FlowerApp Store",
        "image": "https://www.elevateegy.com/elevate.png",
        "address": "123 Fixed Address, City, Country",
        "phoneNumber": "1234567890",
        "latLong": "37.7749,-122.4194",
      },
      "createdAt": "2026-06-25T04:42:50.610Z",
      "updatedAt": "2026-06-25T04:42:50.610Z",
    };

    test('fromJson parses the wrapper fields and the nested order/store', () {
      final dto = DriverOrderDto.fromJson(tJson);

      expect(dto.id, "6a3cb1ca992612ae599b4691");
      expect(dto.driverId, "6a3678a3992612ae599afc38");
      expect(dto.order?.id, "69e5f1996bbaf1588bbcd6ba");
      expect(dto.order?.orderNumber, "#123539");
      expect(dto.order?.totalPrice, 198.4);
      expect(dto.store?.name, "Elevate FlowerApp Store");
      expect(dto.store?.address, "123 Fixed Address, City, Country");
      expect(dto.createdAt, DateTime.parse("2026-06-25T04:42:50.610Z"));
    });

    test('fromJson handles missing fields without throwing', () {
      final dto = DriverOrderDto.fromJson({});

      expect(dto.id, isNull);
      expect(dto.order, isNull);
      expect(dto.store, isNull);
    });

    test('toEntity maps to a DriverOrderEntity with the mapped order state', () {
      final dto = DriverOrderDto.fromJson(tJson);

      final entity = dto.toEntity();

      expect(entity, isA<DriverOrderEntity>());
      expect(entity.id, "6a3cb1ca992612ae599b4691");
      expect(entity.driverId, "6a3678a3992612ae599afc38");
      expect(entity.order?.state, OrderState.completed);
      expect(entity.order?.orderNumber, "#123539");
      expect(entity.store?.name, "Elevate FlowerApp Store");
    });

    test('toJson round-trips the wrapper fields', () {
      final dto = DriverOrderDto.fromJson(tJson);

      final json = dto.toJson();

      expect(json["_id"], "6a3cb1ca992612ae599b4691");
      expect(json["driver"], "6a3678a3992612ae599afc38");
      expect(json["order"], isNotNull);
      expect(json["store"], isNotNull);
    });
  });
}

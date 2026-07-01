import 'package:tracking_app/config/mapper/order_firestore_mapper.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/current_order_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';

class CurrentOrderModel {
  final String driverId;
  final String state;
  final bool driverRequestedDelivery;
  final OrderEntity order;

  const CurrentOrderModel({
    required this.driverId,
    required this.state,
    required this.driverRequestedDelivery,
    required this.order,
  });

  factory CurrentOrderModel.fromJson(Map<String, dynamic> json) {
    return CurrentOrderModel(
      driverId: json["driverId"] as String,
      state: json["state"] as String,
      driverRequestedDelivery:
          json["driverRequestedDelivery"] as bool? ?? false,
      order: OrderFirestoreMapper.fromFirestore(
        json["order"] as Map<String, dynamic>,
      ),
    );
  }

  CurrentOrderEntity toEntity() {
    return CurrentOrderEntity(
      driverId: driverId,
      state: state,
      driverRequestedDelivery: driverRequestedDelivery,
      order: order,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "driverId": driverId,
      "state": state,
      "driverRequestedDelivery": driverRequestedDelivery,
      "order": OrderFirestoreMapper.toFirestore(order),
    };
  }
}

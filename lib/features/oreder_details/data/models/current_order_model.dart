import 'package:tracking_app/config/mapper/order_firestore_mapper.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/current_order_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';

class CurrentOrderModel {
  final String? driverId;
  final String state;
  final bool driverRequestedDelivery;
  final OrderEntity order;
  final double? userLat;
  final double? userLong;
  final String? driverName;
  final String? driverPhone;
  final String? vehicleType;
  final String? vehicleNumber;
  final String? vehicleLicense;

  const CurrentOrderModel({
    this.driverId,
    required this.state,
    required this.driverRequestedDelivery,
    required this.order,
    this.userLat,
    this.userLong,
    this.driverName,
    this.driverPhone,
    this.vehicleType,
    this.vehicleNumber,
    this.vehicleLicense,
  });

  factory CurrentOrderModel.fromJson(Map<String, dynamic> json) {
    return CurrentOrderModel(
      driverId: json["driverId"] as String?,
      state: json["state"] as String,
      driverRequestedDelivery:
          json["driverRequestedDelivery"] as bool? ?? false,
      order: OrderFirestoreMapper.fromFirestore(
        json["order"] as Map<String, dynamic>,
      ),
      userLat: (json["userLat"] as num?)?.toDouble(),
      userLong: (json["userLong"] as num?)?.toDouble(),
      driverName: json["driverName"] as String?,
      driverPhone: json["driverPhone"] as String?,
      vehicleType: json["vehicleType"] as String?,
      vehicleNumber: json["vehicleNumber"] as String?,
      vehicleLicense: json["vehicleLicense"] as String?,
    );
  }

  CurrentOrderEntity toEntity() {
    return CurrentOrderEntity(
      state: state,
      driverRequestedDelivery: driverRequestedDelivery,
      order: order,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "state": state,
      "driverRequestedDelivery": driverRequestedDelivery,
      "order": OrderFirestoreMapper.toFirestore(order),
      if (driverId != null) "driverId": driverId,
      if (userLat != null) "userLat": userLat,
      if (userLong != null) "userLong": userLong,
      if (driverName != null) "driverName": driverName,
      if (driverPhone != null) "driverPhone": driverPhone,
      if (vehicleType != null) "vehicleType": vehicleType,
      if (vehicleNumber != null) "vehicleNumber": vehicleNumber,
      if (vehicleLicense != null) "vehicleLicense": vehicleLicense,
    };
  }
}

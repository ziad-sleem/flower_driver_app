import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracking_app/config/mapper/order_firestore_mapper.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';

class OrderHistoryModel {
  final String driverId;
  final String status;
  final OrderEntity order;
  final DateTime finishedAt;

  const OrderHistoryModel({
    required this.driverId,
    required this.status,
    required this.order,
    required this.finishedAt,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    return OrderHistoryModel(
      driverId: json["driverId"] as String,
      status: json["status"] as String,
      order: OrderFirestoreMapper.fromFirestore(
        json["order"] as Map<String, dynamic>,
      ),
      finishedAt: (json["finishedAt"] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "driverId": driverId,
      "status": status,
      "order": OrderFirestoreMapper.toFirestore(order),
      "finishedAt": Timestamp.fromDate(finishedAt),
    };
  }
}

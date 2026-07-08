import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/oreder_details/data/datasources/order_details_firestore_data_source.dart';
import 'package:tracking_app/features/oreder_details/data/models/current_order_model.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';

@Injectable(as: OrderDetailsFireStoreDataSource)
class OrderDetailsFireStoreDataSourceImpl
    implements OrderDetailsFireStoreDataSource {
  final FirebaseFirestore firestore;

  OrderDetailsFireStoreDataSourceImpl(this.firestore);

  static const _collection = "current_orders";

  @override
  Future<void> saveCurrentOrder({
    required OrderEntity order,
    required String state,
    required bool driverRequestedDelivery,
    String? driverId,
    double? userLat,
    double? userLong,
    String? driverName,
    String? driverPhone,
    String? vehicleType,
    String? vehicleNumber,
    String? vehicleLicense,
  }) async {
    final model = CurrentOrderModel(
      driverId: driverId,
      state: state,
      driverRequestedDelivery: driverRequestedDelivery,
      order: order,
      userLat: userLat,
      userLong: userLong,
      driverName: driverName,
      driverPhone: driverPhone,
      vehicleType: vehicleType,
      vehicleNumber: vehicleNumber,
      vehicleLicense: vehicleLicense,
    );

    final orderId = order.id ?? '';
    await firestore.collection(_collection).doc(orderId).set(model.toJson());
  }

  @override
  Future<void> deleteCurrentOrder({required String orderId}) async {
    await firestore.collection(_collection).doc(orderId).delete();
  }

  @override
  Stream<CurrentOrderModel?> watchCurrentOrder({required String orderId}) {
    return firestore.collection(_collection).doc(orderId).snapshots().map((
      snapshot,
    ) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }

      return CurrentOrderModel.fromJson(snapshot.data()!);
    });
  }

  @override
  Future<CurrentOrderModel?> getCurrentOrder({required String orderId}) async {
    final snapshot = await firestore
        .collection(_collection)
        .doc(orderId)
        .get();

    if (!snapshot.exists) {
      return null;
    }

    final data = snapshot.data();

    if (data == null) {
      return null;
    }

    return CurrentOrderModel.fromJson(data);
  }
}

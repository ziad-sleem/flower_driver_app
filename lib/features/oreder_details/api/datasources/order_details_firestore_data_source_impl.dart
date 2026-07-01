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
    required String driverId,
    required OrderEntity order,
    required String state,
    required bool driverRequestedDelivery,
  }) async {
    final model = CurrentOrderModel(
      driverId: driverId,
      state: state,
      driverRequestedDelivery: driverRequestedDelivery,
      order: order,
    );

    await firestore.collection(_collection).doc(driverId).set(model.toJson());
  }

  @override
  Future<void> deleteCurrentOrder({required String driverId}) async {
    await firestore.collection(_collection).doc(driverId).delete();
  }

  @override
  Stream<CurrentOrderModel?> watchCurrentOrder({required String driverId}) {
    return firestore.collection(_collection).doc(driverId).snapshots().map((
      snapshot,
    ) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }

      return CurrentOrderModel.fromJson(snapshot.data()!);
    });
  }

  @override
  Future<CurrentOrderModel?> getCurrentOrder({required String driverId}) async {
    final snapshot = await firestore
        .collection(_collection)
        .doc(driverId)
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

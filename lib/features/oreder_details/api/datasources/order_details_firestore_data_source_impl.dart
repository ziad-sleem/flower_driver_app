import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/oreder_details/data/datasources/order_details_firestore_data_source.dart';

@Injectable(as: OrderDetailsFireStoreDataSource)
class OrderDetailsFireStoreDataSourceImpl
    implements OrderDetailsFireStoreDataSource {
  final FirebaseFirestore firestore;

  OrderDetailsFireStoreDataSourceImpl(this.firestore);

  static const _collection = "current_orders";

  @override
  Future<void> saveCurrentOrder({
    required String driverId,
    required String orderId,
    required String state,
  }) async {
    await firestore.collection(_collection).doc(driverId).set({
      "driverId": driverId,
      "orderId": orderId,
      "state": state,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteCurrentOrder({required String driverId}) async {
    await firestore.collection(_collection).doc(driverId).delete();
  }

  @override
  Stream<String?> watchOrderState({required String driverId}) {
    return firestore
        .collection(_collection)
        .doc(driverId)
        .snapshots()
        .map((snapshot) => snapshot.data()?["state"] as String?);
  }
}

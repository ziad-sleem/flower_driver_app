import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:tracking_app/features/oreder_details/data/datasources/order_details_firestore_data_source.dart';
import 'package:tracking_app/features/oreder_details/data/models/current_order_model.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';

@Injectable(as: OrderDetailsFireStoreDataSource)
class OrderDetailsFireStoreDataSourceImpl
    implements OrderDetailsFireStoreDataSource {
  final FirebaseFirestore firestore;
  final Logger _logger;

  OrderDetailsFireStoreDataSourceImpl(this.firestore) : _logger = Logger();

  static const _collection = "current_orders";

  @override
  Future<void> saveCurrentOrder({
    required OrderEntity order,
    required String state,
    required bool driverRequestedDelivery,
    String? driverId,
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
      driverName: driverName,
      driverPhone: driverPhone,
      vehicleType: vehicleType,
      vehicleNumber: vehicleNumber,
      vehicleLicense: vehicleLicense,
    );

    final orderId = order.id ?? '';
    _logger.i('saveCurrentOrder: Saving order $orderId with state $state');
    try {
      await firestore.collection(_collection).doc(orderId).set(model.toJson());
      _logger.i('saveCurrentOrder: Successfully saved order $orderId');
    } catch (e) {
      _logger.e('saveCurrentOrder: Failed to save order $orderId — $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteCurrentOrder({required String orderId}) async {
    _logger.i('deleteCurrentOrder: Deleting order $orderId');
    try {
      await firestore.collection(_collection).doc(orderId).delete();
      _logger.i('deleteCurrentOrder: Successfully deleted order $orderId');
    } catch (e) {
      _logger.e('deleteCurrentOrder: Failed to delete order $orderId — $e');
      rethrow;
    }
  }

  @override
  Stream<CurrentOrderModel?> watchCurrentOrder({required String orderId}) {
    _logger.i('watchCurrentOrder: Watching order $orderId');
    return firestore.collection(_collection).doc(orderId).snapshots().map((
      snapshot,
    ) {
      if (!snapshot.exists || snapshot.data() == null) {
        _logger.w('watchCurrentOrder: Order $orderId not found or has no data');
        return null;
      }
      _logger.i('watchCurrentOrder: Order $orderId snapshot received');
      return CurrentOrderModel.fromJson(snapshot.data()!);
    });
  }

  @override
  Future<CurrentOrderModel?> getCurrentOrder({required String orderId}) async {
    _logger.i('getCurrentOrder: Fetching order $orderId');
    try {
      final snapshot = await firestore
          .collection(_collection)
          .doc(orderId)
          .get();

      if (!snapshot.exists) {
        _logger.w('getCurrentOrder: Order $orderId does not exist');
        return null;
      }

      final data = snapshot.data();

      if (data == null) {
        _logger.w('getCurrentOrder: Order $orderId exists but data is null');
        return null;
      }

      _logger.i('getCurrentOrder: Successfully fetched order $orderId');
      return CurrentOrderModel.fromJson(data);
    } catch (e) {
      _logger.e('getCurrentOrder: Failed to fetch order $orderId — $e');
      rethrow;
    }
  }
}

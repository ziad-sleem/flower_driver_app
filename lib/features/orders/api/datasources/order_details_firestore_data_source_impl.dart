import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:tracking_app/features/orders/data/datasources/order_details_firestore_data_source.dart';
import 'package:tracking_app/features/orders/data/models/current_order_model.dart';
import 'package:tracking_app/features/orders/domain/entities/order_entity.dart';

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

  static const _driverLocationsCollection = "driver_locations";

  @override
  Future<void> setDriverLocation({
    required String orderId,
    required double latitude,
    required double longitude,
  }) async {
    _logger.i('setDriverLocation: Updating location for order $orderId');
    try {
      await firestore
          .collection(_driverLocationsCollection)
          .doc(orderId)
          .set({
            'latitude': latitude,
            'longitude': longitude,
            'orderId': orderId,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
      _logger.i('setDriverLocation: Success for order $orderId');
    } catch (e) {
      _logger.e('setDriverLocation: Failed for order $orderId — $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteDriverLocation({required String orderId}) async {
    _logger.i('deleteDriverLocation: Deleting location for order $orderId');
    try {
      await firestore
          .collection(_driverLocationsCollection)
          .doc(orderId)
          .delete();
      _logger.i('deleteDriverLocation: Success for order $orderId');
    } catch (e) {
      _logger.e('deleteDriverLocation: Failed for order $orderId — $e');
      rethrow;
    }
  }

  @override
  Future<List<CurrentOrderModel>> getAllCurrentOrders() async {
    _logger.i('getAllCurrentOrders: Fetching all current orders');
    try {
      final snapshot = await firestore.collection(_collection).get();
      final orders = snapshot.docs
          .where((doc) => doc.data().isNotEmpty)
          .map((doc) => CurrentOrderModel.fromJson(doc.data()))
          .toList();
      _logger.i(
        'getAllCurrentOrders: Successfully fetched ${orders.length} orders',
      );
      return orders;
    } catch (e) {
      _logger.e('getAllCurrentOrders: Failed — $e');
      rethrow;
    }
  }

  static const _historyCollection = "order_history";

  @override
  Future<void> saveOrderHistory({
    required OrderEntity order,
    required String state,
    String? driverId,
  }) async {
    final model = CurrentOrderModel(
      driverId: driverId,
      state: state,
      driverRequestedDelivery: false,
      order: order,
    );

    final orderId = order.id ?? '';
    _logger.i('saveOrderHistory: Saving order $orderId with state $state');
    try {
      await firestore
          .collection(_historyCollection)
          .doc(orderId)
          .set(model.toJson());
      _logger.i('saveOrderHistory: Successfully saved order $orderId');
    } catch (e) {
      _logger.e('saveOrderHistory: Failed to save order $orderId — $e');
      rethrow;
    }
  }

  @override
  Future<List<CurrentOrderModel>> getAllOrderHistory() async {
    _logger.i('getAllOrderHistory: Fetching all order history');
    try {
      final snapshot = await firestore.collection(_historyCollection).get();
      final orders = snapshot.docs
          .where((doc) => doc.data().isNotEmpty)
          .map((doc) => CurrentOrderModel.fromJson(doc.data()))
          .toList();
      _logger.i(
        'getAllOrderHistory: Successfully fetched ${orders.length} orders',
      );
      return orders;
    } catch (e) {
      _logger.e('getAllOrderHistory: Failed — $e');
      rethrow;
    }
  }
}

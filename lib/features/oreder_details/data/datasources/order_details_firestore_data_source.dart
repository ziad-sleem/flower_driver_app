import 'package:tracking_app/features/oreder_details/data/models/current_order_model.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';

abstract class OrderDetailsFireStoreDataSource {
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
  });

  Future<void> deleteCurrentOrder({required String orderId});

  Stream<CurrentOrderModel?> watchCurrentOrder({required String orderId});

  Future<CurrentOrderModel?> getCurrentOrder({required String orderId});

  Future<void> setDriverLocation({
    required String orderId,
    required double latitude,
    required double longitude,
  });

  Future<void> deleteDriverLocation({required String orderId});
}

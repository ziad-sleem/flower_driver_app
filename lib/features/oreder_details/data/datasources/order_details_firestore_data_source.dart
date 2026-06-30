import 'package:tracking_app/features/oreder_details/data/models/current_order_model.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';

abstract class OrderDetailsFireStoreDataSource {
  Future<void> saveCurrentOrder({
    required String driverId,
    required OrderEntity order,
    required String state,
    required bool driverRequestedDelivery,
  });

  Future<void> deleteCurrentOrder({required String driverId});

  Stream<CurrentOrderModel?> watchCurrentOrder({required String driverId});

  Future<CurrentOrderModel?> getCurrentOrder({required String driverId});
}

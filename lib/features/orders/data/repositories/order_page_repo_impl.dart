import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/error/error_handler.dart';
import 'package:tracking_app/features/orders/data/datasources/order_page_firestore_data_source.dart';
import 'package:tracking_app/features/orders/domain/entities/driver_order_entity.dart';
import 'package:tracking_app/features/orders/domain/entities/driver_orders_response_entity.dart';
import 'package:tracking_app/features/orders/domain/repositories/order_page_repo.dart';

@Injectable(as: OrderPageRepo)
class OrderPageRepoImpl implements OrderPageRepo {
  final OrderPageFirestoreDataSourceContract firestoreDataSource;
  final Logger _logger;

  OrderPageRepoImpl({required this.firestoreDataSource})
      : _logger = Logger();

  @override
  Future<BaseResponse<DriverOrdersResponseEntity>> getDriverOrders() async {
    try {
      final results = await Future.wait([
        firestoreDataSource.getAllCurrentOrders(),
        firestoreDataSource.getAllOrderHistory(),
      ]);

      final currentOrders = results[0];
      final historyOrders = results[1];

      final driverOrders = <DriverOrderEntity>[];

      for (final currentOrder in currentOrders) {
        final order = currentOrder.order;
        driverOrders.add(
          DriverOrderEntity(
            id: order.id,
            driverId: currentOrder.driverId,
            order: order,
            store: order.store,
            createdAt: order.createdAt,
            updatedAt: order.updatedAt,
          ),
        );
      }

      for (final historyOrder in historyOrders) {
        final order = historyOrder.order;
        driverOrders.add(
          DriverOrderEntity(
            id: order.id,
            driverId: historyOrder.driverId,
            order: order,
            store: order.store,
            createdAt: order.createdAt,
            updatedAt: order.updatedAt,
          ),
        );
      }

      driverOrders.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });

      return SuccessBaseResponse(
        data: DriverOrdersResponseEntity(
          message: 'Success',
          orders: driverOrders,
        ),
      );
    } catch (e) {
      _logger.e('getDriverOrders: Failed — $e');
      return ErrorBaseResponse(
        failure: Failure(message: e.toString()),
      );
    }
  }
}

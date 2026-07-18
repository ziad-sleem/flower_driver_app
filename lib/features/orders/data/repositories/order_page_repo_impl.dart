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
      final currentOrders = await firestoreDataSource.getAllCurrentOrders();

      final driverOrders = currentOrders.map((currentOrder) {
        final order = currentOrder.order;
        return DriverOrderEntity(
          id: order.id,
          driverId: currentOrder.driverId,
          order: order,
          store: order.store,
          createdAt: order.createdAt,
          updatedAt: order.updatedAt,
        );
      }).toList();

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

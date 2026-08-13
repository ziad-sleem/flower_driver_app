import 'package:tracking_app/features/orders/data/models/current_order_model.dart';

abstract interface class OrderPageFirestoreDataSourceContract {
  Future<List<CurrentOrderModel>> getAllCurrentOrders();
  Future<List<CurrentOrderModel>> getAllOrderHistory();
}

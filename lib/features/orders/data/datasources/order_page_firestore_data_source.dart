import 'package:tracking_app/features/oreder_details/data/models/current_order_model.dart';

abstract interface class OrderPageFirestoreDataSourceContract {
  Future<List<CurrentOrderModel>> getAllCurrentOrders();
}

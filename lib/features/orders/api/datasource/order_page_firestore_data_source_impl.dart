import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/oreder_details/data/datasources/order_details_firestore_data_source.dart';
import 'package:tracking_app/features/oreder_details/data/models/current_order_model.dart';
import 'package:tracking_app/features/orders/data/datasources/order_page_firestore_data_source.dart';

@LazySingleton(as: OrderPageFirestoreDataSourceContract)
class OrderPageFirestoreDataSourceImpl
    implements OrderPageFirestoreDataSourceContract {
  final OrderDetailsFireStoreDataSource _firestoreDataSource;

  OrderPageFirestoreDataSourceImpl(this._firestoreDataSource);

  @override
  Future<List<CurrentOrderModel>> getAllCurrentOrders() {
    return _firestoreDataSource.getAllCurrentOrders();
  }
}

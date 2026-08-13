import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:tracking_app/features/orders/data/datasources/order_user_info_remote_data_source.dart';
import 'package:tracking_app/features/orders/data/models/order_user_info_model.dart';

@LazySingleton(as: OrderUserInfoRemoteDataSourceContract)
class OrderUserInfoRemoteDataSourceImpl
    implements OrderUserInfoRemoteDataSourceContract {
  final FirebaseFirestore firestore;
  final Logger _logger;

  OrderUserInfoRemoteDataSourceImpl({required this.firestore})
      : _logger = Logger();

  static const _collection = "order's_user_info";

  @override
  Future<List<OrderUserInfoModel>> getOrderUserInfo() async {
    _logger.i('getOrderUserInfo: Fetching all order user info');
    try {
      final snapshot = await firestore.collection(_collection).get();
      final result = snapshot.docs
          .map((doc) => OrderUserInfoModel.fromMap(doc.data(), doc.id))
          .toList();
      _logger.i('getOrderUserInfo: Fetched ${result.length} records');
      return result;
    } catch (e) {
      _logger.e('getOrderUserInfo: Failed to fetch order user info — $e');
      rethrow;
    }
  }
}

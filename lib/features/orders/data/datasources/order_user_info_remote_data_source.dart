import 'package:tracking_app/features/orders/data/models/order_user_info_model.dart';

abstract class OrderUserInfoRemoteDataSourceContract {
  Future<List<OrderUserInfoModel>> getOrderUserInfo();
}

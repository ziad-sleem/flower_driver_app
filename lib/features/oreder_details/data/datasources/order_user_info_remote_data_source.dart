import 'package:tracking_app/features/oreder_details/data/models/order_user_info_model.dart';

abstract class OrderUserInfoRemoteDataSourceContract {
  Future<List<OrderUserInfoModel>> getOrderUserInfo();
}

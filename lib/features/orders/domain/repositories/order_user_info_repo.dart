import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/orders/data/models/order_user_info_model.dart';

abstract class OrderUserInfoRepo {
  Future<BaseResponse<List<OrderUserInfoModel>>> getOrderUserInfo();
}

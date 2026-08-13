import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/error/error_handler.dart';
import 'package:tracking_app/features/orders/data/datasources/order_user_info_remote_data_source.dart';
import 'package:tracking_app/features/orders/data/models/order_user_info_model.dart';
import 'package:tracking_app/features/orders/domain/repositories/order_user_info_repo.dart';

@LazySingleton(as: OrderUserInfoRepo)
class OrderUserInfoRepoImpl implements OrderUserInfoRepo {
  final OrderUserInfoRemoteDataSourceContract dataSource;

  OrderUserInfoRepoImpl(this.dataSource);

  @override
  Future<BaseResponse<List<OrderUserInfoModel>>> getOrderUserInfo() async {
    try {
      final data = await dataSource.getOrderUserInfo();
      return SuccessBaseResponse(data: data);
    } catch (error) {
      final failure = ErrorHandler.handle(error);
      return ErrorBaseResponse(failure: failure);
    }
  }
}

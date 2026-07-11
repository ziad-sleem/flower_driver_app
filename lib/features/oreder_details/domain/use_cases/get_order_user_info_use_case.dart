import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/oreder_details/data/models/order_user_info_model.dart';
import 'package:tracking_app/features/oreder_details/domain/repositories/order_user_info_repo.dart';

@injectable
class GetOrderUserInfoUseCase {
  final OrderUserInfoRepo _repo;

  GetOrderUserInfoUseCase(this._repo);

  Future<BaseResponse<List<OrderUserInfoModel>>> call() =>
      _repo.getOrderUserInfo();
}

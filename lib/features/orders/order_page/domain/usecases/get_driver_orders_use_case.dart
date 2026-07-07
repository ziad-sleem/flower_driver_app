import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/orders/order_page/domain/entities/driver_orders_response_entity.dart';
import 'package:tracking_app/features/orders/order_page/domain/repositories/order_page_repo.dart';

@injectable
class GetDriverOrdersUseCase {
  final OrderPageRepo repository;

  GetDriverOrdersUseCase(this.repository);

  Future<BaseResponse<DriverOrdersResponseEntity>> call({
    required int page,
    required int limit,
  }) {
    return repository.getDriverOrders(page: page, limit: limit);
  }
}

import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/orders/domain/entities/driver_orders_response_entity.dart';
import 'package:tracking_app/features/orders/domain/repositories/order_page_repo.dart';

@injectable
class GetDriverOrdersUseCase {
  final OrderPageRepo repository;

  GetDriverOrdersUseCase(this.repository);

  Future<BaseResponse<DriverOrdersResponseEntity>> call() {
    return repository.getDriverOrders();
  }
}

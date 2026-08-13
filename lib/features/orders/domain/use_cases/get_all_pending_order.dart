import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/orders/domain/entities/order_details_response_entity.dart';
import 'package:tracking_app/features/orders/domain/repositories/order_details_repo.dart';

@injectable
class GetPendingOrdersUseCase {
  final OrderDetailsRepo _orderDetailsRepo;

  GetPendingOrdersUseCase({required OrderDetailsRepo orderDetailsRepo})
    : _orderDetailsRepo = orderDetailsRepo;

  Future<BaseResponse<OrdersResponseEntity>> call({
    required int page,
    required int limit,
  }) async {
    return await _orderDetailsRepo.getAllPendingOrders(
      page: page,
      limit: limit,
    );
  }
}

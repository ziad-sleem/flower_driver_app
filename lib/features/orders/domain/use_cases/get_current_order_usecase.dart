import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/orders/domain/entities/current_order_entity.dart';
import 'package:tracking_app/features/orders/domain/repositories/order_details_repo.dart';

@injectable
class GetCurrentOrderUseCase {
  final OrderDetailsRepo repo;

  GetCurrentOrderUseCase({required this.repo});

  Future<CurrentOrderEntity?> call({required String orderId}) {
    return repo.getCurrentOrder(orderId: orderId);
  }
}

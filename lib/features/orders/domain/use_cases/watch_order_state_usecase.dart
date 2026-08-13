import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/orders/domain/entities/current_order_entity.dart';
import 'package:tracking_app/features/orders/domain/repositories/order_details_repo.dart';

@injectable
class WatchCurrentOrderUseCase {
  final OrderDetailsRepo repo;

  const WatchCurrentOrderUseCase({required this.repo});

  Stream<CurrentOrderEntity?> call({required String orderId}) {
    return repo.watchCurrentOrder(orderId: orderId);
  }
}

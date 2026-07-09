import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/repositories/order_details_repo.dart';

@injectable
class SaveOrderHistoryUseCase {
  final OrderDetailsRepo repo;

  SaveOrderHistoryUseCase({required this.repo});

  Future<void> call({
    required String driverId,
    required String status,
    required OrderEntity order,
  }) {
    return repo.saveOrderHistory(
      driverId: driverId,
      status: status,
      order: order,
    );
  }
}

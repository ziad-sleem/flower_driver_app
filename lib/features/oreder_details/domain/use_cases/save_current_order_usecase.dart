import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/repositories/order_details_repo.dart';

@injectable
class SaveCurrentOrderUseCase {
  final OrderDetailsRepo repo;

  SaveCurrentOrderUseCase({required this.repo});

  Future<void> call({
    required String driverId,
    required OrderEntity order,
    required String state,
    required bool driverRequestedDelivery,
  }) {
    return repo.saveCurrentOrder(
      driverId: driverId,
      order: order,
      state: state,
      driverRequestedDelivery: driverRequestedDelivery,
    );
  }
}

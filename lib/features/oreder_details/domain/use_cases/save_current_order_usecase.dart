import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/oreder_details/domain/repositories/order_details_repo.dart';

@injectable
class SaveCurrentOrderUseCase {
  final OrderDetailsRepo repo;

  SaveCurrentOrderUseCase({required this.repo});

  Future<void> call({
    required String driverId,
    required String orderId,
    required String state,
  }) {
    return repo.saveCurrentOrder(
      driverId: driverId,
      orderId: orderId,
      state: state,
    );
  }
}

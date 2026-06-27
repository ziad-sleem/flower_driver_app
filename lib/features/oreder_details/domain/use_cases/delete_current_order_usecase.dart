import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/oreder_details/domain/repositories/order_details_repo.dart';

@injectable
class DeleteCurrentOrderUseCase {
  final OrderDetailsRepo repo;

  DeleteCurrentOrderUseCase({required this.repo});

  Future<void> call({required String driverId}) {
    return repo.deleteCurrentOrder(driverId: driverId);
  }
}

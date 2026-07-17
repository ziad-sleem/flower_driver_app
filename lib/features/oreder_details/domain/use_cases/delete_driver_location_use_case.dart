import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/oreder_details/domain/repositories/order_details_repo.dart';

@injectable
class DeleteDriverLocationUseCase {
  final OrderDetailsRepo repo;

  DeleteDriverLocationUseCase({required this.repo});

  Future<void> call({required String orderId}) {
    return repo.deleteDriverLocation(orderId: orderId);
  }
}

import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/current_order_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/repositories/order_details_repo.dart';

@injectable
class GetCurrentOrderUseCase {
  final OrderDetailsRepo repo;

  GetCurrentOrderUseCase({required this.repo});

  Future<CurrentOrderEntity?> call({required String driverId}) {
    return repo.getCurrentOrder(driverId: driverId);
  }
}

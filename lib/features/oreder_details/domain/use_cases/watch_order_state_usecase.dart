import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/oreder_details/domain/repositories/order_details_repo.dart';

@injectable
class WatchOrderStateUseCase {
  final OrderDetailsRepo repo;

  WatchOrderStateUseCase({required this.repo});

  Stream<String?> call({required String driverId}) {
    return repo.watchOrderState(driverId: driverId);
  }
}

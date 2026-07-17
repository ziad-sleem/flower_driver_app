import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/oreder_details/domain/repositories/order_details_repo.dart';

@injectable
class SetDriverLocationUseCase {
  final OrderDetailsRepo repo;

  SetDriverLocationUseCase({required this.repo});

  Future<void> call({
    required String orderId,
    required double latitude,
    required double longitude,
  }) {
    return repo.setDriverLocation(
      orderId: orderId,
      latitude: latitude,
      longitude: longitude,
    );
  }
}

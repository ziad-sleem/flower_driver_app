import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/repositories/order_details_repo.dart';

@injectable
class SaveCurrentOrderUseCase {
  final OrderDetailsRepo repo;

  SaveCurrentOrderUseCase({required this.repo});

  Future<void> call({
    required OrderEntity order,
    required String state,
    required bool driverRequestedDelivery,
    String? driverId,
    String? driverName,
    String? driverPhone,
    String? vehicleType,
    String? vehicleNumber,
    String? vehicleLicense,
  }) {
    return repo.saveCurrentOrder(
      order: order,
      state: state,
      driverRequestedDelivery: driverRequestedDelivery,
      driverId: driverId,
      driverName: driverName,
      driverPhone: driverPhone,
      vehicleType: vehicleType,
      vehicleNumber: vehicleNumber,
      vehicleLicense: vehicleLicense,
    );
  }
}

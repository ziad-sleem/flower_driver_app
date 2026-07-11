import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/storage/secure_storage_service.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/current_order_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/use_cases/get_current_order_usecase.dart';

part 'app_launch_state.dart';

@injectable
class AppLaunchCubit extends Cubit<AppLaunchState> {
  final GetCurrentOrderUseCase _getCurrentOrderUseCase;

  AppLaunchCubit(this._getCurrentOrderUseCase) : super(AppLaunchLoading());

  Future<void> checkCurrentOrder() async {
    final orderId = await SecureStorageService.getCurrentOrderId();

    if (orderId == null || orderId.isEmpty) {
      emit(AppLaunchNoOrder());
      return;
    }

    final currentOrder = await _getCurrentOrderUseCase(
      orderId: orderId,
    );

    if (currentOrder == null) {
      await SecureStorageService.deleteCurrentOrderId();
      emit(AppLaunchNoOrder());
    } else {
      emit(AppLaunchHasOrder(currentOrder));
    }
  }
}

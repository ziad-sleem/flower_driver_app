import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/core/storage/secure_storage_service.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/update_order_state_params.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/update_order_state_response_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/use_cases/save_current_order_usecase.dart';
import 'package:tracking_app/features/oreder_details/domain/use_cases/update_order_state_usecase.dart';
import 'package:tracking_app/features/oreder_details/domain/use_cases/watch_order_state_usecase.dart';
import 'package:tracking_app/features/oreder_details/presentation/cubit/order_details_intents.dart';
import 'package:tracking_app/features/oreder_details/presentation/cubit/order_step.dart';

part 'order_details_state.dart';

@injectable
class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final UpdateOrderStateUseCase _updateOrderStateUseCase;
  final SaveCurrentOrderUseCase _saveCurrentOrderUseCase;
  final WatchOrderStateUseCase _watchOrderStateUseCase;

  OrderDetailsCubit(
    this._updateOrderStateUseCase,
    this._saveCurrentOrderUseCase,
    this._watchOrderStateUseCase,
  ) : super(const OrderDetailsState());

  String? _driverId;
  StreamSubscription<String?>? _stateSubscription;

  void doIntent(OrderDetailsIntent intent) {
    switch (intent) {
      case StartOrderDetailsIntent():
        _start(intent.order);
      case AdvanceOrderStepIntent():
        _advance();
    }
  }

  Future<void> _start(OrderEntity order) async {
    emit(state.copyWith(order: order));
    _driverId = await SecureStorageService.getDriverId();
    if (_driverId == null) return;

    _stateSubscription = _watchOrderStateUseCase(driverId: _driverId!).listen((
      value,
    ) {
      final step = OrderStep.fromState(value);
      if (step != null) emit(state.copyWith(step: step));
    });
  }

  Future<void> _advance() async {
    final order = state.order;
    final current = state.step;
    final driverId = _driverId;
    final next = current?.nextStateValue;
    if (order == null || current == null || driverId == null || next == null) {
      return;
    }

    emit(state.copyWith(updateState: const BaseState(isLoading: true)));

    if (current.completesOrderOnAdvance) {
      final result = await _updateOrderStateUseCase(
        UpdateOrderStateParams(
          orderId: order.id ?? '',
          state: OrderStateValues.delivered,
        ),
      );
      if (result is ErrorBaseResponse<UpdateOrderStateResponseEntity>) {
        emit(
          state.copyWith(
            updateState: BaseState(errorMessage: result.failure.message),
          ),
        );
        return;
      }
    }

    await _saveCurrentOrderUseCase(
      driverId: driverId,
      orderId: order.id ?? '',
      state: next,
    );
    emit(state.copyWith(updateState: const BaseState(data: true)));
  }

  @override
  Future<void> close() {
    _stateSubscription?.cancel();
    return super.close();
  }
}

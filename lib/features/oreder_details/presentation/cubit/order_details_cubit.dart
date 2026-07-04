import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/core/storage/secure_storage_service.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/current_order_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/use_cases/save_current_order_usecase.dart';
import 'package:tracking_app/features/oreder_details/domain/use_cases/watch_order_state_usecase.dart';
import 'package:tracking_app/features/oreder_details/presentation/cubit/order_details_intents.dart';
import 'package:tracking_app/features/oreder_details/presentation/cubit/order_step.dart';

part 'order_details_state.dart';

@injectable
class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final SaveCurrentOrderUseCase _saveCurrentOrderUseCase;
  final WatchCurrentOrderUseCase _watchCurrentOrderUseCase;

  OrderDetailsCubit(
    this._saveCurrentOrderUseCase,
    this._watchCurrentOrderUseCase,
  ) : super(const OrderDetailsState());

  String? _driverId;

  StreamSubscription<CurrentOrderEntity?>? _stateSubscription;

  void doIntent(OrderDetailsIntent intent) {
    switch (intent) {
      case StartOrderDetailsIntent():
        _start(intent.order, initialState: intent.initialState);

      case AdvanceOrderStepIntent():
        _advance();
    }
  }

  Future<void> _start(OrderEntity order, {String? initialState}) async {
    emit(state.copyWith(order: order));

    if (initialState != null) {
      final step = OrderStep.fromState(initialState);

      if (step != null) {
        emit(state.copyWith(order: order, step: step));
      }
    }

    _driverId = await SecureStorageService.getDriverId();

    if (_driverId == null) return;

    await _stateSubscription?.cancel();

    _stateSubscription = _watchCurrentOrderUseCase(driverId: _driverId!).listen(
      (currentOrder) {
        // اليوزر أكد الاستلام ومسح الدوكيومنت
        if (currentOrder == null) {
          if (state.step == OrderStep.arrived) {
            emit(
              state.copyWith(
                step: OrderStep.delivered,
                updateState: const BaseState(data: true),
              ),
            );
          }
          return;
        }

        if (currentOrder.driverRequestedDelivery) {
          emit(
            state.copyWith(
              order: currentOrder.order,
              step: OrderStep.arrived,
              updateState: const BaseState(data: true),
            ),
          );
          return;
        }

        final step = OrderStep.fromState(currentOrder.state);

        if (step != null) {
          emit(state.copyWith(order: currentOrder.order, step: step));
        }
      },
    );
  }

  Future<void> _advance() async {
    final order = state.order;
    final current = state.step;
    final driverId = _driverId;
    final next = current?.nextStateValue;

    if (order == null || current == null || driverId == null) {
      return;
    }

    emit(state.copyWith(updateState: const BaseState(isLoading: true)));

    // أول ما الدرايفر يوصل للعميل
    if (current == OrderStep.outForDelivery) {
      await _saveCurrentOrderUseCase(
        driverId: driverId,
        order: order,
        state: OrderStateValues.arrived,
        driverRequestedDelivery: true,
      );

      emit(
        state.copyWith(
          step: OrderStep.arrived,
          updateState: const BaseState(data: true),
        ),
      );

      return;
    }

    if (current == OrderStep.arrived) {
      emit(state.copyWith(updateState: const BaseState(data: true)));
      return;
    }

    await _saveCurrentOrderUseCase(
      driverId: driverId,
      order: order,
      state: next!,
      driverRequestedDelivery: false,
    );

    emit(
      state.copyWith(
        step: OrderStep.fromState(next),
        updateState: const BaseState(data: true),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _stateSubscription?.cancel();
    return super.close();
  }
}

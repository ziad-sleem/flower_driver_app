import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_details_response_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/update_order_state_params.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/update_order_state_response_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/use_cases/get_all_pending_order.dart';
import 'package:tracking_app/features/oreder_details/domain/use_cases/update_order_state_usecase.dart';
import 'package:tracking_app/features/oreder_details/presentation/cubit/home_event.dart';
part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetPendingOrdersUseCase _getPendingOrdersUseCase;
  final UpdateOrderStateUseCase _updateOrderStateUseCase;

  HomeCubit(this._getPendingOrdersUseCase, this._updateOrderStateUseCase)
    : super(const HomeState());

  void doEvent(HomeEvent event) {
    switch (event) {
      case GetPendingOrders():
        _getPendingOrders();
        break;

      case AcceptOrder():
        _acceptOrder(event);
        break;

      case RejectOrder():
        _rejectOrder(event);
        break;
    }
  }

  Future<void> _getPendingOrders() async {
    emit(
      state.copyWith(
        ordersState: const BaseState(isLoading: true),
        acceptOrderState: const BaseState(),
        rejectOrderState: const BaseState(),
      ),
    );

    final result = await _getPendingOrdersUseCase();

    switch (result) {
      case SuccessBaseResponse<OrdersResponseEntity>():
        emit(state.copyWith(ordersState: BaseState(data: result.data)));

      case ErrorBaseResponse<OrdersResponseEntity>():
        emit(
          state.copyWith(
            ordersState: BaseState(errorMessage: result.failure.message),
          ),
        );
    }
  }

  Future<void> _acceptOrder(AcceptOrder event) async {
    emit(
      state.copyWith(
        acceptingOrderId: event.orderId,
        acceptOrderState: const BaseState(isLoading: true),
      ),
    );

    final result = await _updateOrderStateUseCase(
      UpdateOrderStateParams(orderId: event.orderId, state: "inProgress"),
    );

    switch (result) {
      case SuccessBaseResponse<UpdateOrderStateResponseEntity>():
        emit(
          state.copyWith(
            acceptingOrderId: null,
            acceptOrderState: const BaseState(data: true),
          ),
        );

      case ErrorBaseResponse<UpdateOrderStateResponseEntity>():
        emit(
          state.copyWith(
            acceptingOrderId: null,
            acceptOrderState: BaseState(errorMessage: result.failure.message),
          ),
        );
    }
  }

  Future<void> _rejectOrder(RejectOrder event) async {
    emit(
      state.copyWith(
        rejectingOrderId: event.orderId,
        rejectOrderState: const BaseState(isLoading: true),
      ),
    );

    final result = await _updateOrderStateUseCase(
      UpdateOrderStateParams(orderId: event.orderId, state: "canceled"),
    );

    switch (result) {
      case SuccessBaseResponse<UpdateOrderStateResponseEntity>():
        emit(
          state.copyWith(
            rejectingOrderId: null,
            rejectOrderState: const BaseState(data: true),
          ),
        );

      case ErrorBaseResponse<UpdateOrderStateResponseEntity>():
        emit(
          state.copyWith(
            rejectingOrderId: null,
            rejectOrderState: BaseState(errorMessage: result.failure.message),
          ),
        );
    }
  }
}

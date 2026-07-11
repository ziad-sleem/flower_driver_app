import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/core/storage/secure_storage_service.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/current_order_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_details_response_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/update_order_state_params.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/update_order_state_response_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/use_cases/get_all_pending_order.dart';
import 'package:tracking_app/features/oreder_details/domain/use_cases/get_current_order_usecase.dart';
import 'package:tracking_app/features/oreder_details/domain/use_cases/update_order_state_usecase.dart';
import 'package:tracking_app/features/oreder_details/presentation/cubit/home_event.dart';
part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetPendingOrdersUseCase _getPendingOrdersUseCase;
  final UpdateOrderStateUseCase _updateOrderStateUseCase;
  final GetCurrentOrderUseCase _getCurrentOrderUseCase;

  HomeCubit(
    this._getPendingOrdersUseCase,
    this._updateOrderStateUseCase,
    this._getCurrentOrderUseCase,
  ) : super(const HomeState());

  Future<void> refresh() => _getPendingOrders();

  void doEvent(HomeEvent event) {
    switch (event) {
      case CheckCurrentOrder():
        _checkCurrentOrder();
        break;

      case GetPendingOrders():
        _getPendingOrders();
        break;

      case AcceptOrder():
        _acceptOrder(event);
        break;

      case RejectOrder():
        _rejectOrder(event);
        break;
      case LoadMoreOrders():
        _loadMoreOrders();
        break;
    }
  }

  Future<void> _getPendingOrders() async {
    emit(
      state.copyWith(
        ordersState: const BaseState(isLoading: true),
        currentPage: 1,
        hasMore: true,
        orders: [],
      ),
    );

    final result = await _getPendingOrdersUseCase(page: 1, limit: 10);

    if (isClosed) return;

    switch (result) {
      case SuccessBaseResponse<OrdersResponseEntity>():
        final response = result.data;

        emit(
          state.copyWith(
            ordersState: BaseState(data: response),
            orders: response.orders ?? [],
            currentPage: 1,
            hasMore:
                (response.metadata?.currentPage ?? 1) <
                (response.metadata?.totalPages ?? 1),
          ),
        );

      case ErrorBaseResponse<OrdersResponseEntity>():
        emit(
          state.copyWith(
            ordersState: BaseState(errorMessage: result.failure.message),
          ),
        );
    }
  }

  Future<void> _loadMoreOrders() async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.currentPage + 1;

    final result = await _getPendingOrdersUseCase(page: nextPage, limit: 10);

    if (isClosed) return;

    switch (result) {
      case SuccessBaseResponse<OrdersResponseEntity>():
        final response = result.data;

        emit(
          state.copyWith(
            isLoadingMore: false,
            currentPage: nextPage,
            orders: [...state.orders, ...(response.orders ?? [])],
            hasMore:
                (response.metadata?.currentPage ?? 1) <
                (response.metadata?.totalPages ?? 1),
          ),
        );

      case ErrorBaseResponse<OrdersResponseEntity>():
        emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _acceptOrder(AcceptOrder event) async {
    emit(
      state.copyWith(
        acceptingOrderId: event.order.id ?? '',
        acceptOrderState: const BaseState(isLoading: true),
      ),
    );

    final result = await _updateOrderStateUseCase(
      UpdateOrderStateParams(order: event.order, state: "inProgress"),
    );
    if (isClosed) return;

    switch (result) {
      case SuccessBaseResponse<UpdateOrderStateResponseEntity>():
        emit(
          state.copyWith(
            acceptingOrderId: null,
            acceptOrderState: const BaseState(data: true),
            acceptedOrder: event.order,
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
        rejectingOrderId: event.order.id,
        rejectOrderState: const BaseState(isLoading: true),
      ),
    );

    final result = await _updateOrderStateUseCase(
      UpdateOrderStateParams(order: event.order, state: "canceled"),
    );

    if (isClosed) return;

    switch (result) {
      case SuccessBaseResponse<UpdateOrderStateResponseEntity>():
        emit(
          state.copyWith(
            rejectingOrderId: null,
            rejectOrderState: const BaseState(data: true),
            orders: state.orders.where((e) => e.id != event.order.id).toList(),
          ),
        );
        break;

      case ErrorBaseResponse<UpdateOrderStateResponseEntity>():
        emit(
          state.copyWith(
            rejectingOrderId: null,
            rejectOrderState: BaseState(errorMessage: result.failure.message),
          ),
        );
        break;
    }
  }

  Future<void> _checkCurrentOrder() async {
    final orderId = await SecureStorageService.getCurrentOrderId();

    if (orderId == null || orderId.isEmpty) {
      doEvent(GetPendingOrders());
      return;
    }

    final currentOrder = await _getCurrentOrderUseCase(orderId: orderId);

    if (currentOrder == null) {
      doEvent(GetPendingOrders());
      return;
    }

    emit(state.copyWith(currentOrder: currentOrder));
  }
}

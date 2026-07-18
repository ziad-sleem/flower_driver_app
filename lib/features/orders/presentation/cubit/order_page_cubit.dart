import 'package:equatable/equatable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/core/error/error_handler.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_details_response_entity.dart';
import 'package:tracking_app/features/orders/domain/entities/driver_order_entity.dart';
import 'package:tracking_app/features/orders/domain/entities/driver_orders_response_entity.dart';
import 'package:tracking_app/features/orders/domain/usecases/get_driver_orders_use_case.dart';
import 'package:tracking_app/features/orders/presentation/cubit/order_page_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'order_page_state.dart';

@injectable
class OrderPageCubit extends Cubit<OrderPageState> {
  final GetDriverOrdersUseCase _getDriverOrdersUseCase;

  OrderPageCubit(this._getDriverOrdersUseCase) : super(const OrderPageState());

  void doEvent(OrderPageEvent event) {
    switch (event) {
      case LoadDriverOrders():
        _loadDriverOrders();
        break;
    }
  }

  Future<void> _loadDriverOrders() async {
    try {
      emit(
        state.copyWith(
          getOrdersState: const BaseState(isLoading: true),
        ),
      );

      final result = await _getDriverOrdersUseCase();

      if (result is SuccessBaseResponse<DriverOrdersResponseEntity>) {
        final orders = result.data.orders ?? [];
        emit(
          state.copyWith(
            getOrdersState: BaseState(data: result.data, isLoading: false),
            orders: orders,
            completedCount: orders
                .where((o) => o.order?.state == OrderState.completed)
                .length,
            cancelledCount: orders
                .where((o) => o.order?.state == OrderState.canceled)
                .length,
          ),
        );
      } else if (result is ErrorBaseResponse<DriverOrdersResponseEntity>) {
        emit(
          state.copyWith(
            getOrdersState: BaseState(
              isLoading: false,
              errorMessage: result.failure.message,
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          getOrdersState: BaseState(
            isLoading: false,
            errorMessage: ErrorHandler.handle(e).message,
          ),
        ),
      );
    }
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_details_response_entity.dart';
import 'package:tracking_app/features/orders/domain/entities/driver_order_entity.dart';
import 'package:tracking_app/features/orders/domain/entities/driver_orders_response_entity.dart';
import 'package:tracking_app/features/orders/domain/usecases/get_driver_orders_use_case.dart';

part 'order_page_state.dart';

const _kFullHistoryLimit = 1000;

@injectable
class OrderPageCubit extends Cubit<OrderPageState> {
  final GetDriverOrdersUseCase _getDriverOrdersUseCase;

  OrderPageCubit(this._getDriverOrdersUseCase) : super(const OrderPageState());

  Future<void> loadDriverOrders() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final response = await _getDriverOrdersUseCase(
      page: 1,
      limit: _kFullHistoryLimit,
    );

    switch (response) {
      case SuccessBaseResponse<DriverOrdersResponseEntity>():
        final orders = response.data.orders ?? [];
        emit(
          state.copyWith(
            isLoading: false,
            orders: orders,
            completedCount: orders
                .where((o) => o.order?.state == OrderState.completed)
                .length,
            cancelledCount: orders
                .where((o) => o.order?.state == OrderState.canceled)
                .length,
          ),
        );
      case ErrorBaseResponse<DriverOrdersResponseEntity>():
        emit(
          state.copyWith(isLoading: false, errorMessage: response.failure.message),
        );
    }
  }
}

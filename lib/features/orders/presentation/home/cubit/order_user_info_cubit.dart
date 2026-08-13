import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/features/orders/data/models/order_user_info_model.dart';
import 'package:tracking_app/features/orders/domain/use_cases/get_order_user_info_use_case.dart';
import 'order_user_info_state.dart';

@injectable
class OrderUserInfoCubit extends Cubit<OrderUserInfoState> {
  final GetOrderUserInfoUseCase _getOrderUserInfoUseCase;

  OrderUserInfoCubit(this._getOrderUserInfoUseCase)
      : super(const OrderUserInfoState());

  Future<void> getOrderUserInfo() async {
    emit(state.copyWith(
      userInfoState: const BaseState(isLoading: true),
    ));

    final result = await _getOrderUserInfoUseCase();

    if (isClosed) return;

    switch (result) {
      case SuccessBaseResponse<List<OrderUserInfoModel>>():
        final list = result.data;
        final map = <String, OrderUserInfoModel>{};
        for (final item in list) {
          map[item.id] = item;
        }
        emit(state.copyWith(
          userInfoState: BaseState(data: list),
          userInfoMap: map,
        ));

      case ErrorBaseResponse<List<OrderUserInfoModel>>():
        emit(state.copyWith(
          userInfoState: BaseState(errorMessage: result.failure.message),
        ));
    }
  }
}

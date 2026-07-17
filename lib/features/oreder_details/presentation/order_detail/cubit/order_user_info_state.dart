import 'package:equatable/equatable.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/features/oreder_details/data/models/order_user_info_model.dart';

class OrderUserInfoState extends Equatable {
  final BaseState<List<OrderUserInfoModel>> userInfoState;
  final Map<String, OrderUserInfoModel> userInfoMap;

  const OrderUserInfoState({
    this.userInfoState = const BaseState(),
    this.userInfoMap = const {},
  });

  OrderUserInfoState copyWith({
    BaseState<List<OrderUserInfoModel>>? userInfoState,
    Map<String, OrderUserInfoModel>? userInfoMap,
  }) {
    return OrderUserInfoState(
      userInfoState: userInfoState ?? this.userInfoState,
      userInfoMap: userInfoMap ?? this.userInfoMap,
    );
  }

  @override
  List<Object?> get props => [userInfoState, userInfoMap];
}

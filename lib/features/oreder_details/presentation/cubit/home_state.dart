part of 'home_cubit.dart';

class HomeState extends Equatable {
  final BaseState<OrdersResponseEntity> ordersState;

  final BaseState<bool> acceptOrderState;
  final BaseState<bool> rejectOrderState;

  final String? acceptingOrderId;
  final String? rejectingOrderId;

  final OrderEntity? acceptedOrder;

  const HomeState({
    this.ordersState = const BaseState(),
    this.acceptOrderState = const BaseState(),
    this.rejectOrderState = const BaseState(),
    this.acceptingOrderId,
    this.rejectingOrderId,
    this.acceptedOrder,
  });

  HomeState copyWith({
    BaseState<OrdersResponseEntity>? ordersState,
    BaseState<bool>? acceptOrderState,
    BaseState<bool>? rejectOrderState,
    String? acceptingOrderId,
    String? rejectingOrderId,
    OrderEntity? acceptedOrder,
  }) {
    return HomeState(
      ordersState: ordersState ?? this.ordersState,
      acceptOrderState: acceptOrderState ?? this.acceptOrderState,
      rejectOrderState: rejectOrderState ?? this.rejectOrderState,
      acceptingOrderId: acceptingOrderId,
      rejectingOrderId: rejectingOrderId,
      acceptedOrder: acceptedOrder ?? this.acceptedOrder,
    );
  }

  @override
  List<Object?> get props => [
    ordersState,
    acceptOrderState,
    rejectOrderState,
    acceptingOrderId,
    rejectingOrderId,
    acceptedOrder,
  ];
}

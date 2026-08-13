part of 'history_cubit.dart';

class OrderPageState extends Equatable {
  final BaseState<DriverOrdersResponseEntity> getOrdersState;
  final List<DriverOrderEntity> orders;
  final int completedCount;
  final int cancelledCount;

  const OrderPageState({
    this.getOrdersState = const BaseState(),
    this.orders = const [],
    this.completedCount = 0,
    this.cancelledCount = 0,
  });

  OrderPageState copyWith({
    BaseState<DriverOrdersResponseEntity>? getOrdersState,
    List<DriverOrderEntity>? orders,
    int? completedCount,
    int? cancelledCount,
  }) {
    return OrderPageState(
      getOrdersState: getOrdersState ?? this.getOrdersState,
      orders: orders ?? this.orders,
      completedCount: completedCount ?? this.completedCount,
      cancelledCount: cancelledCount ?? this.cancelledCount,
    );
  }

  @override
  List<Object?> get props => [
    getOrdersState,
    orders,
    completedCount,
    cancelledCount,
  ];
}

part of 'order_details_cubit.dart';

class OrderDetailsState extends Equatable {
  final OrderEntity? order;
  final OrderStep? step;
  final BaseState<bool> updateState;

  const OrderDetailsState({
    this.order,
    this.step,
    this.updateState = const BaseState(),
  });

  OrderDetailsState copyWith({
    OrderEntity? order,
    OrderStep? step,
    BaseState<bool>? updateState,
  }) {
    return OrderDetailsState(
      order: order ?? this.order,
      step: step ?? this.step,
      updateState: updateState ?? this.updateState,
    );
  }

  @override
  List<Object?> get props => [order, step, updateState];
}

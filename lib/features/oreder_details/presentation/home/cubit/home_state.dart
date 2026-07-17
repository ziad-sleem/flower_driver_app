part of 'home_cubit.dart';

class HomeState extends Equatable {
  final BaseState<OrdersResponseEntity> ordersState;
  final BaseState<bool> acceptOrderState;
  final BaseState<bool> rejectOrderState;
  final String? acceptingOrderId;
  final String? rejectingOrderId;
  final OrderEntity? acceptedOrder;
  final CurrentOrderEntity? currentOrder;
  final List<OrderEntity> orders;

  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  const HomeState({
    this.ordersState = const BaseState(),
    this.acceptOrderState = const BaseState(),
    this.rejectOrderState = const BaseState(),
    this.acceptingOrderId,
    this.rejectingOrderId,
    this.acceptedOrder,
    this.currentOrder,

    this.orders = const [],
    this.currentPage = 1,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  HomeState copyWith({
    BaseState<OrdersResponseEntity>? ordersState,
    BaseState<bool>? acceptOrderState,
    BaseState<bool>? rejectOrderState,
    String? acceptingOrderId,
    String? rejectingOrderId,
    OrderEntity? acceptedOrder,
    CurrentOrderEntity? currentOrder,

    List<OrderEntity>? orders,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return HomeState(
      ordersState: ordersState ?? this.ordersState,
      acceptOrderState: acceptOrderState ?? this.acceptOrderState,
      rejectOrderState: rejectOrderState ?? this.rejectOrderState,
      acceptingOrderId: acceptingOrderId,
      rejectingOrderId: rejectingOrderId,
      acceptedOrder: acceptedOrder ?? this.acceptedOrder,
      currentOrder: currentOrder ?? this.currentOrder,

      orders: orders ?? this.orders,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
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
    currentOrder,
    orders,
    currentPage,
    hasMore,
    isLoadingMore,
  ];
}

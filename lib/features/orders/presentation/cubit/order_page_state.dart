part of 'order_page_cubit.dart';

class OrderPageState extends Equatable {
  final bool isLoading;
  final List<DriverOrderEntity> orders;
  final int completedCount;
  final int cancelledCount;
  final String? errorMessage;

  const OrderPageState({
    this.isLoading = false,
    this.orders = const [],
    this.completedCount = 0,
    this.cancelledCount = 0,
    this.errorMessage,
  });

  OrderPageState copyWith({
    bool? isLoading,
    List<DriverOrderEntity>? orders,
    int? completedCount,
    int? cancelledCount,
    String? errorMessage,
  }) {
    return OrderPageState(
      isLoading: isLoading ?? this.isLoading,
      orders: orders ?? this.orders,
      completedCount: completedCount ?? this.completedCount,
      cancelledCount: cancelledCount ?? this.cancelledCount,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    orders,
    completedCount,
    cancelledCount,
    errorMessage,
  ];
}

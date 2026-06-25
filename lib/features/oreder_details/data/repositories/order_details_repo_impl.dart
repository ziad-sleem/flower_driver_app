import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/oreder_details/data/datasources/order_details_firestore_data_source.dart';
import 'package:tracking_app/features/oreder_details/data/datasources/order_details_remote_data_source.dart';
import 'package:tracking_app/features/oreder_details/data/models/order_details_response_dto.dart';
import 'package:tracking_app/features/oreder_details/data/models/request/update_order_state_request_dto.dart';
import 'package:tracking_app/features/oreder_details/data/models/update_order_state_response_dto.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_details_response_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/update_order_state_params.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/update_order_state_response_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/repositories/order_details_repo.dart';

@Injectable(as: OrderDetailsRepo)
class OrderDetailsRepoImpl implements OrderDetailsRepo {
  final OrderDetailsRemoteDataSource remoteDataSource;
  final OrderDetailsFireStoreDataSource firestoreDataSource;
  OrderDetailsRepoImpl({
    required this.remoteDataSource,
    required this.firestoreDataSource,
  });

  @override
  Future<BaseResponse<OrdersResponseEntity>> getAllPendingOrders() async {
    final response = await remoteDataSource.getAllPendingOrders();

    switch (response) {
      case SuccessBaseResponse<OrdersResponseDto>():
        return SuccessBaseResponse<OrdersResponseEntity>(
          data: response.data.toEntity(),
        );
      case ErrorBaseResponse<OrdersResponseDto>():
        return ErrorBaseResponse<OrdersResponseEntity>(
          failure: response.failure,
        );
    }
  }

  @override
  Future<BaseResponse<UpdateOrderStateResponseEntity>> updateOrderState(
    UpdateOrderStateParams params,
  ) async {
    final response = await remoteDataSource.updateOrderState(
      orderId: params.orderId,
      request: UpdateOrderStateRequestDto(state: params.state),
    );

    switch (response) {
      case SuccessBaseResponse<UpdateOrderStateResponseDto>():
        return SuccessBaseResponse(data: response.data.toEntity());

      case ErrorBaseResponse<UpdateOrderStateResponseDto>():
        return ErrorBaseResponse(failure: response.failure);
    }
  }

  @override
  Future<void> saveCurrentOrder({
    required String driverId,
    required String orderId,
    required String state,
  }) {
    return firestoreDataSource.saveCurrentOrder(
      driverId: driverId,
      orderId: orderId,
      state: state,
    );
  }

  @override
  Future<void> deleteCurrentOrder({required String driverId}) {
    return firestoreDataSource.deleteCurrentOrder(driverId: driverId);
  }
}

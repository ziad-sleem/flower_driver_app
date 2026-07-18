import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/notifications/data_source/notification_queue_firestore_data_source.dart';
import 'package:tracking_app/core/storage/secure_storage_service.dart';
import 'package:tracking_app/features/oreder_details/data/datasources/order_details_firestore_data_source.dart';
import 'package:tracking_app/features/oreder_details/data/datasources/order_details_remote_data_source.dart';
import 'package:tracking_app/features/oreder_details/data/models/current_order_model.dart';
import 'package:tracking_app/features/oreder_details/data/models/order_details_response_dto.dart';
import 'package:tracking_app/features/oreder_details/data/models/request/update_order_state_request_dto.dart';
import 'package:tracking_app/features/oreder_details/data/models/update_order_state_response_dto.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/current_order_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_details_response_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/update_order_state_params.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/update_order_state_response_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/repositories/order_details_repo.dart';

@Injectable(as: OrderDetailsRepo)
class OrderDetailsRepoImpl implements OrderDetailsRepo {
  final OrderDetailsRemoteDataSource remoteDataSource;
  final OrderDetailsFireStoreDataSource firestoreDataSource;
  final NotificationQueueFirestoreDataSource
  notificationRequestFirestoreDataSource;
  OrderDetailsRepoImpl({
    required this.remoteDataSource,
    required this.firestoreDataSource,
    required this.notificationRequestFirestoreDataSource,
  });

  @override
  Future<BaseResponse<OrdersResponseEntity>> getAllPendingOrders({
    required int page,
    required int limit,
  }) async {
    final response = await remoteDataSource.getAllPendingOrders(
      page: page,
      limit: limit,
    );

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
    required OrderEntity order,
    required String state,
    required bool driverRequestedDelivery,
    String? driverId,
    String? driverName,
    String? driverPhone,
    String? vehicleType,
    String? vehicleNumber,
    String? vehicleLicense,
  }) async {
    await firestoreDataSource.saveCurrentOrder(
      order: order,
      state: state,
      driverRequestedDelivery: driverRequestedDelivery,
      driverId: driverId,
      driverName: driverName,
      driverPhone: driverPhone,
      vehicleType: vehicleType,
      vehicleNumber: vehicleNumber,
      vehicleLicense: vehicleLicense,
    );

    final orderId = order.id;
    if (orderId != null && orderId.isNotEmpty) {
      await SecureStorageService.saveCurrentOrderId(orderId);
    }
  }

  @override
  Future<void> deleteCurrentOrder({required String orderId}) {
    return firestoreDataSource.deleteCurrentOrder(orderId: orderId);
  }

  @override
  Stream<CurrentOrderEntity?> watchCurrentOrder({required String orderId}) {
    return firestoreDataSource
        .watchCurrentOrder(orderId: orderId)
        .map((event) => event?.toEntity());
  }

  @override
  Future<CurrentOrderEntity?> getCurrentOrder({
    required String orderId,
  }) async {
    final model = await firestoreDataSource.getCurrentOrder(orderId: orderId);

    return model?.toEntity();
  }

  @override
  Future<void> createNotificationRequest({
    required String userId,
    required String title,
    required String body,
    required String orderId,
    required String type,
  }) {
    return notificationRequestFirestoreDataSource.createNotification(
      userId: userId,
      title: title,
      body: body,
      orderId: orderId,
      type: type,
    );
  }

  @override
  Future<void> setDriverLocation({
    required String orderId,
    required double latitude,
    required double longitude,
  }) {
    return firestoreDataSource.setDriverLocation(
      orderId: orderId,
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Future<void> deleteDriverLocation({required String orderId}) {
    return firestoreDataSource.deleteDriverLocation(orderId: orderId);
  }

  @override
  Future<List<CurrentOrderModel>> getAllCurrentOrders() {
    return firestoreDataSource.getAllCurrentOrders();
  }
}

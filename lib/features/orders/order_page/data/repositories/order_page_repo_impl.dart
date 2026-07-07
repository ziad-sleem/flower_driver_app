import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/features/orders/order_page/data/datasources/order_page_remote_data_source.dart';
import 'package:tracking_app/features/orders/order_page/data/models/driver_orders_response_dto.dart';
import 'package:tracking_app/features/orders/order_page/domain/entities/driver_orders_response_entity.dart';
import 'package:tracking_app/features/orders/order_page/domain/repositories/order_page_repo.dart';

@Injectable(as: OrderPageRepo)
class OrderPageRepoImpl implements OrderPageRepo {
  final OrderPageRemoteDataSourceContract remoteDataSource;

  OrderPageRepoImpl({required this.remoteDataSource});

  @override
  Future<BaseResponse<DriverOrdersResponseEntity>> getDriverOrders({
    required int page,
    required int limit,
  }) async {
    final response = await remoteDataSource.getDriverOrders(
      page: page,
      limit: limit,
    );
    return switch (response) {
      SuccessBaseResponse<DriverOrdersResponseDto>() => SuccessBaseResponse(
        data: response.data.toEntity(),
      ),
      ErrorBaseResponse<DriverOrdersResponseDto>() => ErrorBaseResponse(
        failure: response.failure,
      ),
    };
  }
}

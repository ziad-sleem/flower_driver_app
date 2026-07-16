import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/error/error_handler.dart';
import 'package:tracking_app/features/orders/data/datasources/order_page_remote_data_source.dart';
import 'package:tracking_app/features/orders/data/models/driver_orders_response_dto.dart';
import 'package:tracking_app/features/orders/data/repositories/order_page_repo_impl.dart';
import 'package:tracking_app/features/orders/domain/entities/driver_orders_response_entity.dart';

import 'order_page_repo_impl_test.mocks.dart';

@GenerateMocks([OrderPageRemoteDataSourceContract])
void main() {
  late OrderPageRepoImpl repo;
  late MockOrderPageRemoteDataSourceContract mockDataSource;

  setUpAll(() {
    provideDummy<BaseResponse<DriverOrdersResponseDto>>(
      SuccessBaseResponse<DriverOrdersResponseDto>(
        data: DriverOrdersResponseDto(),
      ),
    );
  });

  setUp(() {
    mockDataSource = MockOrderPageRemoteDataSourceContract();
    repo = OrderPageRepoImpl(remoteDataSource: mockDataSource);
  });

  group('OrderPageRepoImpl.getDriverOrders', () {
    final tResponseDto = DriverOrdersResponseDto.fromJson({
      "message": "success",
      "metadata": {
        "currentPage": 1,
        "totalPages": 1,
        "totalItems": 1,
        "limit": 1000,
      },
      "orders": [
        {
          "_id": "do-1",
          "driver": "driver-1",
          "order": {"_id": "o-1", "state": "completed"},
          "store": {"name": "Elevate FlowerApp Store"},
        },
      ],
    });

    test('should return success with the mapped entity when data source succeeds', () async {
      when(mockDataSource.getDriverOrders(page: 1, limit: 1000)).thenAnswer(
        (_) async =>
            SuccessBaseResponse<DriverOrdersResponseDto>(data: tResponseDto),
      );

      final result = await repo.getDriverOrders(page: 1, limit: 1000);

      expect(result, isA<SuccessBaseResponse<DriverOrdersResponseEntity>>());
      final entity =
          (result as SuccessBaseResponse<DriverOrdersResponseEntity>).data;
      expect(entity.message, "success");
      expect(entity.orders, hasLength(1));
      expect(entity.orders?.first.id, "do-1");
      verify(mockDataSource.getDriverOrders(page: 1, limit: 1000)).called(1);
    });

    test('should return error when data source fails', () async {
      final tFailure = Failure(message: "Failed to load driver orders");
      when(mockDataSource.getDriverOrders(page: 1, limit: 1000)).thenAnswer(
        (_) async =>
            ErrorBaseResponse<DriverOrdersResponseDto>(failure: tFailure),
      );

      final result = await repo.getDriverOrders(page: 1, limit: 1000);

      expect(result, isA<ErrorBaseResponse<DriverOrdersResponseEntity>>());
      expect(
        (result as ErrorBaseResponse<DriverOrdersResponseEntity>)
            .failure
            .message,
        "Failed to load driver orders",
      );
      verify(mockDataSource.getDriverOrders(page: 1, limit: 1000)).called(1);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/network/safe_api_caller.dart';
import 'package:tracking_app/features/orders/api/api_client/order_page_api_client.dart';
import 'package:tracking_app/features/orders/api/datasource/order_page_remote_data_source_impl.dart';
import 'package:tracking_app/features/orders/data/models/driver_orders_response_dto.dart';

import 'order_page_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([OrderPageApiClient])
void main() {
  late OrderPageRemoteDataSourceImpl dataSource;
  late MockOrderPageApiClient mockApiClient;
  late SafeApiCaller safeApiCaller;

  setUp(() {
    mockApiClient = MockOrderPageApiClient();
    safeApiCaller = SafeApiCaller();
    dataSource = OrderPageRemoteDataSourceImpl(
      apiClient: mockApiClient,
      safeApiCaller: safeApiCaller,
    );
  });

  group('getDriverOrders', () {
    final tResponseDto = DriverOrdersResponseDto.fromJson({
      "message": "success",
      "metadata": {
        "currentPage": 1,
        "totalPages": 1,
        "totalItems": 0,
        "limit": 1000,
      },
      "orders": [],
    });

    test('should return success and forward page/limit when api client succeeds', () async {
      when(mockApiClient.getDriverOrders(1, 1000)).thenAnswer(
        (_) async => tResponseDto,
      );

      final result = await dataSource.getDriverOrders(page: 1, limit: 1000);

      expect(result, isA<SuccessBaseResponse<DriverOrdersResponseDto>>());
      expect(
        (result as SuccessBaseResponse<DriverOrdersResponseDto>).data,
        tResponseDto,
      );
      verify(mockApiClient.getDriverOrders(1, 1000)).called(1);
    });

    test('should return error when api client throws', () async {
      when(mockApiClient.getDriverOrders(1, 1000)).thenThrow(
        Exception('Network error'),
      );

      final result = await dataSource.getDriverOrders(page: 1, limit: 1000);

      expect(result, isA<ErrorBaseResponse<DriverOrdersResponseDto>>());
      verify(mockApiClient.getDriverOrders(1, 1000)).called(1);
    });
  });
}

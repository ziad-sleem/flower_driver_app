import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/error/error_handler.dart';
import 'package:tracking_app/features/orders/order_page/domain/entities/driver_orders_response_entity.dart';
import 'package:tracking_app/features/orders/order_page/domain/repositories/order_page_repo.dart';
import 'package:tracking_app/features/orders/order_page/domain/usecases/get_driver_orders_use_case.dart';

import 'get_driver_orders_use_case_test.mocks.dart';

@GenerateMocks([OrderPageRepo])
void main() {
  late GetDriverOrdersUseCase useCase;
  late MockOrderPageRepo mockRepo;

  setUpAll(() {
    provideDummy<BaseResponse<DriverOrdersResponseEntity>>(
      SuccessBaseResponse<DriverOrdersResponseEntity>(
        data: const DriverOrdersResponseEntity(),
      ),
    );
  });

  setUp(() {
    mockRepo = MockOrderPageRepo();
    useCase = GetDriverOrdersUseCase(mockRepo);
  });

  group('GetDriverOrdersUseCase', () {
    final tResponse = const DriverOrdersResponseEntity(
      message: 'success',
      orders: [],
    );

    test('should return success response from repo with the given page/limit', () async {
      when(mockRepo.getDriverOrders(page: 1, limit: 1000)).thenAnswer(
        (_) async =>
            SuccessBaseResponse<DriverOrdersResponseEntity>(data: tResponse),
      );

      final result = await useCase(page: 1, limit: 1000);

      expect(result, isA<SuccessBaseResponse<DriverOrdersResponseEntity>>());
      expect(
        (result as SuccessBaseResponse<DriverOrdersResponseEntity>).data,
        tResponse,
      );
      verify(mockRepo.getDriverOrders(page: 1, limit: 1000)).called(1);
    });

    test('should propagate error from repo', () async {
      final tFailure = Failure(message: 'Failed to load driver orders');
      when(mockRepo.getDriverOrders(page: 1, limit: 1000)).thenAnswer(
        (_) async =>
            ErrorBaseResponse<DriverOrdersResponseEntity>(failure: tFailure),
      );

      final result = await useCase(page: 1, limit: 1000);

      expect(result, isA<ErrorBaseResponse<DriverOrdersResponseEntity>>());
      expect(
        (result as ErrorBaseResponse<DriverOrdersResponseEntity>)
            .failure
            .message,
        'Failed to load driver orders',
      );
      verify(mockRepo.getDriverOrders(page: 1, limit: 1000)).called(1);
    });
  });
}

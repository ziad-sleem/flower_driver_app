import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/error/error_handler.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_details_response_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/orders/domain/entities/driver_order_entity.dart';
import 'package:tracking_app/features/orders/domain/entities/driver_orders_response_entity.dart';
import 'package:tracking_app/features/orders/domain/usecases/get_driver_orders_use_case.dart';
import 'package:tracking_app/features/orders/presentation/cubit/order_page_cubit.dart';

import 'order_page_cubit_test.mocks.dart';

@GenerateMocks([GetDriverOrdersUseCase])
void main() {
  late MockGetDriverOrdersUseCase mockUseCase;
  late OrderPageCubit cubit;

  setUpAll(() {
    provideDummy<BaseResponse<DriverOrdersResponseEntity>>(
      SuccessBaseResponse<DriverOrdersResponseEntity>(
        data: const DriverOrdersResponseEntity(),
      ),
    );
  });

  setUp(() {
    mockUseCase = MockGetDriverOrdersUseCase();
    cubit = OrderPageCubit(mockUseCase);
  });

  tearDown(() => cubit.close());

  group('OrderPageCubit', () {
    test('initial state is empty and not loading', () {
      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.orders, isEmpty);
      expect(cubit.state.completedCount, 0);
      expect(cubit.state.cancelledCount, 0);
      expect(cubit.state.errorMessage, isNull);
    });

    test(
      'loadDriverOrders emits loading then success with correct stats tallied from the fetched orders',
      () async {
        final driverOrders = [
          const DriverOrderEntity(
            id: 'do-1',
            order: OrderEntity(id: 'o-1', state: OrderState.completed),
          ),
          const DriverOrderEntity(
            id: 'do-2',
            order: OrderEntity(id: 'o-2', state: OrderState.completed),
          ),
          const DriverOrderEntity(
            id: 'do-3',
            order: OrderEntity(id: 'o-3', state: OrderState.canceled),
          ),
          const DriverOrderEntity(
            id: 'do-4',
            order: OrderEntity(id: 'o-4', state: OrderState.pending),
          ),
        ];

        when(mockUseCase(page: 1, limit: anyNamed('limit'))).thenAnswer(
          (_) async => SuccessBaseResponse<DriverOrdersResponseEntity>(
            data: DriverOrdersResponseEntity(
              message: 'success',
              orders: driverOrders,
            ),
          ),
        );

        final future = cubit.loadDriverOrders();
        // `emit(isLoading: true)` happens synchronously before the first
        // `await` inside loadDriverOrders, so it's already reflected here.
        expect(cubit.state.isLoading, isTrue);

        await future;

        expect(cubit.state.isLoading, isFalse);
        expect(cubit.state.orders, driverOrders);
        expect(cubit.state.completedCount, 2);
        expect(cubit.state.cancelledCount, 1);
        expect(cubit.state.errorMessage, isNull);
      },
    );

    test('loadDriverOrders emits an error message on failure', () async {
      when(mockUseCase(page: 1, limit: anyNamed('limit'))).thenAnswer(
        (_) async => ErrorBaseResponse<DriverOrdersResponseEntity>(
          failure: Failure(message: 'Something went wrong'),
        ),
      );

      await cubit.loadDriverOrders();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.errorMessage, 'Something went wrong');
      expect(cubit.state.orders, isEmpty);
    });

    test('loadDriverOrders treats a null orders list as empty with zero stats', () async {
      when(mockUseCase(page: 1, limit: anyNamed('limit'))).thenAnswer(
        (_) async => SuccessBaseResponse<DriverOrdersResponseEntity>(
          data: const DriverOrdersResponseEntity(message: 'success'),
        ),
      );

      await cubit.loadDriverOrders();

      expect(cubit.state.orders, isEmpty);
      expect(cubit.state.completedCount, 0);
      expect(cubit.state.cancelledCount, 0);
    });
  });
}

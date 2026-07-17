import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/error/error_handler.dart';
import 'package:tracking_app/core/resources/app_value.dart';
import 'package:tracking_app/core/widgets/app_error_widget.dart';
import 'package:tracking_app/core/widgets/app_loading_widget.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_details_response_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/store_entity.dart';
import 'package:tracking_app/features/orders/domain/entities/driver_order_entity.dart';
import 'package:tracking_app/features/orders/domain/entities/driver_orders_response_entity.dart';
import 'package:tracking_app/features/orders/domain/usecases/get_driver_orders_use_case.dart';
import 'package:tracking_app/features/orders/presentation/cubit/order_page_cubit.dart';
import 'package:tracking_app/features/orders/presentation/cubit/order_page_event.dart';
import 'package:tracking_app/features/orders/presentation/pages/order_page.dart';
import 'package:tracking_app/features/orders/presentation/widgets/empty_order_page_widget.dart';
import 'package:tracking_app/features/orders/presentation/widgets/recent_order_card.dart';

import 'order_page_test.mocks.dart';

Widget createTestWidget(OrderPageCubit cubit) {
  return EasyLocalization(
    supportedLocales: const [Locale('en')],
    path: AppKeys.translationPath,
    startLocale: const Locale('en'),
    child: MaterialApp(
      home: BlocProvider.value(value: cubit, child: const OrderPage()),
    ),
  );
}

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

  group('OrderPage', () {
    testWidgets('shows a loading indicator while orders are being fetched', (
      tester,
    ) async {
      // Widened because in tests .tr() falls back to the raw, longer
      // translation key instead of the short real translation, which
      // would otherwise overflow the stats section shown once loading
      // resolves at the end of this test.
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final completer = Completer<BaseResponse<DriverOrdersResponseEntity>>();
      when(
        mockUseCase(page: 1, limit: anyNamed('limit')),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(createTestWidget(cubit));
      unawaited(cubit.doEvent(LoadDriverOrders()));
      await tester.pump();

      expect(find.byType(AppLoadingWidget), findsOneWidget);

      completer.complete(
        SuccessBaseResponse<DriverOrdersResponseEntity>(
          data: const DriverOrdersResponseEntity(message: 'success', orders: []),
        ),
      );
      await tester.pumpAndSettle();
    });

    testWidgets(
      'shows the error widget and retries the fetch when tapped',
      (tester) async {
        // Widened because in tests .tr() falls back to the raw, longer
        // translation key instead of the short real translation, which
        // would otherwise overflow the stats section shown after retry.
        await tester.binding.setSurfaceSize(const Size(1200, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        when(mockUseCase(page: 1, limit: anyNamed('limit'))).thenAnswer(
          (_) async => ErrorBaseResponse<DriverOrdersResponseEntity>(
            failure: Failure(message: 'Network error'),
          ),
        );

        await tester.pumpWidget(createTestWidget(cubit));
        await cubit.doEvent(LoadDriverOrders());
        await tester.pumpAndSettle();

        expect(find.byType(AppErrorWidget), findsOneWidget);
        expect(find.text('Network error'), findsOneWidget);

        when(mockUseCase(page: 1, limit: anyNamed('limit'))).thenAnswer(
          (_) async => SuccessBaseResponse<DriverOrdersResponseEntity>(
            data: const DriverOrdersResponseEntity(message: 'success', orders: []),
          ),
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.byType(AppErrorWidget), findsNothing);
        expect(find.byType(EmptyOrderPageWidget), findsOneWidget);
      },
    );

    testWidgets('shows the empty state when there are no orders', (
      tester,
    ) async {
      // Widened because in tests .tr() falls back to the raw, longer
      // translation key instead of the short real translation, which
      // would otherwise overflow the stats section.
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      when(mockUseCase(page: 1, limit: anyNamed('limit'))).thenAnswer(
        (_) async => SuccessBaseResponse<DriverOrdersResponseEntity>(
          data: const DriverOrdersResponseEntity(message: 'success', orders: []),
        ),
      );

      await tester.pumpWidget(createTestWidget(cubit));
      await cubit.doEvent(LoadDriverOrders());
      await tester.pumpAndSettle();

      expect(find.byType(EmptyOrderPageWidget), findsOneWidget);
      expect(find.byType(RecentOrderCard), findsNothing);
      expect(find.text('orders.my_orders'), findsOneWidget);
    });

    testWidgets(
      'shows the stats section and one card per order when populated',
      (tester) async {
        // Widened because in tests .tr() falls back to the raw, longer
        // translation key instead of the short real translation, which
        // would otherwise overflow the card/stat row.
        await tester.binding.setSurfaceSize(const Size(1200, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final driverOrders = [
          const DriverOrderEntity(
            id: 'do-1',
            order: OrderEntity(
              id: 'o-1',
              orderNumber: '#111',
              state: OrderState.completed,
            ),
            store: StoreEntity(name: 'Flowery store'),
          ),
          const DriverOrderEntity(
            id: 'do-2',
            order: OrderEntity(
              id: 'o-2',
              orderNumber: '#222',
              state: OrderState.canceled,
            ),
            store: StoreEntity(name: 'Flowery store'),
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

        await tester.pumpWidget(createTestWidget(cubit));
        await cubit.doEvent(LoadDriverOrders());
        await tester.pumpAndSettle();

        expect(find.byType(EmptyOrderPageWidget), findsNothing);
        expect(find.byType(RecentOrderCard), findsNWidgets(2));
        expect(find.text('1'), findsNWidgets(2)); // 1 completed, 1 cancelled
      },
    );
  });
}

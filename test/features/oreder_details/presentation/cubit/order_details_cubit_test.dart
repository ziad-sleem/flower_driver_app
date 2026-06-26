import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/error/error_handler.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/update_order_state_params.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/update_order_state_response_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/use_cases/save_current_order_usecase.dart';
import 'package:tracking_app/features/oreder_details/domain/use_cases/update_order_state_usecase.dart';
import 'package:tracking_app/features/oreder_details/domain/use_cases/watch_order_state_usecase.dart';
import 'package:tracking_app/features/oreder_details/presentation/cubit/order_details_cubit.dart';
import 'package:tracking_app/features/oreder_details/presentation/cubit/order_details_intents.dart';
import 'package:tracking_app/features/oreder_details/presentation/cubit/order_step.dart';

import 'order_details_cubit_test.mocks.dart';

@GenerateMocks([
  UpdateOrderStateUseCase,
  SaveCurrentOrderUseCase,
  WatchOrderStateUseCase,
])
void main() {
  late MockUpdateOrderStateUseCase updateUseCase;
  late MockSaveCurrentOrderUseCase saveUseCase;
  late MockWatchOrderStateUseCase watchUseCase;
  late StreamController<String?> firestoreState;
  late OrderDetailsCubit cubit;

  const order = OrderEntity(id: 'order-1', orderNumber: '123');

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    provideDummy<BaseResponse<UpdateOrderStateResponseEntity>>(
      ErrorBaseResponse<UpdateOrderStateResponseEntity>(
        failure: Failure(message: ''),
      ),
    );
  });

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
          (call) async => call.method == 'read' ? 'driver-1' : null,
        );

    updateUseCase = MockUpdateOrderStateUseCase();
    saveUseCase = MockSaveCurrentOrderUseCase();
    watchUseCase = MockWatchOrderStateUseCase();
    firestoreState = StreamController<String?>.broadcast();

    when(
      watchUseCase(driverId: anyNamed('driverId')),
    ).thenAnswer((_) => firestoreState.stream);
    when(
      saveUseCase(
        driverId: anyNamed('driverId'),
        orderId: anyNamed('orderId'),
        state: anyNamed('state'),
      ),
    ).thenAnswer((_) async {});

    cubit = OrderDetailsCubit(updateUseCase, saveUseCase, watchUseCase);
  });

  tearDown(() async {
    await firestoreState.close();
    await cubit.close();
  });

  Future<void> startAt(String firestoreValue) async {
    cubit.doIntent(const StartOrderDetailsIntent(order));
    await pumpEventQueue();
    firestoreState.add(firestoreValue);
    await pumpEventQueue();
  }

  test('maps the Firestore state to the current step', () async {
    await startAt(OrderStateValues.accepted);

    expect(cubit.state.order, order);
    expect(cubit.state.step, OrderStep.accepted);
  });

  test('intermediate step writes Firestore only (no API call)', () async {
    await startAt(OrderStateValues.accepted);

    cubit.doIntent(const AdvanceOrderStepIntent());
    await pumpEventQueue();

    verifyNever(updateUseCase(any));
    verify(
      saveUseCase(
        driverId: 'driver-1',
        orderId: 'order-1',
        state: OrderStateValues.picked,
      ),
    ).called(1);

    firestoreState.add(OrderStateValues.picked);
    await pumpEventQueue();
    expect(cubit.state.step, OrderStep.picked);
  });

  test('final step calls the API with "completed" then writes Firestore', () async {
    when(updateUseCase(any)).thenAnswer(
      (_) async => SuccessBaseResponse(
        data: const UpdateOrderStateResponseEntity(message: 'ok'),
      ),
    );

    await startAt(OrderStateValues.arrived);

    cubit.doIntent(const AdvanceOrderStepIntent());
    await pumpEventQueue();

    final params =
        verify(updateUseCase(captureAny)).captured.single
            as UpdateOrderStateParams;
    expect(params.orderId, 'order-1');
    expect(params.state, OrderStateValues.delivered);
    verify(
      saveUseCase(
        driverId: 'driver-1',
        orderId: 'order-1',
        state: OrderStateValues.delivered,
      ),
    ).called(1);
  });

  test('final step API error surfaces a message and skips Firestore', () async {
    when(
      updateUseCase(any),
    ).thenAnswer((_) async => ErrorBaseResponse(failure: Failure(message: 'boom')));

    await startAt(OrderStateValues.arrived);

    cubit.doIntent(const AdvanceOrderStepIntent());
    await pumpEventQueue();

    expect(cubit.state.updateState.errorMessage, 'boom');
    verifyNever(
      saveUseCase(
        driverId: anyNamed('driverId'),
        orderId: anyNamed('orderId'),
        state: anyNamed('state'),
      ),
    );
  });
}

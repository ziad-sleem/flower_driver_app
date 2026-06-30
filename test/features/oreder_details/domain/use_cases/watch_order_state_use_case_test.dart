import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/features/oreder_details/domain/repositories/order_details_repo.dart';
import 'package:tracking_app/features/oreder_details/domain/use_cases/watch_order_state_usecase.dart';

import 'watch_order_state_use_case_test.mocks.dart';

@GenerateMocks([OrderDetailsRepo])
void main() {
  test('forwards the driver state stream from the repo', () {
    final repo = MockOrderDetailsRepo();
    final controller = StreamController<String?>();
    final repoStream = controller.stream;
    when(
      repo.watchOrderState(driverId: anyNamed('driverId')),
    ).thenAnswer((_) => repoStream);

    final useCase = WatchOrderStateUseCase(repo: repo);
    final stream = useCase(driverId: 'driver-1');

    expect(stream, same(repoStream));
    verify(repo.watchOrderState(driverId: 'driver-1')).called(1);

    controller.close();
  });
}

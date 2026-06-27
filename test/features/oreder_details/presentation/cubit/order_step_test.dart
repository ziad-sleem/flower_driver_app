import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/oreder_details/presentation/cubit/order_step.dart';

void main() {
  group('OrderStep.fromState', () {
    test('maps every known Firestore state string', () {
      expect(
        OrderStep.fromState(OrderStateValues.accepted),
        OrderStep.accepted,
      );
      expect(OrderStep.fromState(OrderStateValues.picked), OrderStep.picked);
      expect(
        OrderStep.fromState(OrderStateValues.outForDelivery),
        OrderStep.outForDelivery,
      );
      expect(OrderStep.fromState(OrderStateValues.arrived), OrderStep.arrived);
      expect(
        OrderStep.fromState(OrderStateValues.delivered),
        OrderStep.delivered,
      );
    });

    test('returns null for null or unknown values', () {
      expect(OrderStep.fromState(null), isNull);
      expect(OrderStep.fromState('pending'), isNull);
      expect(OrderStep.fromState('garbage'), isNull);
    });
  });

  group('nextStateValue', () {
    test('walks the flow in order then terminates', () {
      expect(OrderStep.accepted.nextStateValue, OrderStateValues.picked);
      expect(OrderStep.picked.nextStateValue, OrderStateValues.outForDelivery);
      expect(OrderStep.outForDelivery.nextStateValue, OrderStateValues.arrived);
      expect(OrderStep.arrived.nextStateValue, OrderStateValues.delivered);
      expect(OrderStep.delivered.nextStateValue, isNull);
    });
  });

  group('isTerminal', () {
    test('only delivered is terminal', () {
      expect(OrderStep.delivered.isTerminal, isTrue);
      expect(OrderStep.accepted.isTerminal, isFalse);
      expect(OrderStep.arrived.isTerminal, isFalse);
    });
  });

  group('completesOrderOnAdvance', () {
    test('only the arrived -> delivered hop hits the backend', () {
      expect(OrderStep.arrived.completesOrderOnAdvance, isTrue);
      expect(OrderStep.accepted.completesOrderOnAdvance, isFalse);
      expect(OrderStep.picked.completesOrderOnAdvance, isFalse);
      expect(OrderStep.outForDelivery.completesOrderOnAdvance, isFalse);
      expect(OrderStep.delivered.completesOrderOnAdvance, isFalse);
    });
  });
}

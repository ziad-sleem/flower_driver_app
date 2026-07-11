import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/resources/app_value.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_details_response_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/shipping_entity.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/store_entity.dart';
import 'package:tracking_app/features/orders/order_page/domain/entities/driver_order_entity.dart';
import 'package:tracking_app/features/orders/order_page/presentation/widgets/recent_order_card.dart';

Widget createTestWidget(DriverOrderEntity driverOrder) {
  return EasyLocalization(
    supportedLocales: const [Locale('en')],
    path: AppKeys.translationPath,
    startLocale: const Locale('en'),
    child: MaterialApp(
      home: Scaffold(body: RecentOrderCard(driverOrder: driverOrder)),
    ),
  );
}

void main() {
  group('RecentOrderCard', () {
    testWidgets('renders a completed order with its number and pickup/user addresses', (
      tester,
    ) async {
      // Widened because in tests .tr() falls back to the raw, longer
      // translation key instead of the short real translation, which
      // would otherwise overflow the card's title row.
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      const driverOrder = DriverOrderEntity(
        id: 'do-1',
        order: OrderEntity(
          id: 'o-1',
          orderNumber: '#123456',
          state: OrderState.completed,
          shippingAddress: ShippingAddressEntity(street: '20th st, Giza'),
        ),
        store: StoreEntity(
          name: 'Flowery store',
          address: '20th st, Sheikh Zayed, Giza',
        ),
      );

      await tester.pumpWidget(createTestWidget(driverOrder));
      await tester.pumpAndSettle();

      expect(find.text('#123456'), findsOneWidget);
      expect(find.text('status.completed'), findsOneWidget);
      expect(find.text('status.cancelled'), findsNothing);
      expect(find.text('Flowery store'), findsOneWidget);
      expect(find.text('20th st, Sheikh Zayed, Giza'), findsOneWidget);
    });

    testWidgets('renders a cancelled order with the cancelled badge', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      const driverOrder = DriverOrderEntity(
        id: 'do-2',
        order: OrderEntity(
          id: 'o-2',
          orderNumber: '#654321',
          state: OrderState.canceled,
        ),
        store: StoreEntity(name: 'Flowery store'),
      );

      await tester.pumpWidget(createTestWidget(driverOrder));
      await tester.pumpAndSettle();

      expect(find.text('#654321'), findsOneWidget);
      expect(find.text('status.cancelled'), findsOneWidget);
      expect(find.text('status.completed'), findsNothing);
    });

    testWidgets('does not throw when order/store fields are missing', (
      tester,
    ) async {
      const driverOrder = DriverOrderEntity(id: 'do-3');

      await tester.pumpWidget(createTestWidget(driverOrder));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(RecentOrderCard), findsOneWidget);
    });
  });
}

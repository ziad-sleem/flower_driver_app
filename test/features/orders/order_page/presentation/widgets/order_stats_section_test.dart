import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/resources/app_value.dart';
import 'package:tracking_app/features/orders/order_page/presentation/widgets/order_stats_section.dart';

Widget createTestWidget({required int cancelledCount, required int completedCount}) {
  return EasyLocalization(
    supportedLocales: const [Locale('en')],
    path: AppKeys.translationPath,
    startLocale: const Locale('en'),
    child: MaterialApp(
      home: Scaffold(
        body: OrderStatsSection(
          cancelledCount: cancelledCount,
          completedCount: completedCount,
        ),
      ),
    ),
  );
}

void main() {
  group('OrderStatsSection', () {
    testWidgets('renders both counts and their labels', (tester) async {
      // Widened because in tests .tr() falls back to the raw, longer
      // translation key (e.g. "status.cancelled") instead of the short
      // real translation, which would otherwise overflow the stat card.
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        createTestWidget(cancelledCount: 4, completedCount: 100),
      );
      await tester.pumpAndSettle();

      expect(find.text('4'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
      expect(find.text('status.cancelled'), findsOneWidget);
      expect(find.text('status.completed'), findsOneWidget);
      expect(find.byType(SvgPicture), findsNWidgets(2));
    });

    testWidgets('renders zero counts without error', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        createTestWidget(cancelledCount: 0, completedCount: 0),
      );
      await tester.pumpAndSettle();

      expect(find.text('0'), findsNWidgets(2));
    });
  });
}

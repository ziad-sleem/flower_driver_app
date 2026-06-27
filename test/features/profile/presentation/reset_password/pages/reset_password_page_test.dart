import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/config/base/base_response.dart';
import 'package:tracking_app/core/resources/app_value.dart';
import 'package:tracking_app/features/profile/domain/entities/reset_password_response_entity.dart';
import 'package:tracking_app/features/profile/domain/use_cases/reset_password_use_case.dart';
import 'package:tracking_app/features/profile/presentation/reset_password/cubit/reset_password_cubit.dart';
import 'package:tracking_app/features/profile/presentation/reset_password/pages/reset_password_page.dart';

import '../cubit/reset_password_cubit_test.mocks.dart';

Widget createTestWidget(MockResetPasswordUseCase mockUseCase) {
  return EasyLocalization(
    supportedLocales: const [Locale('en')],
    path: AppKeys.translationPath,
    startLocale: const Locale('en'),
    child: MaterialApp(
      routes: {'/login': (_) => const SizedBox()},
      home: BlocProvider(
        create: (_) => ResetPasswordCubit(mockUseCase),
        child: const ResetPasswordPage(),
      ),
    ),
  );
}

void main() {
  late MockResetPasswordUseCase mockUseCase;

  setUpAll(() {
    provideDummy<BaseResponse<ResetPasswordResponseEntity>>(
      SuccessBaseResponse<ResetPasswordResponseEntity>(
        data: ResetPasswordResponseEntity(message: '', token: ''),
      ),
    );
  });

  setUp(() {
    mockUseCase = MockResetPasswordUseCase();
  });

  group('ResetPasswordPage', () {
    testWidgets('renders all form fields and confirm button', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createTestWidget(mockUseCase));
      await tester.pumpAndSettle();

      expect(find.text('auth.password'), findsOneWidget);
      expect(find.text('auth.new_password'), findsOneWidget);
      expect(find.text('auth.confirm_password'), findsAtLeast(1));
      expect(find.text('general.confirm'), findsOneWidget);
      expect(find.text('profile.reset_password'), findsAtLeast(1));
    });

    testWidgets('shows validation errors when submitting empty form',
        (tester) async {
      await tester.pumpWidget(createTestWidget(mockUseCase));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('general.confirm'));
      await tester.tap(find.text('general.confirm'));
      await tester.pumpAndSettle();

      expect(find.text('validation.password_required'), findsAtLeast(1));
    });

    testWidgets('calls cubit with correct params on valid submit',
        (tester) async {
      when(mockUseCase(
        password: anyNamed('password'),
        newPassword: anyNamed('newPassword'),
      )).thenAnswer(
        (_) async => SuccessBaseResponse<ResetPasswordResponseEntity>(
          data: const ResetPasswordResponseEntity(
            message: 'Changed',
            token: 'tok',
          ),
        ),
      );

      await tester.pumpWidget(createTestWidget(mockUseCase));
      await tester.pumpAndSettle();

      final passwordFields = find.byType(TextFormField);
      expect(passwordFields, findsNWidgets(3));

      await tester.enterText(passwordFields.at(0), 'OldPass123!');
      await tester.enterText(passwordFields.at(1), 'NewPass456!');
      await tester.enterText(passwordFields.at(2), 'NewPass456!');

      await tester.ensureVisible(find.text('general.confirm'));
      await tester.tap(find.text('general.confirm'));
      await tester.pump();

      verify(mockUseCase(
        password: 'OldPass123!',
        newPassword: 'NewPass456!',
      )).called(1);
    });
  });
}

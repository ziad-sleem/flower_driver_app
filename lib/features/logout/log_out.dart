import 'package:flutter/material.dart';
import 'package:tracking_app/config/routes/routes.dart';
import 'package:tracking_app/core/storage/secure_storage_service.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/app_text_style.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await SecureStorageService.deleteToken();

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.onboarding,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Spacer(),
            Align(
              alignment: AlignmentGeometry.bottomCenter,
              child: Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(AppColors.error),
                  ),
                  onPressed: () {
                    _logout(context);
                  },
                  child: Text(
                    "Sign Out",
                    style: getMediumStyle(
                      context: context,
                      color: AppColors.surface,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

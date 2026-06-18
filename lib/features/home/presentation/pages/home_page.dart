import 'package:flutter/material.dart';
import 'package:tracking_app/config/routes/routes.dart';
import 'package:tracking_app/core/localization_constants/general_constants.dart';
import 'package:tracking_app/core/storage/secure_storage_service.dart';
import 'package:tracking_app/core/theme/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _onLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(GeneralConstants.logout),
        content: Text(GeneralConstants.confirmLogout),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(GeneralConstants.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              GeneralConstants.logout,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await SecureStorageService.deleteToken();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, Routes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _onLogout(context),
          ),
        ],
      ),
      body: const Center(
        child: Text('Login successful!'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tracking_app/config/dependency_injection/di.dart';
import 'package:tracking_app/config/routes/routes.dart';
import 'package:tracking_app/core/localization_constants/general_constants.dart';
import 'package:tracking_app/core/localization_constants/profile_constants.dart';
import 'package:tracking_app/features/auth/domain/use_cases/logout_use_case.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, Routes.resetPassword),
            child: Text(ProfileConstants.resetPassword),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _confirmLogout(context),
            child: Text(GeneralConstants.logout),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(GeneralConstants.logout),
        content: Text(GeneralConstants.confirmLogout),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(GeneralConstants.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _logout(context);
            },
            child: Text(GeneralConstants.yes),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await getIt<LogoutUseCase>().call();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, Routes.login, (_) => false);
  }
}

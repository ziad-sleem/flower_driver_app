import 'package:tracking_app/config/routes/routes.dart';
import 'package:tracking_app/core/storage/secure_storage_service.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final token = await SecureStorageService.getToken();
    final destination = (token != null && token.isNotEmpty)
        ? Routes.home
        : Routes.login;

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, destination);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

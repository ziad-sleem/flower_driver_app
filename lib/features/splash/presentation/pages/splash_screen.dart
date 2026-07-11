import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tracking_app/config/dependency_injection/di.dart';
import 'package:tracking_app/config/routes/routes.dart';
import 'package:tracking_app/core/resources/app_svgs.dart';
import 'package:tracking_app/core/storage/secure_storage_service.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/features/oreder_details/domain/entities/order_details_args.dart';
import 'package:tracking_app/features/oreder_details/domain/use_cases/get_current_order_usecase.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _checkAuth();
        });
      }
    });
  }

  Future<void> _checkAuth() async {
    final token = await SecureStorageService.getToken();

    final isLoggedIn = token != null && token.isNotEmpty;

    if (!mounted) return;

    if (!isLoggedIn) {
      Navigator.pushReplacementNamed(context, Routes.onboarding);
      return;
    }

    final orderId = await SecureStorageService.getCurrentOrderId();
    debugPrint("orderId = $orderId");

    if (orderId != null && orderId.isNotEmpty) {
      final currentOrder = await getIt<GetCurrentOrderUseCase>()(
        orderId: orderId,
      );
      debugPrint("currentOrder = $currentOrder");
      if (!mounted) return;

      if (currentOrder != null) {
        Navigator.pushReplacementNamed(
          context,
          Routes.orderDetails,
          arguments: OrderDetailsArgs(
            order: currentOrder.order,
            state: currentOrder.state,
          ),
        );
        return;
      }
    }

    Navigator.pushReplacementNamed(context, Routes.appSection);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primaryLight,
              AppColors.surface,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: _animation,
            child: SvgPicture.asset(
              AppSvgs.splashLogo,
              width: 160,
              height: 160,
            ),
          ),
        ),
      ),
    );
  }
}

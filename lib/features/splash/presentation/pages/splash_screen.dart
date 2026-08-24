import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tracking_app/config/dependency_injection/di.dart';
import 'package:tracking_app/config/routes/routes.dart';
import 'package:tracking_app/core/resources/app_lottie.dart';
import 'package:tracking_app/core/storage/secure_storage_service.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/features/orders/domain/entities/order_details_args.dart';
import 'package:tracking_app/features/orders/domain/use_cases/get_current_order_usecase.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _lottieFadeAnimation;
  late final Animation<double> _lottieScaleAnimation;

  late final Animation<double> _floweryFadeAnimation;
  late final Animation<Offset> _flowerySlideAnimation;

  late final Animation<double> _riderFadeAnimation;
  late final Animation<Offset> _riderSlideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Lottie Animation
    _lottieFadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );

    _lottieScaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
    );

    // Flowery Animation
    _floweryFadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
    );

    _flowerySlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.35, 0.65, curve: Curves.easeOutCubic),
          ),
        );

    // Rider Animation
    _riderFadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 0.85, curve: Curves.easeOut),
    );

    _riderSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.55, 0.85, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), _checkAuth);
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

    debugPrint('orderId = $orderId');

    if (orderId != null && orderId.isNotEmpty) {
      final currentOrder = await getIt<GetCurrentOrderUseCase>()(
        orderId: orderId,
      );
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

    if (!mounted) return;

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
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie
              FadeTransition(
                opacity: _lottieFadeAnimation,
                child: ScaleTransition(
                  scale: _lottieScaleAnimation,
                  child: Lottie.asset(
                    AppLottie.splashAnimation,
                    repeat: true,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              // App Name
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SlideTransition(
                    position: _flowerySlideAnimation,
                    child: FadeTransition(
                      opacity: _floweryFadeAnimation,
                      child: Text(
                        'Flowery',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: -0.8,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 7),

                  SlideTransition(
                    position: _riderSlideAnimation,
                    child: FadeTransition(
                      opacity: _riderFadeAnimation,
                      child: Text(
                        'Rider',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 7),

              FadeTransition(
                opacity: CurvedAnimation(
                  parent: _controller,
                  curve: const Interval(0.72, 1.0, curve: Curves.easeOut),
                ),
                child: Text(
                  'Delivering happiness, one order at a time',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

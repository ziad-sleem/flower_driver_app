import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tracking_app/config/dependency_injection/di.dart';
import 'package:tracking_app/core/localization_constants/tabs_constants.dart';
import 'package:tracking_app/core/resources/app_svgs.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/features/app_section/presentation/cubit/app_section_cubit.dart';
import 'package:tracking_app/features/orders/presentation/home/cubit/order_user_info_cubit.dart';
import 'package:tracking_app/features/profile/presentation/profile/pages/profile_page.dart';
import 'package:tracking_app/features/orders/presentation/home/cubit/home_cubit.dart';
import 'package:tracking_app/features/orders/presentation/home/cubit/home_event.dart';
import 'package:tracking_app/features/orders/presentation/home/pages/home_screen.dart';
import 'package:tracking_app/features/orders/presentation/history/cubit/history_cubit.dart';
import 'package:tracking_app/features/orders/presentation/history/cubit/history_event.dart';
import 'package:tracking_app/features/orders/presentation/history/pages/history_page.dart';

class AppSectionsPage extends StatelessWidget {
  const AppSectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppSectionsCubit()),
        BlocProvider(
          create: (_) => getIt<OrderUserInfoCubit>()..getOrderUserInfo(),
        ),
      ],
      child: const _AppSectionsView(),
    );
  }
}

class _AppSectionsView extends StatelessWidget {
  const _AppSectionsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSectionsCubit, AppSectionState>(
      builder: (context, state) {
        final cubit = context.read<AppSectionsCubit>();

        final currentIndex = state is AppSectionsChanged
            ? state.currentIndex
            : 0;

        return Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: [
              BlocProvider(
                create: (_) => getIt<HomeCubit>()..doEvent(GetPendingOrders()),
                child: const HomeScreen(),
              ),
              BlocProvider(
                create: (_) =>
                    getIt<OrderPageCubit>()..doEvent(LoadDriverOrders()),
                child: const OrderPage(),
              ),
              ProfilePage(),
            ],
          ),

          bottomNavigationBar: _GoogleNavBar(
            currentIndex: currentIndex,
            onTabChange: cubit.changeSection,
          ),
        );
      },
    );
  }
}

class _GoogleNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChange;

  const _GoogleNavBar({required this.currentIndex, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: GNav(
            selectedIndex: currentIndex,
            onTabChange: onTabChange,

            // Colors
            backgroundColor: AppColors.background,
            color: AppColors.grey700,
            activeColor: AppColors.primary,
            tabBackgroundColor: AppColors.primary.withOpacity(0.10),

            // Animation
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,

            // Layout
            gap: 7,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),

            tabs: [
              _buildTab(
                label: TabsConstants.home,
                assetName: AppSvgs.home,
                isSelected: currentIndex == 0,
              ),

              _buildTab(
                label: TabsConstants.orders,
                assetName: AppSvgs.order,
                isSelected: currentIndex == 1,
              ),

              _buildTab(
                label: TabsConstants.profile,
                assetName: AppSvgs.profile,
                isSelected: currentIndex == 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  GButton _buildTab({
    required String label,
    required String assetName,
    required bool isSelected,
  }) {
    return GButton(
      icon: Icons.circle_outlined,
      text: label,
      leading: SvgPicture.asset(
        assetName,
        width: 22,
        height: 22,
        colorFilter: ColorFilter.mode(
          isSelected ? AppColors.primary : AppColors.grey700,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

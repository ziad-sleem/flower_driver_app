import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tracking_app/config/dependency_injection/di.dart';
import 'package:tracking_app/core/localization_constants/tabs_constants.dart';
import 'package:tracking_app/core/resources/app_svgs.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/features/app_section/presentation/cubit/app_section_cubit.dart';
import 'package:tracking_app/features/oreder_details/presentation/order_detail/cubit/order_user_info_cubit.dart';
import 'package:tracking_app/features/profile/presentation/profile/pages/profile_page.dart';
import 'package:tracking_app/features/oreder_details/presentation/home/cubit/home_cubit.dart';
import 'package:tracking_app/features/oreder_details/presentation/home/cubit/home_event.dart';
import 'package:tracking_app/features/oreder_details/presentation/home/pages/home_screen.dart';
import 'package:tracking_app/features/orders/presentation/cubit/order_page_cubit.dart';
import 'package:tracking_app/features/orders/presentation/cubit/order_page_event.dart';
import 'package:tracking_app/features/orders/presentation/pages/order_page.dart';

  
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

  List<_BottomNavItem> _items(BuildContext context) {
    return [
      _BottomNavItem(label: TabsConstants.home, icon: AppSvgs.home),
      _BottomNavItem(label: TabsConstants.orders, icon: AppSvgs.order),
      _BottomNavItem(label: TabsConstants.profile, icon: AppSvgs.profile),
    ];
  }

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
                create: (_) => getIt<OrderPageCubit>()..doEvent(LoadDriverOrders()),
                child: const OrderPage(),
              ),
              ProfilePage(),
            ],

          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: cubit.changeSection,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.grey700,
            type: BottomNavigationBarType.fixed,
            items: _items(context).map((item) {
              final isSelected = _items(context).indexOf(item) == currentIndex;
              return BottomNavigationBarItem(
                label: item.label,
                icon: _NavBarIcon(assetName: item.icon, isSelected: isSelected),
                activeIcon: _NavBarIcon(assetName: item.icon, isSelected: true),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _NavBarIcon extends StatelessWidget {
  final String assetName;
  final bool isSelected;

  const _NavBarIcon({required this.assetName, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: SvgPicture.asset(
        assetName,
        colorFilter: ColorFilter.mode(
          isSelected ? AppColors.primary : AppColors.grey700,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

class _BottomNavItem {
  final String label;
  final String icon;

  const _BottomNavItem({required this.label, required this.icon});
}

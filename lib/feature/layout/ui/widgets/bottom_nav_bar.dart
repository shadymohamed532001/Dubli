import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/feature/layout/logic/cubit/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutCubit, LayoutState>(
      builder: (context, state) {
        LayoutCubit cubit = LayoutCubit.getObject(context);
        return BottomNavigationBar(
          currentIndex: cubit.currentIndex,
          onTap: (index) => cubit.changeBottomNavIndex(index, context),
          items: cubit.getBottomNavItems(),
          selectedItemColor: const Color(0xFFED9F5F),
          unselectedItemColor: ColorManager.whiteColor,
          backgroundColor: ColorManager.primaryColor,
          elevation: 0,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        );
      },
    );
  }
}

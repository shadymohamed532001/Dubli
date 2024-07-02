import 'package:dupli/core/utils/app_colors.dart';
import 'package:dupli/feature/chat/ui/views/chat_view.dart';
import 'package:dupli/feature/event/ui/views/event_view.dart';
import 'package:dupli/feature/tasks/ui/views/tasks_group_view.dart';
import 'package:dupli/feature/layout/data/models/change_index_params.dart';
import 'package:dupli/feature/layout/data/repositories/layout_repo.dart';
import 'package:dupli/feature/layout/logic/cubit/layout_cubit.dart';
import 'package:dupli/feature/setting/ui/views/settiings_view.dart';
import 'package:dupli/feature/reminder/ui/views/reminder_view.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class LayoutRepoImpl extends LayOutRepo {
  LayoutRepoImpl();

  @override
  void changeBottomNavIndex({required ChangeIndexParams changeIndexParams}) {
    LayoutCubit.getObject(changeIndexParams.context).currentIndex =
        changeIndexParams.index!;
  }

  @override
  void changeBottomNavToHome({required ChangeIndexParams changeIndexParams}) {
    LayoutCubit.getObject(changeIndexParams.context).currentIndex = 2;
  }

  @override
  List<Widget> getBody() {
    return const <Widget>[
      ChatView(),
      ReminderView(),
      TasksGroupView(),
      EventView(),
      SettingsView(),
    ];
  }

  @override
  List<BottomNavigationBarItem> getBottomNavItems() =>
      <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(
            Iconsax.message,
            color: ColorManager.darkyellowColor,
          ),
          label: '',
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            Iconsax.task_square,
            color: ColorManager.darkyellowColor,
          ),
          label: '',
        ),
        const BottomNavigationBarItem(
          label: '',
          icon: Icon(
            Icons.check,
            size: 30,
            color: ColorManager.darkyellowColor,
          ),
        ),
        const BottomNavigationBarItem(
          label: '',
          icon: Icon(
            Iconsax.calendar_edit,
            color: ColorManager.darkyellowColor,
          ),
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
            color: ColorManager.darkyellowColor,
          ),
          label: '',
        ),
      ];
}

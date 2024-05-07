import 'package:dubli/feature/chat/ui/views/chat_view.dart';
import 'package:dubli/feature/focus/ui/views/focus_view.dart';
import 'package:dubli/feature/home/ui/views/home_view.dart';
import 'package:dubli/feature/layout/data/models/change_index_params.dart';
import 'package:dubli/feature/layout/data/repositories/layout_repo.dart';
import 'package:dubli/feature/layout/logic/cubit/layout_cubit.dart';
import 'package:dubli/feature/setting/ui/views/settiings_view.dart';
import 'package:dubli/feature/tasks/ui/views/tasks_view.dart';
import 'package:flutter/material.dart';

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
      FocusView(),
      HomeView(),
      TasksView(),
      SettingsView(),
    ];
  }

  @override
  List<BottomNavigationBarItem> getBottomNavItems() =>
      <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/chat.png',
            height: 33,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/light.png',
            height: 37,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          label: '',
          icon: Image.asset(
            'assets/images/check.png',
            height: 33,
          ),
        ),
        BottomNavigationBarItem(
          label: '',
          icon: Image.asset(
            'assets/images/bell.png',
            height: 28,
          ),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/setting.png',
            height: 28,
          ),
          label: '',
        ),
      ];
}

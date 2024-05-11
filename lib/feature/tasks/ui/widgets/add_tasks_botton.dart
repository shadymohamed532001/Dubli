import 'package:dubli/core/helper/naviagtion_extentaions.dart';
import 'package:dubli/core/routing/routes.dart';
import 'package:dubli/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AddTasksBotton extends StatelessWidget {
  const AddTasksBotton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.navigateTo(routeName: Routes.addtasksViewsRoute);
      },
      child: Container(
        width: 70,
        height: 30,
        decoration: BoxDecoration(
          color: ColorManager.darkyellowColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'Add',
          ),
        ),
      ),
    );
  }
}

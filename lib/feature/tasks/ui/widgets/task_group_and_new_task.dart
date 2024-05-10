import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:dubli/core/widgets/app_bottom.dart';
import 'package:flutter/material.dart';

class TaskGroupAndNewTask extends StatelessWidget {
  const TaskGroupAndNewTask({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Task Groups',
            style: AppStyle.font18Whitemedium.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
          CustomBottom(
            bottomHeight: 40,
            bottomWidth: 80,
            bottomtext: 'New Task',
            textBottomStyle: const TextStyle(
              fontSize: 13,
              fontFamily: 'Raleway',
              color: ColorManager.primaryColor,
            ),
            backgroundColor: ColorManager.darkyellowColor,
            onPressed: () {},
          )
        ],
      ),
    );
  }
}

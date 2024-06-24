import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/core/widgets/app_bottom.dart';
import 'package:dubli/feature/tasks/logic/tasks_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildAddTasksDropdown extends StatelessWidget {
  const BuildAddTasksDropdown({
    super.key,
    required this.onPressed,
    required this.addController,
  });

  final void Function()? onPressed;
  final TextEditingController addController;

  @override
  Widget build(BuildContext context) {
    return CustomBottom(
      bottomHeight: 40,
      bottomWidth: 70,
      bottomtext: 'Add',
      textBottomStyle: const TextStyle(
        fontSize: 13,
        fontFamily: 'Raleway',
        color: ColorManager.primaryColor,
      ),
      backgroundColor: ColorManager.darkyellowColor,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            var cubit = BlocProvider.of<TasksCubit>(context);
            return AlertDialog(
              title: const Text('Add Task Group'),
              content: TextField(
                controller: addController,
                decoration: const InputDecoration(
                  hintText: 'Enter group name',
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        String groupName =
                          addController.text.trim();
                        if (groupName.isNotEmpty) {
                          onPressed!();
                      
                          addController.clear();
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                )
              ],
            );
          },
        );
      },
    );
  }
}

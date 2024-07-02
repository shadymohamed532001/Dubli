import 'package:dupli/core/utils/app_colors.dart';
import 'package:dupli/core/utils/app_styles.dart';
import 'package:dupli/feature/tasks/logic/tasks_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AllTasksView extends StatefulWidget {
  const AllTasksView({super.key, required this.tasks});

  final List<Map<String, dynamic>> tasks;

  @override
  State<AllTasksView> createState() => _AllTasksViewState();
}

class _AllTasksViewState extends State<AllTasksView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TasksCubit, TasksState>(
      listener: (context, state) {
        if (state is GetAllTasksLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is GetAllTasksSuccessState) {
          setState(() {
            isLoading = false;
          });
        }
      },
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: ColorManager.darkyellowColor,
              ),
            )
          : widget.tasks.isEmpty
              ? Center(
                  child: Text(
                    "No Todo Tasks",
                    style: AppStyle.font22Whiteregular,
                  ),
                )
              : ListView.builder(
                  itemCount: widget.tasks.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      child: Container(
                        height: 80,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: ColorManager.darkGreyColor, width: 2),
                          color: Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              activeColor: widget.tasks[index]['fields']['done']
                                  ? ColorManager
                                      .darkyellowColor // Use a color for done tasks
                                  : ColorManager
                                      .darkyellowColor, // Use a color for todo tasks
                              value: widget.tasks[index]['fields']['done'],
                              onChanged: (bool? value) {
                                setState(() {
                                  widget.tasks[index]['fields']['done'] = value;
                                });
                                BlocProvider.of<TasksCubit>(context)
                                    .toggleTaskDone(
                                  widget.tasks[index]['fields']['tasklistId'],
                                  widget.tasks[index]['fields']['taskId'],
                                );
                              },
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat('dd/MM/yyyy, h:mm a').format(
                                      widget.tasks[index]['fields']['date']),
                                  style: AppStyle.font15Whiteregular,
                                ),
                                Text(
                                  widget.tasks[index]['fields']['name'],
                                  style: AppStyle.font15Whiteregular,
                                ),
                              ],
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

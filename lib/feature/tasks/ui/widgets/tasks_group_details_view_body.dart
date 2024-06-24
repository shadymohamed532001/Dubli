import 'package:dubli/core/helper/naviagtion_extentaions.dart';
import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:dubli/core/widgets/app_bottom.dart';
import 'package:dubli/feature/tasks/data/models/all_task_model.dart';
import 'package:dubli/feature/tasks/data/models/all_tasks_name_model.dart';
import 'package:dubli/feature/tasks/logic/tasks_cubit.dart';
import 'package:dubli/feature/tasks/ui/widgets/build_add_tasks_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class TasksGroupDetailsViewBody extends StatefulWidget {
  const TasksGroupDetailsViewBody({super.key, required this.taskModel});
  final TaskGroupModel taskModel;

  @override
  State<TasksGroupDetailsViewBody> createState() =>
      _TasksGroupDetailsViewBodyState();
}

class _TasksGroupDetailsViewBodyState extends State<TasksGroupDetailsViewBody> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TasksCubit>(context).getTasks(widget.taskModel.id);
  }

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<TasksCubit>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BuildAddTasksDropdown(
                addController: cubit.addTaskController,
                onPressed: () {},
                taskModel: widget.taskModel,
              )
              // BuildAddTasksDropdown(
              //   addController: cubit.addTaskController,
              //   onPressed: () {
              //     BlocProvider.of<TasksCubit>(context).addTask(
              //       widget.taskModel.id,
              //       cubit.addTaskController.text,
              //       '12/12/2022',
              //     );
              //   },
              // )
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BlocConsumer<TasksCubit, TasksState>(
              listener: (context, state) {
                if (state is AddTaskSuccess) {
                  cubit.getTasks(widget.taskModel.id);
                }
              },
              builder: (context, state) {
                if (state is GetAllTasksLoading || state is AddTaskLoading) {
                  return const Center(
                    child: SpinKitThreeBounce(
                      color: Colors.white,
                      size: 30.0,
                    ),
                  );
                } else if (state is GetAllTasksErrorState) {
                  return Center(
                    child: Text(
                      'No tasks Found',
                      style: AppStyle.font22Whitesemibold,
                    ),
                  );
                } else if (state is GetAllTasksSuccessState) {
                  return ListView.builder(
                    itemCount: cubit.allTasks.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TasksGroupDetailsItem(
                          isDone: cubit.allTasks[index].done,
                          allTaskModel: cubit.allTasks[index],
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TasksGroupDetailsItem extends StatelessWidget {
  const TasksGroupDetailsItem({
    super.key,
    required this.isDone,
    required this.allTaskModel,
  });

  final bool isDone;
  final AllTaskModel allTaskModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorManager.darkGreyColor,
          width: 2,
        ),
        color: Colors.transparent,
      ),
      child: Row(
        children: [
          Checkbox(
            activeColor: ColorManager.darkyellowColor,
            value: isDone,
            onChanged: (bool? value) {},
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('dd/MM/yyyy, h:mm a').format(allTaskModel.date),
                style: AppStyle.font15Whiteregular,
              ),
              Text(
                allTaskModel.name,
                style: AppStyle.font15Whiteregular,
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => _showUpdateDialog(context),
                  child: const Icon(
                    Icons.edit,
                    color: ColorManager.whiteColor,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _showDeleteConfirmationDialog(context),
                  child: const Icon(
                    Icons.delete,
                    color: ColorManager.whiteColor,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showUpdateDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Task Name'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter new task name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newName = controller.text;
                if (newName.isNotEmpty) {
                  BlocProvider.of<TasksCubit>(context).updateTaskListName(
                    newName: newName,
                    taskListId: allTaskModel.id,
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                BlocProvider.of<TasksCubit>(context)
                    .deleteTaskList(taskListId: allTaskModel.id);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class BuildAddTasksDropdown extends StatefulWidget {
  const BuildAddTasksDropdown({
    super.key,
    required this.onPressed,
    required this.addController,
    required this.taskModel,
  });

  final void Function()? onPressed;
  final TextEditingController addController;
  final TaskGroupModel taskModel;

  @override
  _BuildAddTasksDropdownState createState() => _BuildAddTasksDropdownState();
}

class _BuildAddTasksDropdownState extends State<BuildAddTasksDropdown> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

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
            return AlertDialog(
              title: const Text('Add Task Group'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: widget.addController,
                    decoration: const InputDecoration(
                      hintText: 'Enter task name',
                    ),
                  ),
                  TextField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      hintText: 'Select Date',
                    ),
                    onTap: () => _selectDate(context),
                  ),
                  TextField(
                    controller: _timeController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      hintText: 'Select Time',
                    ),
                    onTap: () => _selectTime(context),
                  ),
                ],
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
                        String taskName = widget.addController.text.trim();
                        String taskDate = _dateController.text.trim();
                        String taskTime = _timeController.text.trim();

                        if (taskName.isNotEmpty &&
                            taskDate.isNotEmpty &&
                            taskTime.isNotEmpty) {
                          final taskDateTime = '$taskDate $taskTime';
                          BlocProvider.of<TasksCubit>(context).addTask(
                            widget.taskModel.id,
                            taskName,
                            taskDateTime,
                          );
                          widget.onPressed!();
                          widget.addController.clear();
                          _dateController.clear();
                          _timeController.clear();
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}

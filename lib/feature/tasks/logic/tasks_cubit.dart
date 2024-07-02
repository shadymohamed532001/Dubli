import 'package:dupli/core/helper/helper_const.dart';
import 'package:dupli/core/helper/local_services.dart';
import 'package:dupli/feature/tasks/data/models/all_task_model.dart';
import 'package:dupli/feature/tasks/data/models/all_tasks_name_model.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(HomeInitial());

  var formKey = GlobalKey<FormState>();
  AutovalidateMode? autovalidateMode = AutovalidateMode.disabled;
  var titleController = TextEditingController();
  var noteController = TextEditingController();
  var dateController = TextEditingController();
  var addTaskGroupNameController = TextEditingController();
  var addTaskController = TextEditingController();

//---------------------------------------------------------------------------------

  Future<List<TaskGroupModel>> getTasksListName() async {
    emit(GetTaskListNameLoading());

    try {
      String userId = await LocalServices.getData(key: 'userId');
      print(userId);

      http.Response response =
          await http.get(Uri.parse(constructUserTaskLists(userId)));

      if (response.statusCode != 200) {
        emit(GetTaskListNameError(
            'Failed to fetch task lists. Status code: ${response.statusCode}'));
        return [];
      }

      Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;

      List<TaskGroupModel> tasks = [];

      if (data.containsKey('documents') && data['documents'] is List) {
        for (var document in data['documents'] as List<dynamic>) {
          Map<String, dynamic> fields =
              document['fields'] as Map<String, dynamic>;
          String taskListId = document['name'].split('/').last as String;
          int taskCount = await getTasksCount(userId, taskListId);

          TaskGroupModel task = TaskGroupModel(
            name: fields['name']['stringValue'],
            id: taskListId,
            count: taskCount,
          );
          tasks.add(task);
        }
      } else {
        emit(const GetTaskListNameError('Please Add Task List'));
        return [];
      }

      emit(GetTaskListNameSuccess(tasks));
      return tasks;
    } catch (error) {
      emit(GetTaskListNameError('An error occurred: $error'));
      print(error);
      return [];
    }
  }

  Future<int> getTasksCount(String userId, String taskListId) async {
    int count = 0;
    http.Response response =
        await http.get(Uri.parse(constructUserTasks(userId, taskListId)));

    if (response.statusCode == 200) {
      Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      if (data.containsKey('documents')) {
        count = data['documents'].length;
      }
    } else {
      emit(const GetTaskListNameError('Failed to retrieve documents.'));
      debugPrint(
          'Failed to retrieve documents. Status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
    }
    return count;
  }
//-------------------------------------------------------------------------------------------------

  Future<String?> addTaskListWithName(String name) async {
    var userId = await LocalServices.getData(key: 'userId');

    final Map<String, dynamic> data = {
      'fields': {
        'name': {'stringValue': name}
      }
    };

    final String jsonData = json.encode(data);

    final response = await http.post(
      Uri.parse(constructUserTaskLists(userId)),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody =
          json.decode(response.body) as Map<String, dynamic>;
      final String documentId = responseBody['name'] as String;
      emit(AddTaskListSuccess());

      print('Document added successfully. Document ID: $documentId');
      return documentId;
    } else {
      print('Failed to add document. Status code: ${response.statusCode}');
      emit(
        AddTaskListError(
          'Failed to add document. Status code: ${response.statusCode}',
        ),
      );
      print('Response body: ${response.body}');
      return null;
    }
  }

//-------------------------------------------------------------------------------------------------
  Future<void> deleteTaskList({required String taskListId}) async {
    var userId = await LocalServices.getData(key: 'userId');

    final response = await http.delete(
      Uri.parse(modifyUserTasks(userId, taskListId)),
    );

    debugPrint(taskListId);
    if (response.statusCode == 200) {
      debugPrint('Document deleted successfully.');
      getTasksListName();
    } else {
      debugPrint(
          'Failed to delete document. Status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
    }
  }
  //-------------------------------------------------------------------------------------------------

  Future<void> updateTaskListName(
      {required String taskListId, required String newName}) async {
    var userId = await LocalServices.getData(key: 'userId');

    final Map<String, dynamic> data = {
      'fields': {
        'name': {'stringValue': newName}
      }
    };
    final String jsonData = json.encode(data);
    final response = await http.patch(
      Uri.parse(modifyUserTasks(userId, taskListId)),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );
    if (response.statusCode == 200) {
      debugPrint('Document updated successfully.');
      getTasksListName();
    } else {
      debugPrint(
          'Failed to update document. Status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
    }
  }

//-------------------------------------------------------------------------------------------------
  List<AllTaskModel> allTasks = [];
  Future<http.Response> getTasks(String taskListId) async {
    emit(GetAllTasksLoading());
    var userId = await LocalServices.getData(key: 'userId');

    try {
      http.Response response =
          await http.get(Uri.parse(constructUserTasks(userId, taskListId)));

      if (response.statusCode != 200) {
        // Handle non-200 status codes
        emit(GetAllTasksErrorState(
            'Failed to fetch tasks, status code: ${response.statusCode}'));
        return http.Response(
            jsonEncode({
              'error':
                  'Failed to fetch tasks, status code: ${response.statusCode}'
            }),
            response.statusCode);
      }

      Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;


      allTasks.clear(); // Clear previous tasks before adding new ones
      var tasksResponse = TasksResponse.fromJson(data);

      if (tasksResponse.documents.isNotEmpty) {
        allTasks.addAll(tasksResponse.documents);
        allTasks.sort((a, b) => a.date.compareTo(b.date));
        emit(GetAllTasksSuccessState(allTasks));
      } else {
        emit(const GetAllTasksErrorState('No tasks found'));
      }

      List<Map<String, dynamic>> tasksJson =
          allTasks.map((task) => task.toJson()).toList();

      return http.Response(jsonEncode(tasksJson), 200,
          headers: {'Content-Type': 'application/json'});
    } catch (error) {
      emit(GetAllTasksErrorState(error.toString()));
      print(error.toString());
      return http.Response(
          jsonEncode({'error': 'An error occurred: $error'}), 500,
          headers: {'Content-Type': 'application/json'});
    }
  }

//-------------------------------------------------------------------------------------------------
  Future<void> addTask(String taskListId, String name, String dateTime) async {
    emit(AddTaskLoading());
    var userId = await LocalServices.getData(key: 'userId');

    // Convert the date and time string to DateTime
    final DateTime taskDate =
        DateFormat('dd/MM/yyyy hh:mm a').parse(dateTime).toUtc();

    final Map<String, dynamic> data = {
      'fields': {
        'name': {'stringValue': name},
        'date': {'timestampValue': taskDate.toIso8601String()},
        'done': {'booleanValue': false},
      },
    };

    final String jsonData = json.encode(data);

    final response = await http.post(
      Uri.parse(constructUserTasks(userId, taskListId)),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    if (response.statusCode == 200) {
      emit(AddTaskSuccess());
      print('Document added successfully.');
    } else {
      emit(AddTaskError(
        'Failed to add document. Status code: ${response.statusCode}',
      ));
      print('Failed to add document. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

//-------------------------------------------------------------------------------------------------
  Future<void> updateTask({
    required String taskListId,
    required String taskId,
    required String name,
    required String date,
  }) async {
    var userId = await LocalServices.getData(key: 'userId');

    DateTime taskDate = DateTime.parse(date).toUtc();

    final Map<String, dynamic> data = {
      'fields': {
        'name': {'stringValue': name},
        'date': {'timestampValue': taskDate.toIso8601String()},
        'done': {
          'booleanValue': false,
        },
      }
    };

    final String jsonData = json.encode(data);

    final response = await http.patch(
      Uri.parse(constructUserTask(userId, taskListId, taskId)),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    if (response.statusCode == 200) {
      print('Task updated successfully.');
      getTasks(taskListId);
    } else {
      print('Failed to update task. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

//-------------------------------------------------------------------------------------------------
  Future<void> deleteTask(
      {required String taskListId, required String taskId}) async {
    var userId = await LocalServices.getData(key: 'userId');

    final response = await http.delete(
      Uri.parse(constructUserTask(userId, taskListId, taskId)),
    );

    if (response.statusCode == 200) {
      print('Document deleted successfully.');
      getTasks(taskListId);
    } else {
      emit(DeleteTaskFromListError(
        'Failed to delete document. Status code: ${response.statusCode}',
      ));
      print('Failed to delete document. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

//-------------------------------------------------------------------------------------------------

  Future<bool> toggleTaskDone(String taskListId, String taskId) async {
    var userId = await LocalServices.getData(key: 'userId');

    String fetchUrl = constructUserTask(userId, taskListId, taskId);
    http.Response fetchResponse = await http.get(Uri.parse(fetchUrl));

    if (fetchResponse.statusCode != 200) {
      print(
          'Failed to retrieve task. Status code: ${fetchResponse.statusCode}');
      print('Response body: ${fetchResponse.body}');
      return false;
    }

    Map<String, dynamic> taskData =
        jsonDecode(fetchResponse.body) as Map<String, dynamic>;
    Map<String, dynamic> fields = taskData['fields'] as Map<String, dynamic>;

    if (fields.containsKey('done') && fields['done']['booleanValue'] == true) {
      fields['done'] = {'booleanValue': false};
    } else {
      fields['done'] = {'booleanValue': true};
    }

    String updateUrl = constructUserTask(userId, taskListId, taskId);
    http.Response updateResponse = await http.patch(
      Uri.parse(updateUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'fields': fields}),
    );

    print(updateResponse.body);

    if (updateResponse.statusCode == 200) {
      getTasks(taskListId);
      return true;
    } else {
      print(
          'Failed to update task. Status code: ${updateResponse.statusCode}');
      print('Response body: ${updateResponse.body}');
      return false;
    }
  }

  Future<void> addTaskBychatbot(String name, String date) async {
    String taskListId = '';
    var userId = await LocalServices.getData(key: 'userId');
    String taskListIdFromBD = '';
    List<String> names = [];
    http.Response response =
        await http.get(Uri.parse(constructUserTaskLists(userId)));
    Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;
    if (data.containsKey('documents')) {
      for (var document in data['documents'] as List<dynamic>) {
        Map<String, dynamic> fields =
            document['fields'] as Map<String, dynamic>;
        taskListIdFromBD = document['name'].split('/').last as String;
        String tasklistname = fields['name']['stringValue'] as String;
        names.add(tasklistname);
      }
    }
    if (names.contains('Tasks added by chatbot')) {
      taskListId = taskListIdFromBD;
      print('yes');
    } else {
      print('no');
      String? id = await addTaskListWithName('Tasks added by chatbot');
      taskListId = id!.split('/').last;
    }

    await addTask(taskListId, name, date);
  }

//-------------------------------------------------------------------------------------------------
  Future<List<Map<String, dynamic>>> getTasksByDate(String date) async {
    DateTime targetDate = DateTime.parse(date).toUtc();
    targetDate = targetDate.add(const Duration(hours: 2));
    List<Map<String, dynamic>> tasks = [];
    String targetDateString = targetDate
        .toIso8601String()
        .split('T')
        .first; // Extract only the date part

    await getSubCollectionFromTasks(targetDateString, tasks);

    return tasks;
  }

  Future<List<Map<String, dynamic>>> getTasksByDateDone(String date) async {
    DateTime targetDate = DateTime.parse(date).toUtc();
    targetDate = targetDate.add(const Duration(hours: 2));
    List<Map<String, dynamic>> tasks = [];
    String targetDateString = targetDate
        .toIso8601String()
        .split('T')
        .first; // Extract only the date part

    await getSubCollectionFromTasksDone(targetDateString, tasks);

    print(tasks);

    return tasks;
  }

  Future<List<Map<String, dynamic>>> getTasksByDateUndone(String date) async {
    DateTime targetDate = DateTime.parse(date).toUtc();
    targetDate = targetDate.add(const Duration(hours: 2));
    List<Map<String, dynamic>> tasks = [];
    String targetDateString = targetDate
        .toIso8601String()
        .split('T')
        .first; // Extract only the date part

    await getSubCollectionFromTasksUndone(targetDateString, tasks);

    print(tasks);

    return tasks;
  }

  Future<List<Map<String, dynamic>>> getSubCollectionFromTasks(
      String targetDateString, List<Map<String, dynamic>> tasks) async {
    String url = constructUserTaskLists(userId);
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      print(
          'Failed to retrieve collection. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;

    if (data.containsKey('documents')) {
      for (var document in data['documents'] as List<dynamic>) {
        String documentId = document['name'] as String;
        String subCollectionURL =
            'https://firestore.googleapis.com/v1/$documentId/tasks';
        http.Response subCollectionResponse =
            await http.get(Uri.parse(subCollectionURL));
        Map<String, dynamic> subCollectionData =
            jsonDecode(subCollectionResponse.body) as Map<String, dynamic>;
        String tasklistId = document['name'].split('/').last as String;

        if (subCollectionData.containsKey('documents')) {
          for (var nestedCollection
              in subCollectionData['documents'] as List<dynamic>) {
            Map<String, dynamic> fields =
                nestedCollection['fields'] as Map<String, dynamic>;
            String taskId = nestedCollection['name'].split('/').last as String;

            if (fields.containsKey('date')) {
              DateTime dataTime =
                  DateTime.parse(fields['date']['timestampValue'] as String)
                      .add(const Duration(hours: 2));
              String taskDate = dataTime.toString();
              String taskDateString = taskDate.split(' ').first;
              // print(taskDateString);
              if (taskDateString == targetDateString) {
                Map<String, dynamic> task = {
                  'fields': {
                    'name': fields['name']['stringValue'],
                    'taskId': taskId,
                    'tasklistId': tasklistId,
                    'date': DateTime.parse(
                            fields['date']['timestampValue'] as String)
                        .add(const Duration(hours: 2)),
                    'done': fields['done']['booleanValue'],
                  }
                };
                tasks.add(task);
              }
            } else {}
          }
        }
      }
    } else {
      print('No documents found in collection.');
    }
    tasks.sort((a, b) => a['fields']['date'].compareTo(b['fields']['date']));
    return tasks;
  }

  Future<List<Map<String, dynamic>>> getSubCollectionFromTasksDone(
      String targetDateString, List<Map<String, dynamic>> tasks) async {
    String url = constructUserTaskLists(userId);
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      print(
          'Failed to retrieve collection. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;

    if (data.containsKey('documents')) {
      for (var document in data['documents'] as List<dynamic>) {
        String documentId = document['name'] as String;
        String subCollectionURL =
            'https://firestore.googleapis.com/v1/$documentId/tasks';
        http.Response subCollectionResponse =
            await http.get(Uri.parse(subCollectionURL));
        Map<String, dynamic> subCollectionData =
            jsonDecode(subCollectionResponse.body) as Map<String, dynamic>;
        String tasklistId = document['name'].split('/').last as String;
        if (subCollectionData.containsKey('documents')) {
          for (var nestedCollection
              in subCollectionData['documents'] as List<dynamic>) {
            Map<String, dynamic> fields =
                nestedCollection['fields'] as Map<String, dynamic>;
            String taskId = nestedCollection['name'].split('/').last as String;

            if (fields.containsKey('date') &&
                fields.containsKey('done') &&
                fields['done']['booleanValue'] == true) {
              DateTime dataTime =
                  DateTime.parse(fields['date']['timestampValue'] as String)
                      .add(const Duration(hours: 2));
              String taskDate = dataTime.toString();
              String taskDateString = taskDate.split(' ').first;
              // print(taskDateString);
              if (taskDateString == targetDateString) {
                Map<String, dynamic> task = {
                  'fields': {
                    'name': fields['name']['stringValue'],
                    'taskId': taskId,
                    'tasklistId': tasklistId,
                    'date': DateTime.parse(
                            fields['date']['timestampValue'] as String)
                        .add(const Duration(hours: 2)),
                    'done': fields['done']['booleanValue'],
                  }
                };
                tasks.add(task);
              }
            } else {}
          }
        }
      }
    } else {
      print('No documents found in collection.');
    }
    tasks.sort((a, b) => a['fields']['date'].compareTo(b['fields']['date']));
    return tasks;
  }

  Future<List<Map<String, dynamic>>> getSubCollectionFromTasksUndone(
      String targetDateString, List<Map<String, dynamic>> tasks) async {
    String url = constructUserTaskLists(userId);
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      print(
          'Failed to retrieve collection. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;

    if (data.containsKey('documents')) {
      for (var document in data['documents'] as List<dynamic>) {
        String documentId = document['name'] as String;
        String subCollectionURL =
            'https://firestore.googleapis.com/v1/$documentId/tasks';
        http.Response subCollectionResponse =
            await http.get(Uri.parse(subCollectionURL));
        Map<String, dynamic> subCollectionData =
            jsonDecode(subCollectionResponse.body) as Map<String, dynamic>;
        String tasklistId = document['name'].split('/').last as String;
        if (subCollectionData.containsKey('documents')) {
          for (var nestedCollection
              in subCollectionData['documents'] as List<dynamic>) {
            Map<String, dynamic> fields =
                nestedCollection['fields'] as Map<String, dynamic>;
            String taskId = nestedCollection['name'].split('/').last as String;

            if (fields.containsKey('date') &&
                fields.containsKey('done') &&
                fields['done']['booleanValue'] == false) {
              DateTime dataTime =
                  DateTime.parse(fields['date']['timestampValue'] as String)
                      .add(const Duration(hours: 2));
              String taskDate = dataTime.toString();
              String taskDateString = taskDate.split(' ').first;
              // print(taskDateString);
              if (taskDateString == targetDateString) {
                Map<String, dynamic> task = {
                  'fields': {
                    'name': fields['name']['stringValue'],
                    'taskId': taskId,
                    'tasklistId': tasklistId,
                    'date': DateTime.parse(
                            fields['date']['timestampValue'] as String)
                        .add(const Duration(hours: 2)),
                    'done': fields['done']['booleanValue'],
                  }
                };
                tasks.add(task);
              }
            } else {}
          }
        }
      }
    } else {
      print('No documents found in collection.');
    }
    tasks.sort((a, b) => a['fields']['date'].compareTo(b['fields']['date']));
    return tasks;
  }

  Future<List<Map<String, dynamic>>> getTodaysTasks() async {
    final DateTime targetDate = DateTime.now().toUtc();
    List<Map<String, dynamic>> events = [];
    String targetDateString = targetDate
        .toIso8601String()
        .split('T')
        .first; // Extract only the date part

    await getSubCollectionFromTasks(targetDateString, events);

    return events;
  }

  int precentNum = 0;
  Future<int> calculateDoneTasksPercentage(String date) async {
    List<Map<String, dynamic>> doneTasks = await getTasksByDateDone(date);
    List<Map<String, dynamic>> undoneTasks = await getTasksByDateUndone(date);
    int undoneTasksCount = undoneTasks.length;
    int doneTasksCount = doneTasks.length;
    int totalTasks = doneTasksCount + undoneTasksCount;

    double percentageDone = (doneTasksCount / totalTasks) * 100;
    int precent = percentageDone.ceil();
    precentNum = precent;
    emit(TaskPercentageDone(precent: precent));
    print("precent: $precent");
    return precent;
  }

  //-------------------------------------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> getStudentSchedule() async {
    // var userId = LocalServices.getData(key: 'userId');
    String grade = LocalServices.getData(key: 'yearId');
    List<Map<String, dynamic>> schedule = [];

    http.Response response =
        await http.get(Uri.parse(constructUserDays(grade.toString())));

    if (response.statusCode == 200) {
      Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      if (data.containsKey('documents') && data['documents'] != null) {
        for (var document in data['documents'] as List<dynamic>) {
          dynamic day = document['name'].split('/').last;
          http.Response response = await http
              .get(Uri.parse(constructUserClasses(grade.toString(), day)));
          Map<String, dynamic> data =
              jsonDecode(response.body) as Map<String, dynamic>;
          for (var document in data['documents'] as List<dynamic>) {
            Map<String, dynamic> fields =
                document['fields'] as Map<String, dynamic>;
            dynamic name = fields['name']['stringValue'];
            schedule.add({'day': day.toString(), 'subject': name.toString()});
          }
        }
      } else {
        print('No documents in response');
      }
    } else {
      print(
          'Failed to retrieve documents. Status code: ${response.statusCode}');
    }
    return schedule;
  }

  Future<void> studyPlan() async {
    var userId = LocalServices.getData(key: 'userId');
    String taskListId = '';
    String taskListIdFromBD = '';
    List<String> names = [];
    http.Response response =
        await http.get(Uri.parse(constructUserTaskLists(userId)));
    Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;
    if (data.containsKey('documents')) {
      for (var document in data['documents'] as List<dynamic>) {
        Map<String, dynamic> fields =
            document['fields'] as Map<String, dynamic>;
        taskListIdFromBD = document['name'].split('/').last as String;
        String tasklistname = fields['name']['stringValue'] as String;
        names.add(tasklistname);
      }
      print(names);
    }
    if (names.contains('Study Plan by Dupli')) {
      return;
    } else {
      print('no');
      String? id = await addTaskListWithName('Study Plan by Dupli');
      taskListId = id!.split('/').last;
    }
    String startDateStr = '2024-10-01';
    List<Map<String, dynamic>> studentSchedule = await getStudentSchedule();

    List<String> subjectNames =
        studentSchedule.map((entry) => entry['subject'] as String).toList();
    List<int> daysOfWeek = studentSchedule.map((entry) {
      switch (entry['day']) {
        case 'Monday':
          return 1;
        case 'Tuesday':
          return 2;
        case 'Wednesday':
          return 3;
        case 'Thursday':
          return 4;
        case 'Friday':
          return 5;
        case 'Saturday':
          return 6;
        case 'Sunday':
          return 7;
        default:
          return 1; // Default to Monday if day is unrecognized
      }
    }).toList();

    List<int> initialLectureNumbers =
        List<int>.generate(subjectNames.length, (index) => 1);
    int numWeeks = 12;

    // Generate the schedule
    List<Map<String, dynamic>> schedule = scheduleLectures(startDateStr,
        subjectNames, daysOfWeek, numWeeks, initialLectureNumbers);

    // Print the schedule
    for (var entry in schedule) {
      String title = '${entry['subject']} Lecture ${entry['lecture_number']}';
      String date = '${entry['date']}';
      addTaskWithNameAndDateStudyPlan(taskListId, title, date);
      print('Added: $date - $title');
    }
  }

  List<Map<String, dynamic>> scheduleLectures(
      String startDateStr,
      List<String> subjectNames,
      List<int> daysOfWeek,
      int numWeeks,
      List<int> initialLectureNumbers) {
    // var userId = LocalServices.getData(key: 'userId');
    DateTime startDate = DateTime.parse(startDateStr);
    DateTime currentDate = startDate;

    Map<String, int> subjectLectureNumbers = {
      for (int i = 0; i < subjectNames.length; i++)
        subjectNames[i]: initialLectureNumbers[i]
    };

    List<Map<String, dynamic>> schedule = [];

    for (int week = 0; week < numWeeks; week++) {
      for (int i = 0; i < subjectNames.length; i++) {
        String subject = subjectNames[i];
        int lectureDay = daysOfWeek[i];
        DateTime nextLectureDate = currentDate
            .add(Duration(days: (lectureDay - currentDate.weekday + 7) % 7));

        // Add lecture entry
        int lectureNumber = subjectLectureNumbers[subject]!;
        schedule.add({
          'date': nextLectureDate,
          'subject': subject,
          'type': 'lecture',
          'lecture_number': lectureNumber
        });

        subjectLectureNumbers[subject] = lectureNumber + 1;
      }
      // Move to the next week
      currentDate = currentDate.add(const Duration(days: 7));
    }

    // Sort schedule by date
    schedule.sort(
        (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));

    // Format dates to string after sorting
    for (var entry in schedule) {
      entry['date'] =
          DateFormat('yyyy-MM-dd').format(entry['date'] as DateTime);
    }

    return schedule;
  }

  Future<void> addTaskWithNameAndDateStudyPlan(
      String taskListId, String name, String date) async {
    var userId = LocalServices.getData(key: 'userId');
    final DateTime taskDate = DateTime.parse(date).toUtc();
    final Map<String, dynamic> data = {
      'fields': {
        'name': {'stringValue': name},
        'date': {'timestampValue': taskDate.toIso8601String()},
        'done': {'booleanValue': 'false'}
      }
    };

    final String jsonData = json.encode(data);

    final response = await http.post(
      Uri.parse(constructUserTasks(userId, taskListId)),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    if (response.statusCode == 200) {
      print('Document added successfully.');
    } else {
      print('Failed to add document. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> addTaskWithName(String taskListId, String name) async {
    final Map<String, dynamic> data = {
      'fields': {
        'name': {'stringValue': name},
        'done': {'booleanValue': 'false'}
      }
    };
    final String jsonData = json.encode(data);

    final response = await http.post(
      Uri.parse(constructUserTasks(userId, taskListId)),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    if (response.statusCode == 200) {
      print('Document added successfully.');
    } else {
      print('Failed to add document. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
}
//----------------------------------------------------------------------------------------

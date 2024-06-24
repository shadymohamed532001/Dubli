// ignore_for_file: unused_local_variable

import 'package:dubli/core/helper/helper_const.dart';
import 'package:dubli/feature/tasks/data/models/all_tasks_name_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
part 'tasks_state.dart';

String userId = 'idfRXLBJ9GdUdXMwC2GR';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(HomeInitial());

  var formKey = GlobalKey<FormState>();
  AutovalidateMode? autovalidateMode = AutovalidateMode.disabled;
  var titleController = TextEditingController();
  var noteController = TextEditingController();
  var dateController = TextEditingController();
//---------------------------------------------------------------------------------

  List<Task> tasks = [];
  Future<http.Response> getTasksListName() async {
    emit(GetTaskListNameLoading());
    http.Response response =
        await http.get(Uri.parse(constructUserTaskLists(userId)));
    Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;

    for (var document in data['documents'] as List<dynamic>) {
      Map<String, dynamic> fields = document['fields'] as Map<String, dynamic>;
      String taskListId = document['name'].split('/').last as String;
      int taskCount = await getTasksCount(userId, taskListId);

      Task task = Task(
        name: fields['name']['stringValue'],
        id: taskListId,
        count: taskCount,
      );
      tasks.add(task);
    }

    print(tasks);

    List<Map<String, dynamic>> jsonTasks =
        tasks.map((task) => task.toJson()).toList();

    Map<String, dynamic> jsonResponse = {
      'documents': jsonTasks,
    };
    emit(GetTaskListNameSuccess(tasks));
    return http.Response(jsonEncode(jsonResponse), 200,
        headers: {'Content-Type': 'application/json'});
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
      print(
          'Failed to retrieve documents. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
    return count;
  }
//-------------------------------------------------------------------------------------------------

  Future<void> addTaskListWithName({required String name}) async {
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
      print('Document added successfully.');
      emit(AddTaskListSuccess());
    } else {
      emit(AddTaskListError(
          'Failed to add document. Status code: ${response.statusCode}'));

      print('Failed to add document. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> deleteTaskList({required String taskListId}) async {
    final response = await http.delete(
      Uri.parse(constructUserTasks(userId, taskListId)),
    );

    print(taskListId);
    if (response.statusCode == 200) {
      print('Document deleted successfully.');
    } else {
      print('Failed to delete document. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> updateTaskListName({required String taskListId,required String newName}) async {
    final Map<String, dynamic> data = {
      'fields': {
        'name': {'stringValue': newName}
      }
    };
    final String jsonData = json.encode(data);
    final response = await http.patch(
      Uri.parse(constructUserTasks(userId, taskListId)),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );
    if (response.statusCode == 200) {
      print('Document updated successfully.');
      getTasksListName();
    } else {
      print('Failed to update document. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  // Future<List<Map<String, dynamic>>> getAllTasks(String taskListId) async {
  //   List<Map<String, dynamic>> tasks = [];
  //   http.Response response =
  //       await http.get(Uri.parse(constructUserTasks(userId, taskListId)));

  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> data =
  //         jsonDecode(response.body) as Map<String, dynamic>;
  //     for (var document in data['documents'] as List<dynamic>) {
  //       Map<String, dynamic> fields =
  //           document['fields'] as Map<String, dynamic>;
  //       tasks.add(fields);
  //     }

  //     // 3alashan lw 3aiz takhod kol var lawdho
  //     // for (var fields in documentsFields) {
  //     //   fields.forEach((key, value) {
  //     //   //  print('$key: ${value.values.first}');
  //     //   });
  //     // }
  //   } else {
  //     print(
  //         'Failed to retrieve documents. Status code: ${response.statusCode}');
  //     print('Response body: ${response.body}');
  //   }
  //   return tasks;
  // }

  Future<List<Map<String, dynamic>>> getDoneTasks(String taskListId) async {
    List<Map<String, dynamic>> tasks = [];
    http.Response response =
        await http.get(Uri.parse(constructUserTasks(userId, taskListId)));

    if (response.statusCode == 200) {
      Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      for (var document in data['documents'] as List<dynamic>) {
        Map<String, dynamic> fields =
            document['fields'] as Map<String, dynamic>;
        if (fields.containsKey('done') &&
            fields['done']['booleanValue'] == true) {
          tasks.add(fields);
        }
      }

      // 3alashan lw 3aiz takhod kol var lawdho
      // for (var fields in documentsFields) {
      //   fields.forEach((key, value) {
      //     // print('$key: ${value.values.first}');
      //   });
      // }
    } else {
      print(
          'Failed to retrieve documents. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
    return tasks;
  }

  Future<List<Map<String, dynamic>>> getUnDoneTasks(String taskListId) async {
    List<Map<String, dynamic>> tasks = [];
    http.Response response =
        await http.get(Uri.parse(constructUserTasks(userId, taskListId)));

    if (response.statusCode == 200) {
      Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      for (var document in data['documents'] as List<dynamic>) {
        Map<String, dynamic> fields =
            document['fields'] as Map<String, dynamic>;
        if (fields.containsKey('done') &&
            fields['done']['booleanValue'] == false) {
          tasks.add(fields);
        }
      }

      // 3alashan lw 3aiz takhod kol var lawdho
      // for (var fields in documentsFields) {
      //   fields.forEach((key, value) {
      //     // print('$key: ${value.values.first}');
      //   });
      // }
    } else {
      print(
          'Failed to retrieve documents. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
    return tasks;
  }

  Future<void> addTask(String taskListId, String name, String date,
      int priority, String note) async {
    final DateTime taskDate = DateTime.parse(date).toUtc();
    final Map<String, dynamic> data = {
      'fields': {
        'name': {'stringValue': name},
        'date': {'timestampValue': taskDate.toIso8601String()},
        'priority': {'integerValue': priority},
        'note': {'stringValue': note},
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

  Future<void> addTaskWithNameAndDate(
      String taskListId, String name, String date) async {
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

  Future<Map<String, dynamic>> getTask(String taskListId, String taskId) async {
    final response = await http.get(
      Uri.parse(constructUserTask(userId, taskListId, taskId)),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      data = await data['fields'] as Map<String, dynamic>;
      return data;
    } else {
      print('Failed to retrieve task. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return {};
    }
  }

  Future<void> updateTask(String taskListId, String taskId, String name,
      String date, int priority, String note) async {
    final DateTime taskDate = DateTime.parse(date).toUtc();
    final Map<String, dynamic> data = {
      'fields': {
        'name': {'stringValue': name},
        'date': {'timestampValue': taskDate.toIso8601String()},
        'priority': {'integerValue': priority},
        'note': {'stringValue': note}
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
    } else {
      print('Failed to update task. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> deleteTask(String taskListId, String taskId) async {
    final response = await http.delete(
      Uri.parse(constructUserTask(userId, taskListId, taskId)),
    );

    if (response.statusCode == 200) {
      print('Document deleted successfully.');
    } else {
      print('Failed to delete document. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<bool> toggleTaskDone(String taskListId, String taskId) async {
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

    if (updateResponse.statusCode == 200) {
      return true;
    } else {
      print('Failed to update task. Status code: ${updateResponse.statusCode}');
      print('Response body: ${updateResponse.body}');
      return false;
    }
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

  Future<List<Map<String, dynamic>>> getTasksByDate(String date) async {
    final DateTime targetDate = DateTime.parse(date).toUtc();
    List<Map<String, dynamic>> events = [];
    String targetDateString = targetDate
        .toIso8601String()
        .split('T')
        .first; // Extract only the date part

    await getSubCollectionFromTasks(targetDateString, events);

    return events;
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
        // Map<String, dynamic> fields = document['fields'] as Map<String, dynamic>;
        // print('Document ID: $documentId'); // Debugging line
        // print('Document fields: $fields'); // Debugging line

        String subCollectionURL =
            'https://firestore.googleapis.com/v1/$documentId/tasks';
        http.Response subCollectionResponse =
            await http.get(Uri.parse(subCollectionURL));
        Map<String, dynamic> subCollectionData =
            jsonDecode(subCollectionResponse.body) as Map<String, dynamic>;

        if (subCollectionData.containsKey('documents')) {
          // print('Nested collections found!'); // Debugging line

          for (var nestedCollection
              in subCollectionData['documents'] as List<dynamic>) {
            Map<String, dynamic> fields =
                nestedCollection['fields'] as Map<String, dynamic>;
            //   print('Nested collection: $nestedCollection'); // Debugging line

            if (fields.containsKey('date') &&
                fields['date']['timestampValue'].startsWith(targetDateString)
                    as bool) {
              //print('found it!'); //Debugging line
              tasks.add(fields);
            } else {
              // print('not found'); //Debugging line
            }
          }
        }
      }
    } else {
      print('No documents found in collection.');
    }
    return tasks;
  }
}

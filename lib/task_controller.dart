import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'record_controller.dart';
import "task_model.dart";

Future<void> saveTasks(List<Task> tasks) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('tasks', jsonEncode(tasks));
}

Future<List<Task>> getTasks() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String tasksStr = prefs.getString("tasks");

  List tasksList = new List<Task>();
  if (tasksStr != null) {
    List<dynamic> jsonArray = json.decode(tasksStr);

    for (int i = 0; i < jsonArray.length; ++i) {
      tasksList.add(Task.fromJson(jsonArray[i]));
    }
  }

  return tasksList;
}

Future<void> addTask(Task task) async {
  List<Task> tasksList = await getTasks();
  tasksList.add(task);
  saveTasks(tasksList);
}

Future<void> removeTask(Task task) async {
  List<Task> tasksList = await getTasks();
  try {
    removeRecordsFromTask(task);
    tasksList.removeWhere((item) => item.id == task.id);
  } catch (e) {
    print("[Function removeTask in task_controller] Error:\n $e");
  }
  saveTasks(tasksList);
}

Future<void> editTask(Task task, String name, int color, String salary,
    String description) async {
  List<Task> tasksList = await getTasks();
  try {
    tasksList.singleWhere((item) => item.id == task.id).name = name;
    tasksList.singleWhere((item) => item.id == task.id).color = color;
    tasksList.singleWhere((item) => item.id == task.id).salary = salary;
    tasksList.singleWhere((item) => item.id == task.id).description =
        description;
  } catch (e) {
    print("[Function editTask in task_controller] Error:\n $e");
  }
  saveTasks(tasksList);
}

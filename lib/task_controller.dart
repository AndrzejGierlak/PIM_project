import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
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

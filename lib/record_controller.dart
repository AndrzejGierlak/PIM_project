import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "record_model.dart";
import 'task_model.dart';

Future<void> saveRecords(List<Record> tasks) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('records', jsonEncode(tasks));
}

Future<List<Record>> getRecords() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String recordsStr = prefs.getString("records");

  List recordsList = new List<Record>();
  if (recordsStr != null) {
    List<dynamic> jsonArray = json.decode(recordsStr);

    for (int i = 0; i < jsonArray.length; ++i) {
      recordsList.add(Record.fromJson(jsonArray[i]));
    }
  }

  return recordsList;
}

Future<void> addRecord(Record record) async {
  List<Record> recordsList = await getRecords();
  recordsList.add(record);
  saveRecords(recordsList);
}

Future<void> removeRecord(Record record) async {
  List<Record> recordsList = await getRecords();
  try {
    recordsList.removeWhere((item) => item.id == record.id);
  } catch (e) {
    print("[Function removeRecord in record_controller] Error:\n $e");
  }
  saveRecords(recordsList);
}

Future<void> updateRecord(Record record) async {
  List<Record> recordsList = await getRecords();
  recordsList.forEach((item) {
    if (item.id == record.id) {
      item.taskId = record.taskId;
      item.startDate = record.startDate;
      item.duration = record.duration;
    }
  });
  saveRecords(recordsList);
}

Future<void> removeRecordsFromTask(Task task) async {
  List<Record> recordsList = await getRecords();
  try {
    recordsList.removeWhere((item) => item.taskId == task.id);
  } catch (e) {
    print("[Function removeRecordsFromTask in record_controller] Error:\n $e");
  }
  saveRecords(recordsList);
}

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import "record_model.dart";

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

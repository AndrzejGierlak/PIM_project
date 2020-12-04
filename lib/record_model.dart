import 'package:flutter/material.dart';

class Record {
  int id;
  int taskId;
  DateTime startDate;
  TimeOfDay duration;

  Record({this.id, this.taskId, this.startDate, this.duration}) {
    id = DateTime.now().millisecondsSinceEpoch;
  }

  Record.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskId = json['taskId'];
    startDate = DateTime.fromMillisecondsSinceEpoch(json['startDate']);
    duration = new TimeOfDay(
        hour: json['duration_hour'], minute: json['duration_minute']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['taskId'] = this.taskId;
    data['startDate'] = this.startDate.millisecondsSinceEpoch;
    data['duration_hour'] = this.duration.hour;
    data['duration_minute'] = this.duration.minute;
    return data;
  }

  @override
  String toString() {
    return '"info" : { "id": $id, '
        '"taskId": $taskId, '
        '"startDate": $startDate,'
        '"duration": $duration,'
        '}';
  }
}
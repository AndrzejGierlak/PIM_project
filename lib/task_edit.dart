//TODO czas trwania danego zadania(rekordu), nazwa zadania,data ,start,
// TODO stop, dodaj określony czas(popup odkiedy do kiedy?), podaj stawkę godzinową
import 'package:flutter/material.dart';
import 'task_list.dart';
import "task_model.dart";

class TaskEditRoute extends StatelessWidget {
  final Task passedTask;
  TaskEditRoute({Key key, @required this.passedTask}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Single Task"),
      ),
      body: Center(
          child: Column(children: <Widget>[
        //Text(passedRecord.info.duration),
        Text('Task name: ' + passedTask.name),
        Text('Description: ' + passedTask.description),
        Text('TaskId: $passedTask.id'),
        Text('Color: ' + passedTask.color.toString()),
        Text('Salary: ' + passedTask.salary),
      ])),
    );
  }
}

//TODO czas trwania danego zadania(rekordu), nazwa zadania,data ,start,
// TODO stop, dodaj określony czas(popup odkiedy do kiedy?), podaj stawkę godzinową
import 'package:flutter/material.dart';
import 'package:pim_core_app/task_list.dart';

class TaskEditRoute extends StatelessWidget {
  final Task passedTask;
  TaskEditRoute({Key key, @required this.passedTask}): super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Single Task"),
      ),
      body: Center(
          child: Column(
              children: <Widget>[
                //Text(passedRecord.info.duration),
                Text('Task name: '+passedTask.info.name),
                Text('Description: '+passedTask.info.description),
                Text('TaskId: '+passedTask.info.id),
                Text('Color: '+passedTask.info.color),
                Text('Salary: '+passedTask.info.salary),
              ]
          )

      ),
    );
  }
}
//TODO czas trwania danego zadania(rekordu), nazwa zadania,data ,start,
// TODO stop, dodaj określony czas(popup odkiedy do kiedy?), podaj stawkę godzinową
import 'package:flutter/material.dart';
import 'package:pim_core_app/record_list.dart';


class RecordEditRoute extends StatelessWidget {

  final Record passedRecord;
  RecordEditRoute({Key key, @required this.passedRecord}): super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Single Record"),
      ),
      body: Center(
        child: Column(
            children: <Widget>[
              //Text(passedRecord.info.duration),
            Text('Duration: '+passedRecord.info.duration),
            Text('Start date: '+passedRecord.info.startDate),
              Text('TaskId: '+passedRecord.info.taskId),
              Text('This record id: '+passedRecord.info.id),
        ]
        )

      ),
    );
  }
}
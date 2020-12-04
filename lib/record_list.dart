//TODO stworzyć listę poszczególnych rekordów, wzorując się na task_list
//TODO trzeba ustlic wlasny format recordu
//TODO do listy trzeba dostawac się po identyfikatorze taska
//TODO z tego ekranu mamy miec mozliwosc onTap() => na dany(kliknięty) task_record i tam otworzyć dane nawet na samych textField

//TODO to ponizej jest w większości do wywalenia

//TODO lista nazw tasków- ską będzie można przejść do edycji każdego taska

import 'package:flutter/material.dart';
import 'menu_drawer.dart';
import 'record_edit.dart';
import 'record_model.dart';

class TaskRecordListRoute extends StatelessWidget {
  //ponizsze wymaga task id przy tworzeniu
  final String parentTaskId;
  TaskRecordListRoute({Key key, @required this.parentTaskId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(),
      appBar: AppBar(
        title: Text("Record list (of specified task)"),
      ),
      body: RecordListWidget(parentTaskId: this.parentTaskId),
    );
  }
}

class RecordListWidget extends StatefulWidget {
  final String parentTaskId;
  RecordListWidget({Key key, @required this.parentTaskId}) : super(key: key);

  @override
  _RecordListWidgetState createState() =>
      _RecordListWidgetState(parentTaskId: this.parentTaskId);
}

class _RecordListWidgetState extends State<RecordListWidget> {
  final String parentTaskId;
  _RecordListWidgetState({Key key, @required this.parentTaskId}) : super();

  List<Record> recordList = List<Record>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemBuilder: (context, index) {
          physics:
          ClampingScrollPhysics();
          return Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                child: Container(
                  height: 30,
                  color: Colors.blue,
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Text(
                          recordList[index].startDate.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      )),
                ),
                //TODO tu zaimplementuj wyswietlanie danego recordu
                onTap: () => {
                  //print("Pushowany taskID to : "+taskList[index].getId()),
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RecordEditRoute(passedRecord: recordList[index]),
                    ),
                  ),
                },
                onLongPress: () => {
                },
              ));
        },
        itemCount: recordList.length,
      ),
    );
  }
}


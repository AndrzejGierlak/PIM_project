import 'package:flutter/material.dart';
import 'package:time_management/record_controller.dart';
import 'package:time_management/record_new.dart';
import "task_model.dart";
import "task_controller.dart";
import "record_model.dart";

class HomePageRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = List<Task>();
  List<Record> _records = new List<Record>();

  @override
  void initState() {
    super.initState();

    initTestData().then((value) => setState(() {}));
  }

  Future<void> initTestData() async {
    _tasks = await getTasks();
    _records = await getRecords();
  }

  void _addNewRecord() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecordNewWidget(tasks: _tasks,)),
    );
  }

  Widget _buildRow(Record record) {
    return Card(
      child: ListTile(
        title:
            Text(record.startDate.toString(), style: TextStyle(fontSize: 18.0)),
        onTap: () => {},
        onLongPress: () => {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rejestr"),
        actions: [IconButton(icon: Icon(Icons.add_box), onPressed: _addNewRecord)],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          physics:
          ClampingScrollPhysics();
          return Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                child: Container(
                  height: 60,
                  color: Colors.blue,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(children: <Widget>[
                        //Text(passedRecord.info.duration),
                        Text(
                          _records[index].startDate.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
                onTap: () => {},
              ));
        },
        itemCount: _records.length,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
          },
          child: Icon(Icons.play_arrow, size: 50)),
    );
  }
}

//TaskRecordListRoute(parentTaskId: taskList[index].getId()),

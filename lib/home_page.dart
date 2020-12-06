import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_management/record_controller.dart';
import 'package:time_management/record_new.dart';
import 'menu_drawer.dart';
import "task_model.dart";
import "task_controller.dart";
import "record_model.dart";

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = List<Task>();
  List<Record> _records = new List<Record>();
  Map _groupedRecords = new Map<int, List<Record>>();

  @override
  void initState() {
    super.initState();

    initTestData().then((value) => setState(() {
          _groupedRecords = groupRecords(_records);
        }));
  }

  Map<int, List<Record>> groupRecords(List<Record> records) {
    Map groupedRecords = new Map<int, List<Record>>();

    print(records.length);

    for (int i = 0; i < records.length; ++i) {
      final DateTime sd = records[i].startDate;
      final int key =
          DateTime(sd.year, sd.month, sd.day).millisecondsSinceEpoch;
      if (groupedRecords[key] == null) {
        groupedRecords[key] = new List<Record>();
      }
      groupedRecords[key].add(records[i]);
    }

    return groupedRecords;
  }

  Future<void> initTestData() async {
    _tasks = await getTasks();
    _records = await getRecords();
  }

  void _addNewRecord() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RecordNewWidget(
                tasks: _tasks,
              )),
    );
  }

  String formatDate(DateTime date) {
    String formatted =
        "${DateFormat.E("pl_PL").format(date)}, ${DateFormat.yMd("pl_PL").format(date)}";
    return formatted;
  }

  String formatTime(DateTime startTime, TimeOfDay duration) {
    String formatted = "${DateFormat.Hm("pl_PL").format(startTime)}\n";

    if (duration.hour == 0) {
      formatted += "${duration.minute} min.";
    } else {
      formatted += "${duration.hour} godz. ${duration.minute} min.";
    }
    return formatted;
  }

  Task findTask(int taskID) {
    return _tasks.firstWhere((e) => e.id == taskID);
  }

  List<Widget> _buildRecordslist(int key) {
    final List<Record> records = _groupedRecords[key];
    final List tiles = new List<Widget>();

    for (int i = 0; i < records.length; ++i) {
      final Record record = records[i];
      final Task assignedTask = findTask(record.taskId);
      tiles.add(new ListTile(
        leading: Icon(
          Icons.brightness_1_rounded,
          color: Color(assignedTask.color),
        ),
        title: Text(assignedTask.name, style: TextStyle(fontSize: 18.0)),
        trailing: Text(
          formatTime(record.startDate, record.duration),
          style: TextStyle(fontSize: 14.0),
          textAlign: TextAlign.right,
        ),
        onTap: () => {},
        onLongPress: () => {},
      ));
    }

    return tiles;
  }

  Widget _buildRow(int key) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(key);

    return Padding(
        padding: EdgeInsets.only(bottom: 2.0),
        child: Card(
            child: ExpansionTile(
          title: Text(formatDate(date), style: TextStyle(fontSize: 18.0)),
          children: _buildRecordslist(key),
        )));
  }

  Widget _buildDatesList() {
    List<int> keys = _groupedRecords.keys.toList()..sort((a, b) => b.compareTo(a));
    return ListView.builder(
      itemBuilder: (context, i) {
        return _buildRow(keys[i]);
      },
      itemCount: _groupedRecords.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(),
      appBar: AppBar(
        title: Text("Rejestr"),
        actions: [
          IconButton(icon: Icon(Icons.add_box), onPressed: _addNewRecord)
        ],
      ),
      body: Center(child: _buildDatesList()),
      floatingActionButton: FloatingActionButton(
          onPressed: () {}, child: Icon(Icons.play_arrow, size: 50)),
    );
  }
}

//TaskRecordListRoute(parentTaskId: taskList[index].getId()),

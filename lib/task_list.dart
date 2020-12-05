//TODO lista nazw tasków- ską będzie można przejść do edycji każdego taska

import 'package:flutter/material.dart';
import 'package:time_management/menu_drawer.dart';
import 'task_edit.dart';

import 'task_new.dart';
import "task_model.dart";
import "task_controller.dart";

class TaskListRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DemoScreen();
  }
}

class DemoScreen extends StatefulWidget {
  @override
  _DemoScreenState createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  List<Task> taskList = List<Task>();

  @override
  void initState() {
    super.initState();
    initTestData().then((value) => setState(() {}));
  }

  Future<void> initTestData() async {
    taskList = await getTasks();
  }

  Widget _buildTaskList() {
    return ListView.builder(
      itemBuilder: (context, i) {
        return _buildRow(taskList[i]);
      },
      itemCount: taskList.length,
    );
  }

  Widget _buildRow(Task task) {
    return Padding(
        padding: EdgeInsets.all(2.0),
        child: Card(
          child: ListTile(
            leading: Icon(
              Icons.brightness_1_rounded,
              color: Color(task.color),
            ),
            title: Text(task.name, style: TextStyle(fontSize: 18.0)),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskEditRoute(passedTask: task),
                ),
              )
            },
            onLongPress: () => {},
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(),
      appBar: AppBar(
        title: Text("Task list"),
      ),
      body: Center(child: _buildTaskList()),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaskNewRoute()),
            );
          },
          child: Icon(Icons.add, size: 50)),
    );
  }
}

//---------------------------------------------------------------------------------------

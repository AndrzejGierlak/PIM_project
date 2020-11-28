// TODO Implement this library.
// TODO https://flutter.dev/docs/cookbook/navigation/navigation-basics
import 'package:flutter/material.dart';
import 'package:time_management/menu_drawer.dart';

import 'help.dart';
import 'home_page.dart';
import 'record_edit.dart';
import 'record_list.dart';
import 'record_new.dart';
import 'task_list.dart';
import 'task_new.dart';
import 'task_statistics.dart';


class MenuRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Route(testing only)"),
      ),
      drawer: MenuDrawer(),
      body: Center(
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton(
              child: Text('Open HomePage'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePageRoute()),
                );
              },
            ),
            ElevatedButton(
              child: Text('Open Task Record'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecordEditRoute()),
                );
              },
            ),
            ElevatedButton(
              child: Text('Open TaskNew'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaskNewRoute()),
                );
              },
            ),
            ElevatedButton(
              child: Text('Open RecordNew'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecordNewRoute()),
                );
              },
            ),
            ElevatedButton(
              child: Text('Open TaskList',style: TextStyle(color: Colors.red.withOpacity(1.0)),),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaskListRoute()),
                );
              },
            ),
            ElevatedButton(
              child: Text('Record List direct view'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaskRecordListRoute()),
                );
              },
            ),
            ElevatedButton(
              child: Text('Open TaskStatistics'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaskStatisticsRoute()),
                );
              },
            ),
            ElevatedButton(
              child: Text('Open Help'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpRoute()),
                );
              },
            ),

          ],
        )
      ),
    );
  }
}
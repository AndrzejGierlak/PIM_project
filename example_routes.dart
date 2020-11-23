// TODO Implement this library.
// TODO https://flutter.dev/docs/cookbook/navigation/navigation-basics
import 'package:flutter/material.dart';
import 'package:pim_core_app/task_list.dart';
import 'package:pim_core_app/task_statistics.dart';
import 'package:pim_core_app/help.dart';
import 'package:pim_core_app/home_page.dart';
import 'package:pim_core_app/task_edition.dart';
import 'package:pim_core_app/task_new.dart';

class FirstRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Route'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Open route'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondRoute()),
            );
          },
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

class MenuRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Route(testing only)"),
      ),
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
              child: Text('Open TaskEdition'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaskEditionRoute()),
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
              child: Text('Open TaskList'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaskListRoute()),
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
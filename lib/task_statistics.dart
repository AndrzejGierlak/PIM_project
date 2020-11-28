//TODO zostawiłbym to wojtkowi najchętniej

import 'package:flutter/material.dart';

import 'menu_drawer.dart';

class TaskStatisticsRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(),
      appBar: AppBar(
        title: Text("Task Statistics"),
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
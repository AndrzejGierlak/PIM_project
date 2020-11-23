//TODO czas trwania danego zadania(rekordu), nazwa zadania,data ,start,
// TODO stop, dodaj określony czas(popup odkiedy do kiedy?), podaj stawkę godzinową
import 'package:flutter/material.dart';

class TaskEditionRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task edition"),
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
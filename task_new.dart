//TODO nowe zadanie- podaj nazwę,opis, kolor, stawka godzinowa?
import 'package:flutter/material.dart';

class TaskNewRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nowe zadanie"),
      ),
      body: TaskNewWidget(),
    );
  }
}


/// This is the stateful widget that the main application instantiates.
/// https://api.flutter.dev/flutter/widgets/Form-class.html
class TaskNewWidget extends StatefulWidget {
  TaskNewWidget({Key key}) : super(key: key);

  @override
  _TaskNewWidgetState createState() => _TaskNewWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _TaskNewWidgetState extends State<TaskNewWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Task name',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter name of task';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Task color',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter color of task';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Salary per hour of work',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter cash/hour';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Task description',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter description of task';
              }
              return null;
            },
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState.validate()) {
                  // Process data.
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
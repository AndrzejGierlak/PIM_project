//TODO nowe zadanie- podaj nazwę,opis, kolor, stawka godzinowa?
import 'package:flutter/material.dart';

class RecordNewRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nowy record"),
      ),
      body: RecordNewWidget(),
    );
  }
}


/// This is the stateful widget that the main application instantiates.
/// https://api.flutter.dev/flutter/widgets/Form-class.html
class RecordNewWidget extends StatefulWidget {
  RecordNewWidget({Key key}) : super(key: key);

  @override
  _RecordNewWidgetState createState() => _RecordNewWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _RecordNewWidgetState extends State<RecordNewWidget> {
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
              hintText: 'Record start date',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter date of start';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Record duration',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter duration of record';
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
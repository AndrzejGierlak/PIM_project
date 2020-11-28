//TODO nowe zadanie- podaj nazwę,opis, kolor, stawka godzinowa?
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class TaskNewRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TaskNewWidget();
  }
}

class TaskNewWidget extends StatefulWidget {
  TaskNewWidget({Key key}) : super(key: key);

  @override
  _TaskNewWidgetState createState() => _TaskNewWidgetState();
}

class _TaskNewWidgetState extends State<TaskNewWidget> {
  final _formKey = GlobalKey<FormState>();
  Color _currentColor = Colors.cyan;
  final _colorController = TextEditingController(text: Colors.cyan.value.toRadixString(16).toUpperCase());

  @override
  void dispose() {
    _colorController.dispose();
    super.dispose();
  }

  String _colorToString(Color color) {
    return color.value.toRadixString(16).toUpperCase();
  }

  void changeColor(Color color) => setState(() {
    _currentColor = color;
    _colorController.text = _colorToString(color);
  });

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: "Nazwa zadania",
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Podaj nazwę zadania!';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: "Opis zadania",
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _colorController,
              readOnly: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.brightness_1_rounded, color: _currentColor),
                labelText: "Kolor",
                border: const OutlineInputBorder(),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Select a color'),
                      content: SingleChildScrollView(
                        child: BlockPicker(
                          pickerColor: _currentColor,
                          onColorChanged: changeColor,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    initialValue: "0",
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Stawka godzinowa",
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    initialValue: "zł",
                    decoration: const InputDecoration(
                      labelText: "Waluta",
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _submitForm() {
    // Validate will return true if the form is valid, or false if
    // the form is invalid.
    if (_formKey.currentState.validate()) {
      // Process data.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Dodaj nowe zadanie"),
          actions: [IconButton(icon: Icon(Icons.save), onPressed: _submitForm)],
        ),
        body: SingleChildScrollView(
          child: _buildForm(),
        ));
  }
}

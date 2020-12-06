//TODO nowe zadanie- podaj nazwę,opis, kolor, stawka godzinowa?
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:time_management/task_controller.dart';
import 'package:time_management/task_list.dart';

import 'task_model.dart';

class TaskEditWidget extends StatefulWidget {
  final Task editedTask;
  TaskEditWidget({Key key, @required this.editedTask}) : super(key: key);

  @override
  _TaskEditWidgetState createState() => _TaskEditWidgetState();
}

class _TaskEditWidgetState extends State<TaskEditWidget> {
  final _formKey = GlobalKey<FormState>();
  Color _currentColor = Colors.cyan;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rateController = TextEditingController();
  final _currencyController = TextEditingController();
  final _colorController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _rateController.dispose();
    _currencyController.dispose();
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

  @override
  void initState() {
    super.initState();

    var s = widget.editedTask.salary;
    String rate = s.substring(0, s.indexOf(new RegExp(r'[a-zA-Z]')));
    String currency = s.substring(rate.length);
    setState(() {
      _nameController.text = widget.editedTask.name;
      _descriptionController.text = widget.editedTask.description;
      _rateController.text = rate;
      _currencyController.text = currency;
      _currentColor = Color(widget.editedTask.color);
      _colorController.text = _colorToString(_currentColor);
    });
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _nameController,
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
              controller: _descriptionController,
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
                prefixIcon:
                    Icon(Icons.brightness_1_rounded, color: _currentColor),
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
                    controller: _rateController,
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
                    controller: _currencyController,
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
      widget.editedTask.name = _nameController.text;
      widget.editedTask.color = int.parse(_colorController.text, radix: 16);
      widget.editedTask.description = _descriptionController.text;
      widget.editedTask.salary =
          _rateController.text + _currencyController.text;
      updateTask(widget.editedTask);
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TaskListRoute()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Szczegóły zadania"),
          actions: [IconButton(icon: Icon(Icons.save), onPressed: _submitForm)],
        ),
        body: SingleChildScrollView(
          child: _buildForm(),
        ));
  }
}

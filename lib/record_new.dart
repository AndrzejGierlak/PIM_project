//TODO nowe zadanie- podaj nazwę,opis, kolor, stawka godzinowa?
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'task_model.dart';

class RecordNewWidget extends StatefulWidget {
  final List<Task> tasks;

  RecordNewWidget({Key key, @required this.tasks}) : super(key: key);

  @override
  _RecordNewWidgetState createState() => _RecordNewWidgetState();
}

class _RecordNewWidgetState extends State<RecordNewWidget> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _startController = TextEditingController();
  final _durationController = TextEditingController();
  Task _selectedTask;

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay(hour: 00, minute: 00);

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2010),
        lastDate: DateTime(2030));
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat.yMMMd("pl_PL").format(_selectedDate);
      });
    }
  }

  Future<Null> _selectStart(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: _selectedTime);
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        final hour = _selectedTime.hour.toString();
        final minute = _selectedTime.minute.toString();
        final time = hour + " : " + minute;
        _startController.text = time;
      });
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _startController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    DateTime now = DateTime.now();
    var dateString = DateFormat('dd-MM-yyyy').format(now);
    final String configFileName = 'lastConfig.$dateString.json';

    setState(() {
      _dateController.text = DateFormat.yMMMd("pl_PL").format(_selectedDate);
    });
  }

  Widget _buildTaskButton(Task task) {
    return Row(
      children: [
        Icon(
          Icons.brightness_1_rounded,
          color: Color(task.color),
        ),
        SizedBox(width: 20,),
        Text(task.name, style: TextStyle(fontSize: 18.0))
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: DropdownButtonFormField(
              decoration: const InputDecoration(
                labelText: "Zadanie",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: const OutlineInputBorder(),
              ),
              value: _selectedTask,
              selectedItemBuilder: (BuildContext context) {
                return widget.tasks.map<Widget>((t) {
                  return _buildTaskButton(t);
                }).toList();
              },
              items: widget.tasks.map((t) {
                return DropdownMenuItem<Task>(
                    child: _buildTaskButton(t),
                    value: t);
              }).toList(),
              onChanged: (value) => setState(() => _selectedTime = value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _dateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Data",
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Podaj godzinę rozpoczęcia pracy!';
                }
                return null;
              },
              onTap: () {
                _selectDate(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: "Godzina rozpoczęcia",
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Podaj godzinę rozpoczęcia pracy!';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: "Czas pracy",
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Podaj czas pracy!';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Dodaj nowy wpis"),
          actions: [IconButton(icon: Icon(Icons.save), onPressed: () {})],
        ),
        body: SingleChildScrollView(child: _buildForm()));
  }
}

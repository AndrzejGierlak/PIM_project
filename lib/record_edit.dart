//TODO nowe zadanie- podaj nazwę,opis, kolor, stawka godzinowa?
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:time_management/home_page.dart';
import 'package:time_management/record_controller.dart';

import 'record_model.dart';
import 'task_model.dart';

class RecordEditWidget extends StatefulWidget {
  final List<Task> tasks;
  final Record editedRecord;

  RecordEditWidget({Key key, @required this.tasks, @required this.editedRecord}) : super(key: key);

  @override
  _RecordEditWidgetState createState() => _RecordEditWidgetState();
}

class _RecordEditWidgetState extends State<RecordEditWidget> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _startController = TextEditingController();
  final _durationController = TextEditingController();

  Task _selectedTask;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour - 1);
  TimeOfDay _selectedDuration = TimeOfDay(hour: 1, minute: 0);

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

  String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, "0");
    final minute = time.minute.toString().padLeft(2, "0");
    return  hour + ":" + minute;
  }

  Future<Null> _selectStart(BuildContext context) async {
    final TimeOfDay picked =
    await showTimePicker(context: context, initialTime: _selectedTime);
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _startController.text = formatTime(_selectedTime);
      });
    }
  }

  Future<Null> _selectDuration(BuildContext context) async {
    final TimeOfDay picked =
    await showTimePicker(context: context, initialTime: _selectedDuration);
    if (picked != null) {
      setState(() {
        _selectedDuration = picked;
        _durationController.text = formatTime(_selectedDuration);
      });
    }
  }

  TimeOfDay _extractTime(DateTime date) {
    return TimeOfDay(hour: date.hour, minute: date.minute);
  }

  Task _findTask(int taskID) {
    return widget.tasks.firstWhere((e) => e.id == taskID);
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

    setState(() {
      _selectedTask = _findTask(widget.editedRecord.taskId);
      _selectedDate = widget.editedRecord.startDate;
      _selectedTime = _extractTime(_selectedDate);
      _selectedDuration = widget.editedRecord.duration;

      _dateController.text = DateFormat.yMMMd("pl_PL").format(_selectedDate);
      _startController.text = formatTime(_selectedTime);
      _durationController.text = formatTime(_selectedDuration);
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
              onChanged: (value) => setState(() => _selectedTask = value),
              validator: (value) {
                if (value == null) {
                  return 'Wybierz zadanie!';
                }
                return null;
              },
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
                  return 'Podaj datę rozpoczęcia pracy!';
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
              controller: _startController,
              readOnly: true,
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
              onTap: () {
                _selectStart(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _durationController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Czas pracy",
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Podaj czas pracy pracy!';
                }
                return null;
              },
              onTap: () {
                _selectDuration(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      DateTime date = new DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedTime.hour, _selectedTime.minute );
      Record record = widget.editedRecord;
      record.taskId = _selectedTask.id;
      record.startDate = date;
      record.duration = _selectedDuration;
      updateRecord(record);
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Szczegóły wpisu"),
          actions: [IconButton(icon: Icon(Icons.save), onPressed: _submitForm)],
        ),
        body: SingleChildScrollView(child: _buildForm()));
  }
}

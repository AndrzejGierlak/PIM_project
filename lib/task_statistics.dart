/// Bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_management/record_controller.dart';
import 'package:time_management/record_model.dart';

import 'menu_drawer.dart';
import 'task_controller.dart';
import 'task_model.dart';

class TaskStatistics extends StatefulWidget {
  TaskStatistics({Key key}) : super(key: key);

  @override
  _TaskStatisticsState createState() => _TaskStatisticsState();
}

class _TaskStatisticsState extends State<TaskStatistics> {
  List<Task> _tasks;
  List<Record> _records;
  final Map<String, Duration> _periods = {
    "Miesiąc": new Duration(days: 30),
    "Tydzień": new Duration(days: 7)
  };
  final _formKey = GlobalKey<FormState>();
  Task _selectedTask;
  String _selectedPeriodKey;

  @override
  void initState() {
    super.initState();
    _selectedPeriodKey = _periods.keys.toList().first;
    _reload();
  }

  void _reload() {
    initTestData().then((value) => setState(() {
          _selectedTask = _tasks.first;
        }));
  }

  Future<void> initTestData() async {
    _tasks = await getTasks();
    _records = await getRecords();
  }

  Widget _buildPeriodButton(String periodKey) {
    return Text(
      periodKey,
      style: TextStyle(fontSize: 18.0),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTaskButton(Task task) {
    return Row(
      children: [
        Icon(
          Icons.brightness_1_rounded,
          color: Color(task.color),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
            child: Text(
          task.name,
          style: TextStyle(fontSize: 18.0),
          overflow: TextOverflow.ellipsis,
        ))
      ],
    );
  }

  void _showFiltersDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Ustawienia".toUpperCase(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            contentPadding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: "Zadanie",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: const OutlineInputBorder(),
                          ),
                          value: _selectedTask,
                          selectedItemBuilder: (BuildContext context) {
                            return _tasks.map<Widget>((t) {
                              return _buildTaskButton(t);
                            }).toList();
                          },
                          items: _tasks.map((t) {
                            return DropdownMenuItem<Task>(
                                child: _buildTaskButton(t), value: t);
                          }).toList(),
                          onChanged: (value) =>
                              setState(() => _selectedTask = value),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: "Okres",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: const OutlineInputBorder(),
                          ),
                          value: _selectedPeriodKey,
                          selectedItemBuilder: (BuildContext context) {
                            return _periods.keys.toList().map<Widget>((p) {
                              return _buildPeriodButton(p);
                            }).toList();
                          },
                          items: _periods.keys.toList().map((p) {
                            return DropdownMenuItem<String>(
                                child: _buildPeriodButton(p), value: p);
                          }).toList(),
                          onChanged: (value) => setState(() {
                            _selectedPeriodKey = value;
                          }),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text("Zakończ".toUpperCase(),
                                  style: TextStyle(fontSize: 18)),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget showChart() {
    if (_selectedTask != null) {
      return new TaskChart(records: _records, task: _selectedTask, period: _periods[_selectedPeriodKey],);
    } else {
      return Text("Trwa ładowanie danych");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MenuDrawer(),
        appBar: AppBar(
          title: Text("Statystyki zadania"),
          actions: [
            IconButton(
                icon: Icon(Icons.filter_alt), onPressed: _showFiltersDialog)
          ],
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              height: 500,
              child: showChart())
        ]));
  }
}

class TaskChart extends StatelessWidget {
  final List<Record> records;
  final Task task;
  final Duration period;

  TaskChart({this.records, this.task, this.period});

  List<charts.Series<DataPair, String>> _buildSeries() {
    var filteredData = this.records.where((r) => r.taskId == task.id).toList();

    Map dataMap = new Map<DateTime, double>();
    var now = DateTime.now();
    for (int i = period.inDays - 1; i >= 0; i--) {
      var temp = now.subtract(Duration(days: i));
      dataMap[DateTime(temp.year, temp.month, temp.day)] = 0.0;
    }
    filteredData.forEach((e) {
      var key = DateTime(e.startDate.year, e.startDate.month, e.startDate.day);
      if (dataMap[key] != null) {
        dataMap[key] += e.duration.hour;
        if (e.duration.minute != 0) {
          dataMap[key] += 60 / e.duration.minute;
        }
      }
    });

    List data = new List<DataPair>();
    dataMap.forEach((key, value) {
      data.add(DataPair(DateFormat.Md("pl_PL").format(key), value));
    });

    return [
      new charts.Series<DataPair, String>(
        id: task.name,
        domainFn: (DataPair dp, _) => dp.date,
        measureFn: (DataPair dp, _) => dp.accumulatedTime,
        data: data,
        seriesColor: charts.ColorUtil.fromDartColor(new Color(task.color)),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
      child: new charts.BarChart(
        _buildSeries(),
        animate: true,
        behaviors: [new charts.SeriesLegend(), ],
        domainAxis: charts.OrdinalAxisSpec(
          renderSpec: charts.SmallTickRendererSpec(labelRotation: 60),
        ),
      ),
    );
  }
}

/// Sample ordinal data type.
class DataPair {
  final String date;
  double accumulatedTime = 0.0;

  DataPair(this.date, this.accumulatedTime);
}

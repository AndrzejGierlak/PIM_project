/// Bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
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
                          onChanged: (value) =>
                              setState(() {
                                _selectedPeriodKey = value;
                              }),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text("Zakończ".toUpperCase(), style: TextStyle(fontSize: 18)),
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
        body: Container(height: 500, child: TaskChart.withSampleData()));
  }
}

class TaskChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  TaskChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory TaskChart.withSampleData() {
    return new TaskChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: new charts.BarChart(
        seriesList,
        animate: animate,
      ),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

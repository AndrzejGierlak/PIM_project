//TODO lista nazw tasków- ską będzie można przejść do edycji każdego taska

import 'package:flutter/material.dart';
import 'package:pim_core_app/help.dart';
import 'package:pim_core_app/record_list.dart';
import 'package:pim_core_app/record_edit.dart';
import 'package:pim_core_app/task_edit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TaskListRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task list"),
      ),
      //body: TaskListRouteS(),
      body: DemoScreen(),
    );
  }
}


class DemoScreen extends StatefulWidget {
  @override
  _DemoScreenState createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  //List<String> taskNameList = List<String>(); przestarzałe
  List<Task> taskList= List<Task>();
  @override
  void initState() {
    super.initState();

    saveTaskInfo();
    //format dodawania danych TASK
    //(new_id,new_name,new_color,new_salary,new_description,new_records,new_recordsCounter, new_key)
    // niech pracaKey= "records"+id taska i tyle

    //przykladowa inicjacja danych, odkomentuj ponizsze i zapisz aby wgrac do "bazy" przykladowe dane, potem zakomentuj
    initTestData('0','praca inżynierska','biały','30','opis pracy jest nudny','pracaKey','1','task0');//TODO
    initTestData('1','PIM','czarny','0','opis PIM jest nudny','pracaKey','1','task1');//TODO
    initTestData('2','AKC projekt','czerwony','10','opis AKC jest ciekawy','pracaKey','1','task2');//TODO

    //taskNameList.add(await getTaskInfoKey('key1').getName());
    //initialTestLoad();//TODO
    initialLoadFull();
  }


  //status: Zrobione, używane
  //poprawny load danych- wczytuj dopoki odczytujesz cos z pamieci
  //dane są odczytywane bezpośrednio w Liście
  void initialLoadFull () async {
    var i=0;
    Task temp=await getTaskInfoKey('task'+i.toString());
    while(temp!=null){
      taskList.add(temp);
      i+=1;
      temp=await getTaskInfoKey('task'+i.toString());
    }
    setState(() {});//zeby odswiezyc- nie zapominac o tym bo inaczej widok się nie rerenderuje
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(itemBuilder: (context, index) {
        physics: ClampingScrollPhysics();
        return Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
                child: Container(
                  height: 30,
                  color: Colors.blue,
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child:Text(
                            //taskNameList[index], //przestarzale
                            taskList[index].getName(),
                            style: TextStyle(color: Colors.white ,fontSize: 18,),
                          ),

                      ),
                  ),

                ),
                onTap:()=>{
                print("Pushowany taskID to : "+taskList[index].getId()),
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskRecordListRoute(parentTaskId: taskList[index].getId()),
                  ),
                )
              },
                onLongPress: ()=>{
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskEditRoute(passedTask: taskList[index]),
                    ),
                  )
                },
            )
        );
      },
          itemCount: taskList.length,
      ),
    );
  }

}


//TODO robione zapis i odczyt jsona--------------------------------------------------------------
Future<void> saveTaskInfo() async {
  final Task myTask = Task.fromJson({
    'info': {
      'id': '1',
      'name': 'pointless task NAME',
      'color': 'Red?',
      'salary':'25/h',
      'description':'very very long desription of pointless task',
      'records':'importantValue',//do miejsca w pamieci gdzie są rekordy tego taska
      'recordsCounter':'4'//liczba rekordów pod tym taskiem, mozliwe ze niepotrzebne
    },
    'token': 'xxx'
  });

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool result = await prefs.setString('howToMapTask', jsonEncode(myTask));
  print(result);
}

Future<void> initTestData(new_id,new_name,new_color,new_salary,new_description,new_records,new_recordsCounter, new_key) async {
  final Task myTask = Task.fromJson({
    'info': {
      'id': ''+new_id,
      'name': ''+new_name,
      'color': ''+new_color,
      'salary':''+new_salary,
      'description':''+new_description,
      'records':''+new_records,//do miejsca w pamieci gdzie są rekordy tego taska
      'recordsCounter':''+new_recordsCounter//liczba rekordów pod tym taskiem, mozliwe ze niepotrzebne
    },
    'token': 'xxx'
  });
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool result = await prefs.setString(new_key, jsonEncode(myTask));
}

Future<Task> getTaskInfo() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  Map<String, dynamic> userMap;
  final String userStr = prefs.getString('howToMapTask');
  if (userStr != null) {
    userMap = jsonDecode(userStr) as Map<String, dynamic>;
  }

  if (userMap != null) {
    final Task myTask = Task.fromJson(userMap);
    print(myTask);
    return myTask;
  }
  return null;
}

Future<Task> getTaskInfoKey(key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  Map<String, dynamic> taskMap;
  final String takStr = prefs.getString(key);
  if (takStr != null) {
    taskMap = jsonDecode(takStr) as Map<String, dynamic>;
  }

  if (taskMap != null) {
    final Task myTask = Task.fromJson(taskMap);
    print(myTask);
    return myTask;
  }
  return null;
}

//schemat JSON TASK-----------------------------------------------------------------
class TaskInfo {
  String id;
  String name;
  String color;
  String salary;
  String description;
  String records;
  String recordsCounter;


  TaskInfo({this.id, this.name, this.color,this.salary,this.description,this.records,this.recordsCounter});
  TaskInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    color= json['color'];
    salary=json['salary'];
    description=json['description'];
    records=json['records'];
    recordsCounter=json['recordsCounter'];

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['color']= this.color;
    data['salary']=this.salary;
    data['description']=this.description;
    data['records']=this.records;
    data['recordsCounter']=this.recordsCounter;
    return data;
  }
  @override
  String toString() {
    return '"info" : { "id": $id, '
        '"name": $name, '
        '"color": $color,'
        '"salary": $salary,'
        '"description": $description,'
        '"records": $records,'
        '"recordsCounter": $recordsCounter'
        '}';
  }
}
//--------------------------------------------------------------------------

class Task {
  TaskInfo info;
  String token;

  Task({this.info, this.token});

  Task.fromJson(Map<String, dynamic> json) {
    info = json['info'] != null ? TaskInfo.fromJson(json['info']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.info != null) {
      data['info'] = this.info.toJson();
      //pod info znajduje się schemat jsona taska
    }
    data['token'] = this.token;
    return data;
  }

  String getName(){
    return this.info.name;
  }
  String getId(){
    return this.info.id;
  }
  @override
  String toString() {
    return '"Task-> " : {${info.toString()}, "token": $token}';
  }
}

//---------------------------------------------------------------------------------------

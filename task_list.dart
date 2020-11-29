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
    //(new_id,new_name,new_color,new_salary,new_description, new_key)

    //przykladowa inicjacja danych, odkomentuj ponizsze i zapisz aby wgrac do "bazy" przykladowe dane, potem zakomentuj
    //initTestTaskData('0','praca inżynierska','biały','30','opis pracy jest nudny','task0');
   // initTestTaskData('1','PIM','czarny','0','opis PIM jest nudny','task1');
    //initTestTaskData('2','AKC projekt','czerwony','10','opis AKC jest ciekawy','task2');

    loadTasksTo(taskList, this);
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
                print("Rekordy dla taskID : "+taskList[index].getId()),
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

//TODO Funkcje API VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
//status: Zrobione, używane
// taskList -> lista do ktorej wczytujesz dane z zapisanych plików ("bazy")
// thisParam -> przekazujesz po prostu "this"- dzięki temu odświeżasz stan, wyświetlane są poprawne dane
//wczytywane są kolejne taski licząc od 0 do aż znajdzie null
void loadTasksTo (taskListParam ,thisParam) async {
  var i=0;
  Task temp=await getTaskInfoKey('task'+i.toString());
  while(temp!=null){
    print("dodaje");
    taskListParam.add(temp);
    i+=1;
    temp=await getTaskInfoKey('task'+i.toString());
  }
  thisParam.setState(() {});//zeby odswiezyc- nie zapominac o tym bo inaczej widok się nie rerenderuje
}

void loadAllTo (taskListParam ,thisParam,recordListParam) async {
  var i=0;
  Task temp=await getTaskInfoKey('task'+i.toString());
  while(temp!=null){
    print("dodaje");
    taskListParam.add(temp);
    i+=1;
    temp=await getTaskInfoKey('task'+i.toString());
  }
  for(var j=0;j<i;j+=1){//j to index tablicy obecnego taska, i to otrzymany rozmiar tablicy taskow
    List<Record> tempListR=List<Record>();
    var k=0;//k to index tablicy danego recordu
    Record tempR=await getRecordInfoKey(taskListParam[j].getId()+'task'+k.toString());//TODO zmien zahardcodowane 2 na parametr przekazany przy konstruktorze tego screena
    while(tempR!=null){
      //recordListParam.add(tempR);
      tempListR.add(tempR);
      k+=1;
      tempR=await getRecordInfoKey(taskListParam[j].getId()+'task'+k.toString());
    }
    recordListParam.add(tempListR);
    //loadRecordsTo(tempListRecord, this, taskList[j].getId());//tutaj ryzykowny setState- rerender!!
    //print(tempListRecord.length);
    //allRecordList.add(tempListRecord);
  }
  print("Record lista spod taska id:0 -- "+recordListParam[0].toString());
  print("Record lista spod taska id:1 -- "+recordListParam[1].toString());
  print("Record lista spod taska id:2 -- "+recordListParam[2].toString());
  thisParam.setState(() {});//zeby odswiezyc- nie zapominac o tym bo inaczej widok się nie rerenderuje
}
//TODO API ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


//TODO robione zapis i odczyt jsona--------------------------------------------------------------
Future<void> saveTaskInfo() async {
  final Task myTask = Task.fromJson({
    'info': {
      'id': '1',
      'name': 'pointless task NAME',
      'color': 'Red?',
      'salary':'25/h',
      'description':'very very long desription of pointless task',
      //'records':'importantValue',//do miejsca w pamieci gdzie są rekordy tego taska
      //'recordsCounter':'4'//liczba rekordów pod tym taskiem, mozliwe ze niepotrzebne
    },
    'token': 'xxx'
  });

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool result = await prefs.setString('howToMapTask', jsonEncode(myTask));
  print(result);
}

//Future<void> initTestTaskData(new_id,new_name,new_color,new_salary,new_description,new_records,new_recordsCounter, new_key) async {
Future<void> initTestTaskData(new_id,new_name,new_color,new_salary,new_description, new_key) async {
  final Task myTask = Task.fromJson({
    'info': {
      'id': ''+new_id,
      'name': ''+new_name,
      'color': ''+new_color,
      'salary':''+new_salary,
      'description':''+new_description,
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


  TaskInfo({this.id, this.name, this.color,this.salary,this.description});//,this.records,this.recordsCounter});
  TaskInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    color= json['color'];
    salary=json['salary'];
    description=json['description'];

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['color']= this.color;
    data['salary']=this.salary;
    data['description']=this.description;
    return data;
  }
  @override
  String toString() {
    return '"info" : { "id": $id, '
        '"name": $name, '
        '"color": $color,'
        '"salary": $salary,'
        '"description": $description,'
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

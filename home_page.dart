//TODO lista nazw tasków- ską będzie można przejść do edycji każdego taska

import 'package:flutter/material.dart';
import 'package:pim_core_app/help.dart';
import 'package:pim_core_app/record_list.dart';
import 'package:pim_core_app/record_edit.dart';
import 'package:pim_core_app/task_edit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:pim_core_app/task_list.dart';

class HomePageRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      //body: TaskListRouteS(),
      body: HomeScreenS(),
    );
  }
}


class HomeScreenS extends StatefulWidget {
  @override
  _HomeScreenSState createState() => _HomeScreenSState();
}




class _HomeScreenSState extends State<HomeScreenS> {
  //List<String> taskNameList = List<String>(); przestarzałe
  List<Task> taskList= List<Task>();
  List<List<Record>> allRecordList =List<List<Record>>();//= new List.generate(n, (i) => []);

  @override
  void initState() {
    super.initState();

    saveTaskInfo();
    //format dodawania danych TASK
    //(new_id,new_name,new_color,new_salary,new_description, new_key)
    //przykladowa inicjacja danych, odkomentuj ponizsze i zapisz aby wgrac do "bazy" przykladowe dane, potem zakomentuj
    //initTestData('0','praca inżynierska','biały','30','opis pracy jest nudny','task0');
    //initTestData('1','PIM','czarny','0','opis PIM jest nudny','task1');
    //initTestData('2','AKC projekt','czerwony','10','opis AKC jest ciekawy','task2');

    //loadTasksTo(taskList,this);
    loadAllTo(taskList,this,allRecordList);
    //print(allRecordList[2]);

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
                height: 60,
                color: Colors.blue,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                        children: <Widget>[
                          //Text(passedRecord.info.duration),
                          Text(taskList[index].getName(), style: TextStyle(color: Colors.white ,fontSize: 18,),),

                          //TODO przykladowe pobieranie danych jednak niezabezpieczone! Ograniczenie przy drugim indeksie istotne!zahardcodowane!
                          Text(allRecordList[index].length.toString(), style: TextStyle(color: Colors.white ,fontSize: 18,),),
                          Text(allRecordList[index][0].info.startDate, style: TextStyle(color: Colors.white ,fontSize: 18,),),
                          //dla danego elementu zlistuj wszystkie jego dzieciaki


                          //Text('Duration: '+passedRecord.info.duration),
                          //Text('Start date: '+passedRecord.info.startDate),
                          //Text('TaskId: '+passedRecord.info.taskId),
                          //Text('This record id: '+passedRecord.info.id),
                        ]
                    ),
                  ),
                ),
              ),
              onTap:()=>{},
              // onTap:()=>{
              //   print("Pushowany taskID to : "+taskList[index].getId()),
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => TaskRecordListRoute(parentTaskId: taskList[index].getId()),
              //     ),
              //   )
              // },
              // onLongPress: ()=>{
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => TaskEditRoute(passedTask: taskList[index]),
              //     ),
              //   )
              // },
            )
        );
      },
        itemCount: taskList.length,
      ),
    );
  }
}


//TaskRecordListRoute(parentTaskId: taskList[index].getId()),

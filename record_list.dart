


//TODO stworzyć listę poszczególnych rekordów, wzorując się na task_list
//TODO trzeba ustlic wlasny format recordu
//TODO do listy trzeba dostawac się po identyfikatorze taska
//TODO z tego ekranu mamy miec mozliwosc onTap() => na dany(kliknięty) task_record i tam otworzyć dane nawet na samych textField

//TODO to ponizej jest w większości do wywalenia


//TODO lista nazw tasków- ską będzie można przejść do edycji każdego taska

import 'package:flutter/material.dart';
import 'package:pim_core_app/help.dart';
import 'package:pim_core_app/record_edit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TaskRecordListRoute extends StatelessWidget {
  //ponizsze wymaga task id przy tworzeniu
  final String parentTaskId;
  TaskRecordListRoute({Key key, @required this.parentTaskId}): super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Record list (of specified task)"),
      ),
      body: RecordListWidget(parentTaskId: this.parentTaskId),
    );
  }
}


class RecordListWidget extends StatefulWidget {

  final String parentTaskId;
  RecordListWidget({Key key, @required this.parentTaskId}): super(key:key);

  @override
  _RecordListWidgetState createState() => _RecordListWidgetState(parentTaskId: this.parentTaskId);
}

class _RecordListWidgetState extends State<RecordListWidget> {
  //List<String> taskNameList = List<String>(); przestarzałe

  final String parentTaskId;
  _RecordListWidgetState({Key key, @required this.parentTaskId}): super();

  List<Record> recordList= List<Record>();
  @override
  void initState() {
    super.initState();

    saveRecordInfo();
    //format dodawania danych RECORD
    //TODO (new_id,new_taskId,new_startDate,new_duration, new_key)
    // format klucza do zapisania rekordu: "task.id"+"task"+"klucz recordu(numer do tablicy)"

    //przykladowa inicjacja danych
  //  initTestData('1','2','dzisiaj','30 minut','2'+'task'+'0');//TODO
  //  initTestData('2','2','dwa tygodnie temu','14 dni','2'+'task'+'1');//TODO
  //  initTestData('3','1','wczoraj','10 lat','0'+'task'+'0');//TODO
  //  initTestData('4','2','pojutrze','30 minut','0'+'task'+'1');//TODO
  //  initTestData('5','0','moze kiedys','14 dni','1'+'task'+'0');//TODO przy pim ma zostac tylko moze keidys->wtedy usuwanie dziala
  //  initTestData('6','1','pewnie nigdy','10 lat','1'+'task'+'1');//TODO
    //TODO!!!!!! uwaga jest problem z indexami- obecnie mozna usuwac tylko najwiekszy index żeby dzialalo prawidlowo
    //TODO PRZYCZYNA: zaimplementowane jest wczytywanie wczytuj dopoki od 0 znajdujesz cos na danym kluczu
    // TODO pomysl na robienie-> po usuwaniu trzeba zapisac wszystkie elementy tablicy od poczatku(0) do konca
    //taskNameList.add(await getTaskInfoKey('key1').getName());
    //initialTestLoad();//TODO
    initialLoadFull();
  }


  //status: Zrobione, używane
  //poprawny load danych- wczytuj dopoki odczytujesz cos z pamieci
  //dane są odczytywane bezpośrednio w Liście
  void initialLoadFull () async {
    var i=0;
    print("ParentTaskId is: "+parentTaskId);
    Record temp=await getRecordInfoKey(parentTaskId+'task'+i.toString());//TODO zmien zahardcodowane 2 na parametr przekazany przy konstruktorze tego screena
    while(temp!=null){
      print("wszedlem");
      recordList.add(temp);
      i+=1;
      temp=await getRecordInfoKey(parentTaskId+'task'+i.toString());
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
                        child: Text(
                          //taskNameList[index], //przestarzale
                          recordList[index].getStartDate(),
                          style: TextStyle(color: Colors.white ,fontSize: 18,),
                        ),
                      )
                  ),
                ),
                //TODO tu zaimplementuj wyswietlanie danego recordu
                onTap:()=>{
                  //print("Pushowany taskID to : "+taskList[index].getId()),
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecordEditRoute(passedRecord: recordList[index]),
                    ),
                  ),
                },
              onLongPress: ()=>{
                  //TODO przykład usuwania danych
                 removeData(recordList[index].info.taskId,index.toString()),
              //TODO https://stackoverflow.com/questions/52778601/flutter-remove-list-item
                //TODO opis ponizszego- usun ten element z tablicy, ktorego id jest takie jak id kliknietej rzeczy
                  recordList.removeWhere((item) => item.info.id == recordList[index].info.id),
                  setState(() {})//zeby odswiezyc
              },
            )
        );
      },
        itemCount: recordList.length,
      ),
    );
  }

}


//TODO (z)robione zapis i odczyt jsona--------------------------------------------------------------
//to jest do zapisania formatu recordu pod kluczem howToMapRecord -w jaki sposób powinniśmy odczytywać dane
Future<void> saveRecordInfo() async {
  final Record myRecord = Record.fromJson({
    'info': {
      'id': '1',//record ID
      'taskId':'1',
      'startDate':'12:50:31',
      'duration':'2'
    },
    'token': 'xxx'
  });
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool result = await prefs.setString('howToMapRecord', jsonEncode(myRecord));
  print(result);
}

//TODO to jest prototyp funkcji zapisującej- w odpowiednie miejsca przekazac id lub stworzyć funkcję na podstawie tej
//TODO Prototyp funkcji READ
Future<void> initTestData(new_id,new_taskId,new_startDate,new_duration, new_key) async {
  final Record myTask = Record.fromJson({
    'info': {
      'id': ''+new_id,
      'taskId': ''+new_taskId,
      'startDate': ''+new_startDate,
      'duration':''+new_duration
    },
    'token': 'xxx'
  });
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool result = await prefs.setString(new_key, jsonEncode(myTask));
}

//TODO https://stackoverflow.com/questions/54327164/flutter-remove-all-saved-shared-preferences
Future<void> removeData(task_id,key) async{
  SharedPreferences mySPrefs = await SharedPreferences.getInstance();
    mySPrefs.remove(task_id+'task'+key);
}

Future<Record> getTaskInfo() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  Map<String, dynamic> recordMap;
  final String userStr = prefs.getString('howToMapRecord');
  if (userStr != null) {
    recordMap = jsonDecode(userStr) as Map<String, dynamic>;
  }

  if (recordMap != null) {
    final Record myRecord = Record.fromJson(recordMap);
    print(myRecord);
    return myRecord;
  }
  return null;
}

Future<Record> getRecordInfoKey(key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, dynamic> recordMap;
  final String recordStr = prefs.getString(key);
  if (recordStr != null) {
    recordMap = jsonDecode(recordStr) as Map<String, dynamic>;
  }
  if (recordMap != null) {
    final Record myRecord = Record.fromJson(recordMap);
    print(myRecord);
    return myRecord;
  }
  return null;
}



//schemat JSON RECORD-----------------------------------------------------------------
//(new_id,new_taskId,new_startDate,new_duration, new_key)
class RecordInfo {
  String id;
  String taskId;
  String startDate;
  String duration;


  RecordInfo({this.id, this.taskId, this.startDate,this.duration});
  RecordInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskId= json['taskId'];
    startDate= json['startDate'];
    duration= json['duration'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['taskId']=this.taskId;
    data['startDate']=this.startDate;
    data['duration']=this.duration;
    return data;
  }
  @override
  String toString() {
    return '"info" : { "id": $id, '
        '"taskId": $taskId, '
        '"startDate": $startDate,'
        '"duration": $duration,'
        '}';
  }
}
//--------------------------------------------------------------------------

class Record {
  RecordInfo info;
  String token;

  Record({this.info, this.token});

  Record.fromJson(Map<String, dynamic> json) {
    info = json['info'] != null ? RecordInfo.fromJson(json['info']) : null;
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

  // String getName(){
  //   return this.info.name;
  // }
      String getStartDate(){
    return this.info.startDate;
      }
  @override
  String toString() {
    return '"Task-> " : {${info.toString()}, "token": $token}';
  }
}

//---------------------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:time_management/home_page.dart';
import 'task_list.dart';
import 'task_statistics.dart';

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
              icon: Icons.timer,
              text: 'Rejestr czasu pracy',
              onTap: () =>
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()))),
          _createDrawerItem(
              icon: Icons.work,
              text: 'Zadanie',
              onTap: () =>
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TaskListRoute()))),
          _createDrawerItem(
              icon: Icons.bar_chart,
              text: 'Statystyki',
              onTap: () =>
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TaskStatisticsRoute()))),
          Divider(),
          _createDrawerItem(icon: Icons.help, text: 'Autorzy'),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('res/images/drawer_header_background.png'))),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("Pracomierz",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
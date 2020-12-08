//TODO some information about aplication? simple instructions?
import 'package:flutter/material.dart';

class HelpRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const infoString="Working Hours 2.0 \n"
        "Autorzy: Wojtek Śliwa, Andrzej Gierlak\n"
        "Więcej info...\n"
        "...\n";
    return Scaffold(
      appBar: AppBar(
        title: Text("Informacje o aplikacji"),
      ),
      body: Container(
        color: Colors.cyan[100],
        padding: EdgeInsets.all(5.0),
        child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text('Aplikacja Pracomierz',
                      style: TextStyle(fontSize: 40))),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child:Text("Data ostatniej kompilacji: 8.12.20",
                        style: TextStyle(fontSize: 18))),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child:Text(
                        "Twórcy:\n"
                        "Wojtek Śliwa 241296\n"
                        "Andrzej Gierlak 236411\n",
                        style: TextStyle(fontSize: 24))),
              ),
            ]
        )
      ),
    );
  }
}
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
        title: Text("Pomoc/Informacja"),
      ),
      body: const Center(
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              infoString,
              style: TextStyle(fontSize: 24),
            ),
          )

      ),
    );
  }
}
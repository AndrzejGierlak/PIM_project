import 'dart:async';

import 'package:flutter/material.dart';

import 'record_new.dart';

class StopWatch extends StatefulWidget {
  @override
  _StopWatchState createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  bool flag = true;
  Stream<int> timerStream;
  StreamSubscription<int> timerSubscription;
  StreamController<int> streamController;
  String hoursStr = '00';
  String minutesStr = '00';
  String secondsStr = '00';

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    timerStream = stopWatchStream();
    timerSubscription = timerStream.listen((int newTick) {
      setState(() {
        hoursStr =
            ((newTick / (60 * 60)) % 60).floor().toString().padLeft(2, '0');
        minutesStr = ((newTick / 60) % 60).floor().toString().padLeft(2, '0');
        secondsStr = (newTick % 60).floor().toString().padLeft(2, '0');
      });
    });
  }

  Stream<int> stopWatchStream() {
    Timer timer;
    Duration timerInterval = Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
        counter = 0;
        streamController.close();
      }
    }

    void tick(_) {
      counter++;
      streamController.add(counter);
      if (!flag) {
        stopTimer();
      }
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stoper")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$hoursStr:$minutesStr:$secondsStr",
              style: TextStyle(
                fontSize: 90.0,
              ),
            ),
            SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                timerSubscription.cancel();
                timerStream = null;
                var minutes = int.parse(minutesStr);
                var hours = int.parse(hoursStr);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecordNewWidget(
                          duration:
                              new TimeOfDay(hour: hours, minute: minutes)),
                    ));
              },
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'ZAPISZ',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:wearable_intelligence/pages/postExercise.dart';
import 'package:wearable_intelligence/utils/globals.dart';
import 'package:wearable_intelligence/utils/styles.dart';

import '../wearableIntelligence.dart';

class Tracker extends StatefulWidget {
  Tracker(this.title, this._duration, this._time) : super();

  final String title;
  final int _duration; // In seconds
  final int _time; // In seconds
  var paused = false;
  var ended = false;

  @override
  _TrackerState createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppTheme.theme.backgroundColor,
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0.0,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colours.grey,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colours.grey),
          onPressed: () {
            var time = timerController.getTime().split(":");
            elapsedTime = totalTime - (int.parse(time[0]) * 3600 + int.parse(time[1]) * 60 + int.parse(time[2]));
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => WearableIntelligence('Wearable Intelligence')));
          },
        ),
        elevation: 0,
        backgroundColor: AppTheme.theme.backgroundColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Walking 1k",
              style: AppTheme.theme.textTheme.headline1,
            ),
            Hero(
              tag: "timer",
              child: CircularCountDownTimer(
                duration: widget._duration,
                initialDuration: widget._time,
                controller: timerController,
                width: width * 0.8,
                height: width * 0.8,
                ringColor: Colours.grey,
                fillColor: Colours.lightBlue,
                backgroundColor: Colours.white,
                strokeWidth: 15.0,
                strokeCap: StrokeCap.round,
                textStyle: TextStyle(fontSize: 33.0, color: Colours.grey),
                textFormat: CountdownTextFormat.HH_MM_SS,
                isReverse: true,
                isReverseAnimation: true,
                isTimerTextShown: true,
                autoStart: true,
                onStart: () {
                  print('Countdown Started');
                },
                onComplete: () async {
                  Vibrate.vibrate();
                  exerciseMode = false;
                  setState(() {
                    widget.ended = true;
                  });
                },
              ),
            ),
            widget.ended
                ? MaterialButton(
                    minWidth: width * 0.6,
                    height: 50,
                    elevation: 10,
                    shape: StadiumBorder(),
                    color: Colours.highlight,
                    child: Text(
                      "Show Stats",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colours.white),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PostExercise("Post workout stats")),
                      );
                    },
                  )
                : MaterialButton(
                    minWidth: width * 0.6,
                    height: 50,
                    elevation: 10,
                    shape: StadiumBorder(),
                    color: Colours.lightBlue,
                    child: Text(
                      widget.paused ? "Play" : "Pause",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colours.white),
                    ),
                    onPressed: () {
                      setState(() {
                        widget.paused ? timerController.resume() : timerController.pause();
                        widget.paused = !widget.paused;
                      });
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wearable_intelligence/Services/fitbit.dart';
import 'package:wearable_intelligence/utils/styles.dart';

import '../utils/globals.dart';
import 'postExercise.dart';

class Tracker extends StatefulWidget {
  Tracker(this.title, this._time, this._continue) : super();

  final String title;
  final int _time; // In seconds
  final bool _continue;

  @override
  _TrackerState createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  reset(bool continueTrackers) {
    if (!continueTrackers) {
      paused = false;
      ended = false;
      rest = false;
      start = true;
      reps = 3;
      exerciseTime = 10;
      restTime = 5;
      elapsedTime = 0;
    }
  }

  bool shouldPop = true;

  Widget tile(IconData icon, String title) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: 80,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5,
            offset: Offset(3, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colours.highlight, size: 60),
          Container(
            width: 10,
          ),
          Text(
            title,
            style: AppTheme.theme.textTheme.headline2,
          )
        ],
      ),
    );
  }

  Widget timerTile(int duration, bool exerciseTimer) {
    double width = MediaQuery.of(context).size.width;

    if (rest) {
      restTime = duration;
    } else {
      exerciseTime = duration;
    }

    return Container(
      width: width - 35,
      height: width / 1.7,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: width - 40,
              height: (width / 1.7) - 15,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ((exerciseTimer != rest) && !start) ? Colours.highlight : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 5,
                    offset: Offset(3, 3), // changes position of shadow
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SvgPicture.asset(
              exerciseTimer ? 'assets/images/walking.svg' : 'assets/images/rest.svg',
              width: width - 140,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: CircularCountDownTimer(
                duration: duration,
                initialDuration: widget._time,
                controller: exerciseTimer ? exerciseController : restController,
                width: 90,
                height: 90,
                ringColor: Colours.grey,
                fillColor: Colours.lightBlue,
                backgroundColor: Colours.white,
                strokeWidth: 5.0,
                strokeCap: StrokeCap.round,
                textStyle: TextStyle(fontSize: 24.0, color: Colours.grey),
                textFormat: CountdownTextFormat.MM_SS,
                isReverse: true,
                isReverseAnimation: true,
                isTimerTextShown: true,
                autoStart: (widget._continue && (exerciseTimer != rest)) ? true : false,
                onStart: () {},
                onComplete: () async {
                  // TODO make vibrate work on android
                  // bool canVibrate = await Vibrate.canVibrate;
                  // print(canVibrate.toString());
                  // Vibrate.vibrate();

                  elapsedTime = 0;
                  setState(() {
                    // If we just finished an exercise.
                    if (!rest) {
                      reps--;
                    }

                    if (reps != 0) {
                      rest = !rest;
                    } else {
                      ended = true;
                      exerciseMode = false;
                    }

                    if (reps != 0) {
                      rest ? restController.start() : exerciseController.start();
                    }
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getRepText() {
    if (reps > 1) {
      return "$reps reps left";
    } else if (reps == 1) {
      return "$reps rep left";
    } else {
      return "Workout Over";
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
        child: Scaffold(
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
                // TODO uncomment to allow users to go back
                // var time = rest ? restController.getTime().split(":") : exerciseController.getTime().split(":");
                // elapsedTime = (rest ? restTime : exerciseTime) - (int.parse(time[0]) * 60 + int.parse(time[1]));
                // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => WearableIntelligence('Wearable Intelligence')));
              },
            ),
            elevation: 0,
            backgroundColor: AppTheme.theme.backgroundColor,
          ),
          body: Stack(
            children: [
              ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(children: [
                      tile(Icons.favorite, "Target: 165bpm"),
                      Container(height: 10),
                      tile(Icons.directions_walk, getRepText()),
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 20, bottom: 100),
                    child: Column(
                      children: [
                        timerTile(exerciseTime, true), // 60 for minutes
                        Container(height: 10),
                        timerTile(restTime, false),
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: (ended || start)
                      ? MaterialButton(
                          minWidth: width * 0.6,
                          height: 50,
                          elevation: 10,
                          shape: StadiumBorder(),
                          color: Colours.highlight,
                          child: Text(
                            start ? "Start" : "Show Stats",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colours.white),
                          ),
                          onPressed: () async {
                            if (start) {
                              reset(widget._continue);
                            }
                            start ? exerciseController.start() : nextPage(context);
                            setState(() {
                              start = false;
                            });
                          },
                        )
                      : MaterialButton(
                          minWidth: width * 0.6,
                          height: 50,
                          elevation: 10,
                          shape: StadiumBorder(),
                          color: Colours.lightBlue,
                          child: Text(
                            paused ? "Play" : "Pause",
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colours.white),
                          ),
                          onPressed: () {
                            setState(() {
                              paused
                                  ? (rest ? restController.resume() : exerciseController.resume())
                                  : (rest ? restController.pause() : exerciseController.pause());
                              paused = !paused;
                            });
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
        onWillPop: () async {
          var time = rest ? exerciseController.getTime().split(":") : exerciseController.getTime().split(":");
          elapsedTime = (rest ? restTime : exerciseTime) - (int.parse(time[0]) * 60 + int.parse(time[1]));
          return false; // TODO change to true to allow back press.
        });
  }
}


Future nextPage(BuildContext context) async {
  await FitBitService().getHeartRate30();
  Navigator.push(context,MaterialPageRoute(builder: (context) => PostExercise("Post workout stats")));
}
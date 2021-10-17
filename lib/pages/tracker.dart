import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:wearable_intelligence/utils/globals.dart';
import 'package:wearable_intelligence/utils/styles.dart';

import '../Services/fitbit.dart';
import 'postExercise.dart';

class Tracker extends StatefulWidget {
  Tracker() : super();

  @override
  _TrackerState createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  CountDownController restController = CountDownController();
  CountDownController exerciseController = CountDownController();

  bool paused = false;
  bool ended = false;
  bool start = true;
  bool rest = false;

  int reps = 1; //weekPlan[DateTime.now().weekday - 1].getReps;
  int exerciseTime = 1;
  int restTime = 60;

  Widget tile(IconData icon, String title) {
    double width = MediaQuery.of(context).size.width;

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

  Widget timerTile(bool exerciseTimer) {
    double width = MediaQuery.of(context).size.width;

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
                duration: exerciseTimer ? exerciseTime : restTime,
                initialDuration: 0,
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
                autoStart: false,
                onStart: () {},
                onComplete: () async {
                  // TODO make vibrate work on android
                  bool canVibrate = await Vibrate.canVibrate;
                  print(canVibrate.toString());
                  Vibrate.vibrate();

                  setState(() {
                    // If we just finished an exercise.
                    if (!rest) {
                      reps--;
                    }

                    if (reps != 0) {
                      rest = !rest;
                      rest ? restController.start() : exerciseController.start();
                    } else {
                      ended = true;
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
          body: Stack(
            children: [
              ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(children: [
                      tile(Icons.favorite, "Target: ${heartRateMax}bpm"),
                      Container(height: 10),
                      tile(Icons.directions_walk, getRepText()),
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 20, bottom: 100),
                    child: Column(
                      children: [
                        timerTile(true), // 60 for minutes
                        Container(height: 10),
                        timerTile(false),
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
                              start ? exerciseController.start() : nextPage(context);
                              setState(() {
                                start = false;
                              });
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PostExercise("Post workout stats")),
                              );
                            }
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
          return false;
        });
  }
}

Future nextPage(BuildContext context) async {
  await FitBitService().getHeartRateWorkout();
  Navigator.push(context, MaterialPageRoute(builder: (context) => PostExercise("Post workout stats")));
}

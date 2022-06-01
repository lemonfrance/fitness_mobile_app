import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart'; 
import 'package:wearable_intelligence/utils/globals.dart';
import 'package:wearable_intelligence/utils/styles.dart';
import 'package:wearable_intelligence/wearableIntelligence.dart';

import '../Services/fitbit.dart';
import '../wearableIntelligence.dart';
import 'postExercise.dart';

// ignore: must_be_immutable
class Tracker extends StatefulWidget {
  Tracker(this.title, this.image) : super();

  final String title;
  final String image;
  String timerText="";
  String plantMessage="";
  
  @override
  _TrackerState createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  CountDownController restController = CountDownController();
  CountDownController exerciseController = CountDownController();

  bool start = true;
  bool ended = false;

  bool paused = false;
  bool rest = false;

  int reps = weekPlan[DateTime.now().weekday - 1].getReps;
  int exerciseTime = 60;
  int restTime = weekPlan[DateTime.now().weekday - 1].getRest;

  Timer setTimerText = Timer.periodic(Duration(), (Timer timer){});
  Timer setPlantMsg = Timer.periodic(Duration(), (Timer timer){});

  void showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget noButton = TextButton(
        child: Text("No"),
        onPressed:  () {
          Navigator.pop(context, false);
          setState(() {
            paused
                ? rest ? restController.resume() : exerciseController.resume()
                : rest ? restController.pause() : exerciseController.pause();
            paused = !paused;
          });
        }
    );
    Widget yesButton = TextButton(
      child: Text("Yes"),
      onPressed:  () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WearableIntelligence("Wearable Intelligence"),
            // we need to put a line here where it sends data to the DB to state the user did not complete the exercise
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Paused Exercise"),
      content: Text("Do you want to stop exercising?\n"
          "\nTo resume your exercise, please click 'No'"),
      actions: [
        noButton,
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    super.initState();

    List<String> plantCheerMsgs = [
      "Go, go, go! You can do it!",
      "Is that all you've got? Come on!",
      "Look at 'chu go! Usain Bolt who? Lionel Messi who? I only know you!",
      "Let's go beat the daylight out of Diabeetuz Type Twooo!",
      "ZOMG, you're doing great! Keep your spirits up!"
    ];
    widget.timerText=exerciseTime.toDouble().toStringAsFixed(2);
    widget.plantMessage = plantCheerMsgs[0];

    setTimerText = Timer.periodic(Duration(milliseconds:1), (Timer timer){
      setState(() {
        if(!start&&!paused){
          widget.timerText = exerciseController.getTime();
        }
      });
    });
    setPlantMsg = Timer.periodic(Duration(seconds:4), (Timer timer){

      setState(() {
        if( !start && !paused){
          plantCheerMsgs.shuffle();
          widget.plantMessage = plantCheerMsgs[0];
        }
      });
    });

  }
  
  //Produces an exercise timer with plant and message. Contains icon + time left (top) and circular timer with plant icon (button)
  Widget timerTile(bool exerciseTimer) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: width - 10,
      height: width*1.1,
      alignment: Alignment.center,
      child: ListView(
        children: [

          //dynamic timer text
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                  'assets/images/time.svg',
                  color: Colors.pink,
                  width: 30,
                  height: 30),
              VerticalDivider(width:10),
              Text(widget.timerText, textScaleFactor:2)
            ]
          ),

          Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
          Container( width: width*0.8, height: width,
            child: Stack(

            //circular timer with plant inside that functions as a play/pause button
            children: [

              //exercise timer
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: CircularCountDownTimer(
                    duration: exerciseTime,
                    initialDuration: 0,
                    controller: exerciseController,
                    width: width*0.8,
                    height: width*0.8,

                    //ongoing timer: green ring; paused timer: purple fill
                    ringColor: Colors.transparent,
                    fillColor: (paused) ? Colors.purple : Colors.green,
                    backgroundColor: (paused) ? Colors.purple : Colors.transparent,

                    strokeWidth: 20,
                    strokeCap: StrokeCap.square,

                    textStyle: TextStyle(fontSize: 24.0, color: Colours.grey, overflow: TextOverflow.visible),
                    textFormat: CountdownTextFormat.MM_SS,

                    isReverse: true,
                    isReverseAnimation: false,

                    isTimerTextShown: false,
                    autoStart: false,

                    onStart: () {},
                    onComplete: () async {
                      // TODO make vibrate work on android
                      bool canVibrate = await Vibrate.canVibrate;
                      print(canVibrate.toString());
                      Vibrate.vibrate();

                      //TODO make this go to post exercise page once timer ends
                      ended = true;
                      nextPage(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PostExercise("Post workout stats")));

                      setState(() {
                        // If we just finished an exercise.
                        print("DONE EXERCISE!");
                      });
                      
                    },
                  ),
                ),
              ),

              //plant button
              Align(
                  alignment: Alignment.center,

                  child: (start || (!start && !paused))
                      ? IconButton( //when timer not started, OR timer ongoing and NOT paused
                      icon: Image.asset('assets/images/plantdesign.png'),
                      iconSize: width*0.6,
                      onPressed: () async {
                        if (start) { //if timer not yet running
                          exerciseController.start();
                          setState(() {
                            start = false;
                          });
                        } else{ //if timer ongoing
                          showAlertDialog(context);
                          exerciseController.pause();
                          setState(() {
                            paused = true;
                          });
                        }
                      }
                      )
                      : IconButton( //when timer ongoing and paused
                      icon: Image.asset('assets/images/plantdesign.png',filterQuality: FilterQuality.low),
                      iconSize: width*0.5,
                      onPressed: () async {
                        showAlertDialog(context);
                        setState(() {
                          // ignore: unnecessary_statements
                          (exerciseController.resume());
                          paused = !paused;
                        });
                      }
                  )
              )

          ] ))
          ]),
      ])
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    
    // CHECK HERE CONFLICT 
    //if(ended){
    //  setTimerText.cancel();
      // ignore: unnecessary_statements
    //  setPlantMsg.cancel;
    //}
  //TO HERE
    void showAlertDialog(BuildContext context) {
      // set up the buttons
      Widget noButton = TextButton(
        child: Text("No"),
        onPressed:  () {
          Navigator.pop(context, false);
          setState(() {
            paused
                ? rest ? restController.resume() : exerciseController.resume()
                : rest ? restController.pause() : exerciseController.pause();
            paused = !paused;
          });
        }
      );
      Widget yesButton = TextButton(
        child: Text("Yes"),
        onPressed:  () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WearableIntelligence("Wearable Intelligence"),
              // we need to put a line here where it sends data to the DB to state the user did not complete the exercise
            ),
          );
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Paused Exercise"),
        content: Text("Do you want to stop exercising?\n"
            "\nTo resume your exercise, please click 'No'"),
        actions: [
          noButton,
          yesButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }


    return WillPopScope(
      child: Scaffold(
        backgroundColor: AppTheme.theme.backgroundColor,
        body:
        //A list of widgets: exercise name, seconds left, plant image doubling as a start/pause button & plant message
        ListView(
            children: [
              Divider(height: width*0.1,color:Colors.transparent),

              //Exercise name
              Align(
                alignment: Alignment.center,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.title,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colours.black, fontSize: 36),
                  ),
                ),
              ),

              //Exercise timer
              Align(
                
// CHECK HERE CONFLICT 
                  //alignment: Alignment.center,
                  //child: timerTile(true)// 60 for minutes
//TO HERE
                
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
                      paused ? "Start" : "Pause",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colours.white),
                    ),
                    onPressed: () {
                      showAlertDialog(context);
                      setState(() {
                        paused
                            ? rest ? restController.resume() : exerciseController.resume()
                            : rest ? restController.pause() : exerciseController.pause();
                        paused = !paused;
                      });

                    },
                  ),
                ),
              ),

              //plant message
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: width*0.7,
                  child: Text( start ? "If you're ready, tap on me to START with your exercise.":
                  ((!paused) ? widget.plantMessage : "Was that too difficult? It's okay to take a rest!"),
                  textScaleFactor: 2,
                  textAlign: TextAlign.center)
                )
              )
            ]
        )
      ),
      onWillPop: () async {
        return false;
      }
    );
  }
}

Future nextPage(BuildContext context) async {
  await FitBitService().getHeartRateWorkout();
  Navigator.push(context, MaterialPageRoute(builder: (context) => PostExercise("Post workout stats")));
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wearable_intelligence/Services/database.dart';
import 'package:wearable_intelligence/Services/evaluation.dart';
import 'package:wearable_intelligence/Services/fitbit.dart';
import 'package:wearable_intelligence/components/heartrateGraph.dart';
import 'package:wearable_intelligence/models/exercisePlan.dart';
import 'package:wearable_intelligence/pages/warning.dart';
import 'package:wearable_intelligence/utils/globals.dart';
import 'package:wearable_intelligence/utils/styles.dart';
import 'package:wearable_intelligence/wearableIntelligence.dart';

class PostExercise extends StatefulWidget {
  PostExercise(this.title) : super();

  final String title;

  var low = [];
  var high = [];
  var zeros = 0;

  @override
  _PostExerciseState createState() => _PostExerciseState();
}

class _PostExerciseState extends State<PostExercise> {
  double _difficulty = 2.0;
  double _pain = 0.0;
  bool chestPain = false;
  bool coldSweats = false;

  String getString(double difficulty) {
    int value = difficulty.toInt();
    switch (value) {
      case 4:
        return "Very hard";
      case 3:
        return "Hard";
      case 2:
        return "Neutral";
      case 1:
        return "Easy";
      case 0:
        return "Very Easy";
      default:
        return "Error";
    }
  }

  Widget slider(String title, bool difficulty) {
    return Container(
      width: double.infinity,
      height: 150,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            title,
            style: TextStyle(color: Colours.black, fontWeight: FontWeight.bold),
          ),
          Slider(
            value: difficulty ? _difficulty : _pain,
            min: 0,
            max: difficulty ? 4 : 10,
            divisions: difficulty ? 4 : 10,
            label: difficulty ? getString(_difficulty) : _pain.toString(),
            activeColor: Colours.highlight,
            inactiveColor: Colours.white,
            onChanged: (double value) {
              setState(() {
                if (difficulty) {
                  _difficulty = value;
                } else {
                  _pain = value;
                }
              });
            },
          ),
        ],
      ),
    );
  }


  //Added solar orbs rewards here
  Widget feedbackTile() {
    double width = (MediaQuery.of(context).size.width - 50);
    String feedbackString;

    if (widget.low.length > (workoutHeartRatesDB.length / 2)) {
      feedbackString = "Your heart rate was below the desired heart rate zone. Your plan will adjust to increase the intensity\n+1 water drop";
      waterDropsGained+=1;
    } else if (widget.high.length > (workoutHeartRatesDB.length / 3)) {
      feedbackString = "Your heart rate was above the desired heart rate zone. Your plan will adjust to reduce the intensity\n+1 water drop";
      waterDropsGained+=1;
    } else if ((workoutHeartRates.length == 0) || (workoutHeartRates[0].time == '')) {
      feedbackString = "We do not have access to your heart data. Navigate to Fitbit, sync your data and return to Wearable Intelligence";
    } else {
      feedbackString = "You spent most of your workout in the desired heart rate zone, great work!\n+1 water drop\n+1 solar orbs";
      solarOrbsGained+=1;
      waterDropsGained+=1;
    }



    return Container(
      width: width,
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
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              feedbackString,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Container(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 60,
                  width: (width - 80) / 2,
                  decoration: BoxDecoration(
                    color: Colours.highlight,
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Colours.white,
                      ),
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          "Avg ${averageHeartRate}bpm",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colours.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 60,
                  width: (width - 80) / 2,
                  decoration: BoxDecoration(
                    color: Colours.highlight,
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Colours.white,
                      ),
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          "Max ${heartRatePeak.round()}bpm",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colours.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    widget.zeros = 0;

    for (int bpm in workoutHeartRatesDB) {
      if (bpm < (heartRateMin) && bpm != 0) {
        widget.low.add(bpm);
      } else if (bpm > (heartRateMax)) {
        widget.high.add(bpm);
      } else if (bpm == 0) {
        widget.zeros++;
      }
    }

    return WillPopScope(
        child: Scaffold(
          backgroundColor: AppTheme.theme.backgroundColor,
          body: Stack(
            children: [
              Container(
                height: width / 2,
                decoration: BoxDecoration(
                  color: Colours.darkBlue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: height,
                child: ListView(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  children: [
                    Container(height: 40),
                    Text("Workout Complete, Great Work!", style: TextStyle(fontWeight: FontWeight.bold, color: Colours.white, fontSize: 24)),
                    Container(height: 20),
                    feedbackTile(),
                    Container(height: 20),
                    (workoutHeartRates.length == 0) || (workoutHeartRates[0].time == '')
                        ? MaterialButton(
                            onPressed: () async {
                              await FitBitService().getHeartRateWorkout();
                              setState(() {});
                            },
                            minWidth: double.infinity,
                            height: 60,
                            elevation: 10,
                            shape: StadiumBorder(),
                            color: Colours.highlight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.autorenew_rounded,
                                  color: Colours.white,
                                ),
                                Container(width: 10),
                                Text(
                                  "Refresh heart rate data",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colours.white, fontSize: 18),
                                ),
                              ],
                            ),
                          )
                        : HeartrateGraph(true),
                    Container(height: 20),
                    slider("How hard did you find the exercise?", true),
                    Container(height: 20),
                    slider("How much pain did you have?", false),
                    Container(height: 20),
                    Text("Select what is applicable", style: TextStyle(fontWeight: FontWeight.bold, color: Colours.black, fontSize: 18)),
                    Container(height: 10),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          chestPain = !chestPain;
                        });
                      },
                      minWidth: double.infinity,
                      height: 60,
                      elevation: 10,
                      shape: StadiumBorder(),
                      color: chestPain ? Colours.highlight : Colors.white,
                      child: Text(
                        "Did you experience any chest pain?",
                        style: TextStyle(color: chestPain ? Colors.white : Colours.black),
                      ),
                    ),
                    Container(height: 10),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          coldSweats = !coldSweats;
                        });
                      },
                      minWidth: double.infinity,
                      height: 60,
                      elevation: 10,
                      shape: StadiumBorder(),
                      color: coldSweats ? Colours.highlight : Colors.white,
                      child: Text(
                        "Did you experience any cold sweats?",
                        style: TextStyle(color: coldSweats ? Colors.white : Colours.black),
                      ),
                    ),
                    Container(height: 100),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    onPressed: () async {
                      String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
                      await EvaluationService()
                          .setResponses(date, weekPlan[DateTime.now().weekday - 1].getType, chestPain, coldSweats, _difficulty.toInt(), _pain.toInt());
                      await EvaluationService().setHeartRateData(date);
                      await updatePlan(_difficulty.toInt(), _pain.toInt(), context);
                      exercisedToday = true;
                      if (coldSweats || chestPain) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Warning("Your symptoms are concerning, please seek urgent help from a medical professional")),
                        );
                      } else if (notPushed) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WearableIntelligence("Wearable Intelligence")),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Warning(warningText)),
                        );
                      }
                    },
                    child: Text("Finished", style: TextStyle(fontWeight: FontWeight.bold, color: Colours.white, fontSize: 24)),
                    style: ElevatedButton.styleFrom(
                      primary: Colours.highlight,
                      minimumSize: Size(width - 100, 45),
                      shape: StadiumBorder(),
                      elevation: 10,
                    ),
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

  bool notPushed = true;
  String warningText = "";

  Future updatePlan(int difficulty, int pain, BuildContext context) async {
    ExercisePlan plan = weekPlan[DateTime.now().weekday - 1];

    notPushed = true;

    // 0 increase by 3, 1 increase by 2, 2 increase by 1, 3 nothing, 4 decrease by 1  max reps?????
    plan.setReps = plan.getReps + (3 - difficulty);

    if (pain < 5) {
      // Between 0-4 - check heart rate

      if (widget.zeros != workoutHeartRatesDB.length) {
        if (widget.high.length > (workoutHeartRatesDB.length / 3)) {
          // Above 90 for over a 3rd drop them down.
          if (plan.getType == 'Running') {
            plan.setType = "Jogging";
          } else if (plan.getType == 'Jogging') {
            plan.setType = "Walking";
          } else if (plan.getType == 'Walking') {
            plan.setType = "Swimming";
          } else {
            //talk to your doctor
            notPushed = false;
            warningText = "Your heart rate is peaking to a concerning level. Please seek help from a medical professional";
          }
        } else if (widget.low.length > (workoutHeartRatesDB.length / 2)) {
          // Below 77 for over half bump up the intensity
          if (plan.getType == 'Running') {
            if (plan.getRest >= 20) {
              plan.setRest = plan.getRest - 10;
            }
            //recommend sprinting
          } else if (plan.getType == 'Jogging') {
            plan.setType = "Running";
          } else if (plan.getType == 'Walking') {
            plan.setType = "Jogging";
          } else {
            plan.setType = "Walking";
          }
        }
      }
    } else if ((pain < 7 && pain > 4) && (widget.zeros != workoutHeartRatesDB.length)) {
      // Between 5 or 6 - Drop the intensity
      if (plan.getType == 'Running') {
        plan.setType = "Jogging";
      } else if (plan.getType == 'Jogging') {
        plan.setType = "Walking";
      } else if (plan.getType == 'Walking') {
        plan.setType = "Swimming";
      } else {
        //talk to your doctor
        notPushed = false;
        warningText = "Your heart rate is peaking to a concerning level. Please seek help from a medical professional";
      }
    } else if (pain > 7) {
      // Between 7 - 10 - Talk to a doctor
      notPushed = false;
      warningText =
          "You are experiencing a concerning level of pain. Please seek help from a medical professional and confirm it's still safe to use Wearable Intelligence";
    }
    for (int i = 1; i < 6; i++) {
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).updateExercisePlan(i.toString(), plan);
    }
  }
}

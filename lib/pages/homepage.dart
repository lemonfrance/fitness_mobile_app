import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:wearable_intelligence/Services/database.dart';
import 'package:wearable_intelligence/Services/fitbit.dart';
import 'package:wearable_intelligence/loading.dart';
import 'package:wearable_intelligence/models/exercisePlan.dart';
import 'package:wearable_intelligence/utils/globals.dart';
import 'package:wearable_intelligence/utils/onboardingQuestions.dart';

import '../utils/styles.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage() : super();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseAuth mAuth = FirebaseAuth.instance;
  bool loading = false;
  late double height;
  late double width;

  ExercisePlan Exercise = new ExercisePlan("Running", "Go for a run", "150bpm", "30mins");

  List _typeAssets = [
    {"type": "Walking", "icon": 'assets/images/walkingIcon.svg'},
    {"type": "Running", "icon": 'assets/images/runningIcon.svg'},
    {"type": "Swimming", "icon": 'assets/images/swimmingIcon.svg'},
    {"type": "Cycling", "icon": 'assets/images/cyclingIcon.svg'},
    {"type": "Rest", "icon": 'assets/images/rechargeIcon.svg'},
  ];

  Widget logInScreen() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/runner.png'),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            child: Column(
              children: [
                Text('Welcome', style: TextStyle(fontSize: 60, color: Colours.darkBlue, fontWeight: FontWeight.w700)),
                Text('Log in to Fitbit to get started', style: TextStyle(fontSize: 20, color: Colours.darkBlue, fontWeight: FontWeight.w300)),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 60),
              child: ElevatedButton(
                onPressed: () async {
                  setState(() => loading = true);
                  await FitBitService().getCode(context);

                  setState(() => {loading = false});
                },
                child: Text(
                  "Log into Fitbit",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colours.white, fontSize: 24),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colours.highlight,
                  onPrimary: Colours.white,
                  minimumSize: Size(MediaQuery.of(context).size.width, 60),
                  shape: StadiumBorder(),
                  elevation: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// This is used to create the Preferred Forms of Exercise tiles on the home screen.
  Widget typeTile(int index) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          exerciseTypes[index]["selected"] = !exerciseTypes[index]["selected"];
        });
        var exercises = [];
        for(dynamic type in exerciseTypes){
          if(type["selected"]){
            exercises.add(type["type"]);
          }
        }
        await DatabaseService(uid: mAuth.currentUser!.uid).setPreferredExercises(exercises);
      },
      child: Container(
        height: (width - 120) / 3,
        width: (width - 120) / 4,
        decoration: BoxDecoration(
          color: exerciseTypes[index]["selected"] ? Colours.highlight : Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              blurRadius: 4,
              offset: Offset(4, 4), // Shadow position
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset(
              _typeAssets[index]["icon"],
              color: exerciseTypes[index]["selected"] ? Colours.white : Colours.highlight,
            ),
            Text(
              exerciseTypes[index]["type"],
              style: AppTheme.theme.textTheme.headline6!.copyWith(
                color: exerciseTypes[index]["selected"] ? Colours.white : Colours.black,
                fontSize: 12,
              ),
            )
          ],
        ),
      ),
    );
  }

  /// This widget is used to create the schedule tiles on the home page,
  /// This takes in the index, which identifies where in the weekPlan we are
  Widget scheduleTile(int index) {
    // Get the date of the activity
    var date = DateTime.now().add(Duration(days: index));
    String icon = "";
    int x = 0;

    // Dynamically get the icon
    while (icon == "" && x < (_typeAssets.length)) {
      // Check if the icon name matches the type of exercise
      if (_typeAssets[x]["type"] == weekPlan[date.weekday - 1].getType) {
        icon = _typeAssets[x]["icon"];
      } else {
        x++;
      }
    }

    // TODO: wrap in gesture detector and take them to the detailed day they have selected
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            blurRadius: 4,
            offset: Offset(4, 4), // Shadow position
          ),
        ],
      ),
      child: Row(children: [
        Padding(
          padding: EdgeInsets.only(left: (weekPlan[date.weekday - 1].getType == "Walking") ? 25 : 20, right: 20),
          child: SvgPicture.asset(
            icon,
            color: Colours.darkBlue,
            width: (weekPlan[date.weekday - 1].getType == "Walking") ? 25 : 30,
          ),
        ),
        Text(
          DateFormat('EEEE').format(date) + ":  " + weekPlan[date.weekday - 1].getType,
          style: AppTheme.theme.textTheme.headline3,
        )
      ]),
    );
  }

  Widget homeScreen() {
    var date = DateTime.now();
    return loading
        ? Loading()
        : Container(
            width: double.infinity,
            height: height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30, left: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome $name",
                          style: AppTheme.theme.textTheme.headline4!.copyWith(color: Colours.black),
                        ),
                        Divider(
                          height: 10,
                          color: Colors.transparent,
                        ),
                        Text(
                          "Lets get moving!",
                          style: AppTheme.theme.textTheme.headline2!.copyWith(color: Colours.black, fontWeight: FontWeight.bold),
                        ),
                        Divider(
                          height: 10,
                          color: Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 300,
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 120, left: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Welcome $name", style: AppTheme.theme.textTheme.headline5!.copyWith(color: Colours.black)),
                              Divider(height: 10, color: Colors.transparent),
                              Text("Lets get moving!", style: AppTheme.theme.textTheme.headline2!.copyWith(color: Colours.black, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 200,
                            width: width - 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.5),
                                  blurRadius: 4,
                                  offset: Offset(4, 4), // Shadow position
                                ),
                              ],
                            ),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  "Today:  " + weekPlan[date.weekday - 1].getType + " ",
                                  style: AppTheme.theme.textTheme.headline2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: SvgPicture.asset(
                              'assets/images/walking.svg',
                              width: width - 80,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30, left: 30),
                    child: Text(
                      "Preferred Forms of Exercise",
                      style: AppTheme.theme.textTheme.headline2!.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        typeTile(0),
                        typeTile(1),
                        typeTile(2),
                        typeTile(3),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30, left: 30),
                    child: Text(
                      "Schedule",
                      style: AppTheme.theme.textTheme.headline2!.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.topCenter,
                      width: width - 60,
                      child: ListView.separated(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 30),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: weekPlan.length,
                        itemBuilder: (context, index) {
                          return scheduleTile(index);
                        },
                        separatorBuilder: (BuildContext context, int index) => Divider(
                          height: 10,
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppTheme.theme.backgroundColor,
      body: !(fitBitAccount == true) ? logInScreen() : homeScreen(),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:wearable_intelligence/Services/database.dart';
import 'package:wearable_intelligence/Services/fitbit.dart';
import 'package:wearable_intelligence/utils/globals.dart' as global;
import 'package:wearable_intelligence/utils/onboardingQuestions.dart';

import '../loading.dart';
import '../utils/styles.dart';

Future getDailyStats() async {
  await FitBitService().getDailyGoals();
  await FitBitService().getHeartRates();
}

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

  List _typeAssets = [
    {"type": "Walking", "icon": 'assets/images/walkingIcon.svg'},
    {"type": "Running", "icon": 'assets/images/runningIcon.svg'},
    {"type": "Swimming", "icon": 'assets/images/swimmingIcon.svg'},
    {"type": "Cycling", "icon": 'assets/images/cyclingIcon.svg'},
    {"type": "Rest", "icon": 'assets/images/rechargeIcon.svg'},
  ];

  List _weekPlan = [
    {"exercise": "Walking", "distance": "1km"},
    {"exercise": "Running", "distance": "0.5km"},
    {"exercise": "Rest", "distance": ""},
    {"exercise": "Cycling", "distance": "4km"},
    {"exercise": "Swimming", "distance": "1km"},
    {"exercise": "Walking", "distance": "1km"},
    {"exercise": "Rest", "distance": ""},
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

                  await FitBitService().getCode();
                  await FitBitService().getAuthToken(global.accessToken!);

                  global.fitBitAccount = await FitBitService().getFitBitData(global.authToken, mAuth.currentUser!.uid);
                  global.name = await DatabaseService(uid: mAuth.currentUser!.uid).getFirstName();
                  await FitBitService().getDailyGoals();
                  await FitBitService().getHeartRates();

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
      onTap: () {
        setState(() {
          exerciseTypes[index]["selected"] = !exerciseTypes[index]["selected"];
        });
      },
      child: Container(
        height: (width - 120) / 3,
        width: (width - 120) / 4,
        decoration: BoxDecoration(
          color: exerciseTypes[index]["selected"] ? Colours.darkBlue : Colors.white,
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
            SvgPicture.asset(_typeAssets[index]["icon"], color: exerciseTypes[index]["selected"] ? Colours.white : Colours.darkBlue),
            Text(
              exerciseTypes[index]["type"],
              style: TextStyle(color: exerciseTypes[index]["selected"] ? Colours.white : Colours.black),
            )
          ],
        ),
      ),
    );
  }

  /// This widget is used to create the schedule tiles on the home page,
  /// This takes in the index, which identifies where in the _weekPlan we are
  Widget scheduleTile(int index) {
    // Get the date of the activity
    var date = DateTime.now().add(Duration(days: index));
    String icon = "";
    int x = 0;

    // Dynamically get the icon
    while (icon == "" || x == (_typeAssets.length - 1)) {
      // Check if the icon name matches the type of exercise
      if (_typeAssets[x]["type"] == _weekPlan[index]["exercise"]) {
        icon = _typeAssets[x]["icon"];
      }
      x++;
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
          padding: EdgeInsets.only(left: 20, right: 20),
          child: SvgPicture.asset(
            icon,
            color: Colours.darkBlue,
            width: 30,
          ),
        ),
        Text(
          DateFormat('EEEE').format(date) + ": " + _weekPlan[index]["exercise"] + " " + _weekPlan[index]["distance"],
          style: AppTheme.theme.textTheme.headline3,
        )
      ]),
    );
  }

  Widget homeScreen() {
    return loading
        ? Loading()
        : Container(
            width: double.infinity,
            height: height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: (4.5 * height) / 9,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40)),
                          child: Container(
                            height: height / 2.5,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.01, 0.5],
                                colors: [
                                  Color.fromRGBO(252, 105, 140, 1),
                                  Color.fromRGBO(255, 148, 112, 1),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 130, left: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome ${global.name}",
                                style: AppTheme.theme.textTheme.headline5!.copyWith(color: Colours.white),
                              ),
                              Divider(
                                height: 10,
                                color: Colors.transparent,
                              ),
                              Text(
                                "Lets get moving!",
                                style: AppTheme.theme.textTheme.headline2!.copyWith(color: Colours.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: height / 4,
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
                                padding: EdgeInsets.only(left: 20, bottom: 20),
                                child: Text(
                                  "Today: " + _weekPlan[0]["exercise"] + " " + _weekPlan[0]["distance"],
                                  style: AppTheme.theme.textTheme.headline2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 70, left: 20),
                            child: SvgPicture.asset(
                              'assets/images/walking.svg',
                              width: width - 70,
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
                        itemCount: _weekPlan.length,
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
      body: !(global.fitBitAccount == true) ? logInScreen() : homeScreen(),
    );
  }
}

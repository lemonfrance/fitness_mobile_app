import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:wearable_intelligence/Services/fitbit.dart';
import 'package:wearable_intelligence/pages/authenticate/authenticate.dart';
import 'package:wearable_intelligence/pages/homepage.dart';
import 'package:wearable_intelligence/pages/postExercise.dart';
import 'package:wearable_intelligence/pages/tracker.dart';
import 'package:wearable_intelligence/pages/vitals.dart';
import 'package:wearable_intelligence/pages/weekPlan.dart';
import 'package:wearable_intelligence/pages/welcome.dart';
import 'package:wearable_intelligence/utils/globals.dart' as global;
import 'package:wearable_intelligence/utils/globals.dart';
import 'package:wearable_intelligence/utils/styles.dart';

import 'Services/auth.dart';

class WearableIntelligence extends StatefulWidget {
  WearableIntelligence(this.title) : super();

  final String title;

  @override
  _WearableIntelligenceState createState() => _WearableIntelligenceState();
}

class _WearableIntelligenceState extends State<WearableIntelligence> {
  final AuthService _auth = AuthService();
  CountDownController _controller = CountDownController();

  FutureOr refresh(dynamic value) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List _pages = [
      Vitals(),
      MyHomePage(),
      ExercisePlan(),
    ];

    return Scaffold(
      backgroundColor: global.fitBitAccount == true ? Colors.transparent : Colours.white,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 0.0,
        title: Padding(
          padding: EdgeInsets.only(left: 30),
          child: Text(
            widget.title,
            style: TextStyle(
              color: Colours.darkBlue,
            ),
          ),
        ),
        iconTheme: IconThemeData(
          color: Colours.darkBlue,
        ),
        elevation: 0,
        backgroundColor: AppTheme.theme.backgroundColor,
        foregroundColor: Colours.darkBlue,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: PopupMenuButton<int>(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
              onSelected: (value) async {
                if (value == 0) {
                  await _auth.signOut();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Authenticate()));
                } else {
                  await FitBitService().logoutFitBit();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomePage()));
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colours.highlight,
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Text(
                        "Logout App",
                        style: TextStyle(color: Colours.highlight),
                      )
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colours.highlight,
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Text(
                        "Logout Fitbit",
                        style: TextStyle(color: Colours.highlight),
                      )
                    ],
                  ),
                ),
              ],
              child: Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
      bottomNavigationBar: (global.fitBitAccount == true)
          ? Container(
              decoration: BoxDecoration(
                color: Colours.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 200),
                    blurRadius: 4,
                    offset: Offset(0, -4), // Shadow position
                  ),
                ],
              ),
              child: SalomonBottomBar(
                margin: EdgeInsets.fromLTRB(25, 10, 25, 20),
                currentIndex: pageIndex,
                onTap: (i) => setState(() => pageIndex = i),
                items: [
                  SalomonBottomBarItem(icon: Icon(Icons.insights), title: Text("Progress"), selectedColor: Colours.highlight),
                  SalomonBottomBarItem(icon: Icon(Icons.home), title: Text("Home"), selectedColor: Colours.highlight),
                  SalomonBottomBarItem(icon: Icon(Icons.directions_run), title: Text("Exercise"), selectedColor: Colours.highlight),
                ],
              ),
            )
          : Container(
              height: 0,
            ),
      body: Stack(
        children: [
          _pages.elementAt(pageIndex),
          global.exerciseMode
              ? Padding(
                  padding: EdgeInsets.only(top: 10, right: 30),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        global.elapsedTime = totalTime - int.parse(timerController.getTime());
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Tracker('Timer', global.totalTime, global.elapsedTime)),
                        );
                      },
                      child: Hero(
                        tag: "timer",
                        child: CircularCountDownTimer(
                          duration: global.totalTime,
                          initialDuration: global.elapsedTime,
                          controller: timerController,
                          width: 50,
                          height: 50,
                          ringColor: Colours.grey,
                          fillColor: Colours.highlight,
                          backgroundColor: Colours.white,
                          strokeWidth: 5.0,
                          strokeCap: StrokeCap.round,
                          isReverse: true,
                          isReverseAnimation: true,
                          isTimerTextShown: false,
                          autoStart: true,
                          onStart: () {
                            print('Countdown Started');
                          },
                          onComplete: () async {
                            Vibrate.vibrate();
                            global.exerciseMode = false;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PostExercise("Post workout stats")));
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

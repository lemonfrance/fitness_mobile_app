import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:wearable_intelligence/Services/fitbit.dart';
import 'package:wearable_intelligence/pages/authenticate/authenticate.dart';
import 'package:wearable_intelligence/pages/homepage.dart';
import 'package:wearable_intelligence/pages/vitals.dart';
import 'package:wearable_intelligence/pages/weekPlan.dart';
import 'package:wearable_intelligence/pages/welcome.dart';
import 'package:wearable_intelligence/utils/globals.dart' as global;
import 'package:wearable_intelligence/utils/styles.dart';

import 'Services/auth.dart';

class WearableIntelligence extends StatefulWidget {
  WearableIntelligence(this.title) : super();

  final String title;

  @override
  _WearableIntelligenceState createState() => _WearableIntelligenceState();
}

class _WearableIntelligenceState extends State<WearableIntelligence> {
  int _currentIndex = 1;
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    List _pages = [
      Vitals(),
      MyHomePage(),
      ExercisePlan(),
    ];

    return Scaffold(
        backgroundColor: global.fitBitAccount == true ? Colors.transparent : Colours.white,
        extendBodyBehindAppBar: (_currentIndex == 1 && global.fitBitAccount == true) ? true : false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          titleSpacing: 0.0,
          title: Padding(
            padding: EdgeInsets.only(left: 30),
            child: Text(
              widget.title,
              style: TextStyle(
                color: (_currentIndex == 1 && global.fitBitAccount == true) ? Colours.white : Colours.darkBlue,
              ),
            ),
          ),
          iconTheme: IconThemeData(
            color: (_currentIndex == 1 && global.fitBitAccount == true) ? Colours.white : Colours.darkBlue,
          ),
          elevation: 0,
          backgroundColor: _currentIndex == 1 ? Colors.transparent : AppTheme.theme.backgroundColor,
          foregroundColor: _currentIndex == 1 ? Colours.white : Colours.darkBlue,
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
                  currentIndex: _currentIndex,
                  onTap: (i) => setState(() => _currentIndex = i),
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
        body: _pages.elementAt(_currentIndex));
  }
}

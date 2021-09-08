import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:wearable_intelligence/Services/fitbit.dart';
import 'package:wearable_intelligence/pages/authenticate/authenticate.dart';
import 'package:wearable_intelligence/pages/homepage.dart';
import 'package:wearable_intelligence/pages/vitals.dart';
import 'package:wearable_intelligence/pages/weekPlan.dart';
import 'package:wearable_intelligence/styles.dart';
import 'package:wearable_intelligence/utils/globals.dart' as global;

import 'Services/auth.dart';

Future getDailyStats() async {
  await FitBitService().getDailyGoals();
  await FitBitService().getHeartRates();
}

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
        backgroundColor: AppTheme.theme.backgroundColor,
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
                shape: StadiumBorder(),
                onSelected: (item) async {
                  await _auth.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Authenticate()),
                  );
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
                          "Logout",
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

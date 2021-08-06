import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wearable_intelligence/Services/auth.dart';
import 'package:wearable_intelligence/Services/database.dart';
import 'package:wearable_intelligence/Services/fitbit.dart';
import 'package:wearable_intelligence/main.dart';
import 'package:wearable_intelligence/pages/calender.dart';
import 'package:wearable_intelligence/pages/vitals.dart';
import 'package:wearable_intelligence/pages/weekPlan.dart';
import 'package:wearable_intelligence/styles.dart';
import 'package:wearable_intelligence/utils/globals.dart' as global;

import '../loading.dart';

class AppDrawer extends StatefulWidget {
  AppDrawer(this.pageName) : super();
  final String pageName;


  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final AuthService _auth = AuthService();
  bool loading = false;


  @override
  Widget build(BuildContext context) {
    return Drawer(
            child: Padding(
              padding: EdgeInsets.only(top: 80),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/profile.png'),
                        ),
                      ),
                    ),
                  ),
                  loading
                      ? Loading()
                      : Container(
                          alignment: Alignment.center,
                          child: global.fitBitAccount
                              ? Text("Welcome ${global.name}")
                              : ElevatedButton(
                                  onPressed: () async {
                                    setState(() => loading = true);

                                    await FitBitService().getCode();
                                    await FitBitService().getAuthToken(global.accessToken!);

                                    global.fitBitAccount = await FitBitService().getFitBitData(global.authToken, 'IE1RWrKTEraSuUt7favSdCOg0N83'); //global.uid
                                    global.name = await DatabaseService(uid: global.uid!).getFirstName();

                                    setState(() => {loading = false});
                                  },
                                  child: Text("Login to FitBit"),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colours.lightBlue,
                                    onSurface: Colours.white,
                                  ),
                                ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 40,
                    padding: EdgeInsets.only(left: 16),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyHomePage('Wearable Intelligence')),
                        );
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Home",
                          style: TextStyle(
                              fontWeight: (widget.pageName == "Home")
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 16),
                        ),
                      ),
                      // style: buttonStyle,
                    ),
                  ),
                  Container(
                    height: 40,
                    padding: EdgeInsets.only(left: 16),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CalenderPage('Calendar', 70.0)),
                        );
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Calendar",
                          style: TextStyle(
                              fontWeight: (widget.pageName == "Calendar")
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 16),
                        ),
                      ),
                      // style: buttonStyle,
                    ),
                  ),
                  Container(
                    height: 40,
                    padding: EdgeInsets.only(left: 16),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ExercisePlan('Exercise Plan')),
                        );
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Exercise Plan",
                          style: TextStyle(
                              fontWeight: (widget.pageName == "Exercise Plan")
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 16),
                        ),
                      ),
                      // style: buttonStyle,
                    ),
                  ),
                  Container(
                    height: 40,
                    padding: EdgeInsets.only(left: 16),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Vitals('Vitals')),
                        );
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Progress",
                          style: TextStyle(
                              fontWeight: (widget.pageName == "Progress")
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 16),
                        ),
                      ),
                      //style: buttonStyle,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: TextButton.icon(
                        onPressed: () async {
                          await _auth.signOut();
                        },
                        icon: Icon(
                          Icons.logout,
                          color: Colours.darkBlue,
                        ),
                        label: Text(
                          'Logout',
                          style: TextStyle(color: Colours.darkBlue),
                        )),
                  )
                ],
              ),
            ),
          );
  //      },
 //     },
 //   ));
  }
}

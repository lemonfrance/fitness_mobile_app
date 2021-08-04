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

import '../loading.dart';

class AppDrawer extends StatefulWidget {
  AppDrawer(this.pageName) : super();
  final String pageName;
  bool account = false;
  String name = '';

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final AuthService _auth = AuthService();
  final url =
      'https://www.fitbit.com/oauth2/authorize?response_type=code&client_id=23B82K&redirect_uri=http%3A%2F%2Flocalhost&scope=activity%20heartrate%20location%20nutrition%20profile%20settings%20sleep%20social%20weight';
  bool loading = false;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<bool> _FitBitAccount = getAccount();
  SharedPreferences? prefs;

  Future<bool> getAccount() async {
    prefs = await _prefs;
    widget.account = prefs!.getBool('account') ?? false;
    return widget.account;
  }

  Future<String> getName() async {
    prefs = await _prefs;
    widget.name = prefs!.getString('name') ?? '';
    return widget.name;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.name);
    getAccount();
    getName();
    return Container(
        child: FutureBuilder<bool>(
      future: _FitBitAccount,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
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
                          child: widget.account
                              ? Text("Welcome ${widget.name}")
                              : ElevatedButton(
                                  onPressed: () async {
                                    setState(() => loading = true);
                                    final user = await _auth.getUser();
                                    final uid = user.uid;
                                    String code =
                                        await FitBitService().getCode();
                                    String authToken = await FitBitService()
                                        .getAuthToken(code);

                                    widget.account = await FitBitService()
                                        .getFitBitData(authToken, uid);
                                    widget.name =
                                        await DatabaseService(uid: uid)
                                            .getFirstName();

                                    setState(() => {
                                          widget.account = widget.account,
                                          _FitBitAccount = prefs!.setBool(
                                              'account', widget.account),
                                          loading = false,
                                        });
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
        }
      },
    ));
  }
}

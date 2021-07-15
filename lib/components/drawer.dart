import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:html';
import 'package:url_launcher/url_launcher.dart';
import 'package:wearable_intelligence/Services/auth.dart';
import 'package:wearable_intelligence/Services/fitbit.dart';
import 'package:wearable_intelligence/pages/calender.dart';
import 'package:wearable_intelligence/pages/vitals.dart';
import 'package:wearable_intelligence/pages/weekPlan.dart';
import 'package:wearable_intelligence/styles.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';


import '../main.dart';

// Eventually I would like it if this showed the user profile in the nav bar as well.
class AppDrawer extends StatelessWidget {
  static String pageName = '';
  final AuthService _auth = AuthService();
  final url = 'https://www.fitbit.com/oauth2/authorize?response_type=code&client_id=23B82K&redirect_uri=http%3A%2F%2Flocalhost&scope=activity%20heartrate%20location%20nutrition%20profile%20settings%20sleep%20social%20weight';

  final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    padding: EdgeInsets.only(left: 16, right: 16),
    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
    primary: Colors.red,
    onPrimary: Colors.black,
    onSurface: Colors.transparent,
    shadowColor: Colors.transparent,
    elevation: 0,
  );

  AppDrawer(String page) {
    pageName = page;
    print(page);
  }
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
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () async {},
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
                    MaterialPageRoute(builder: (context) => MyHomePage('Wearable Intelligence')),
                  );
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Home",
                    style: TextStyle(fontWeight: (pageName == "Home") ? FontWeight.bold : FontWeight.normal, fontSize: 16),
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
                    MaterialPageRoute(builder: (context) => Calender('Calender')),
                  );
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Calender",
                    style: TextStyle(fontWeight: (pageName == "Calender") ? FontWeight.bold : FontWeight.normal, fontSize: 16),
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
                    MaterialPageRoute(builder: (context) => ExercisePlan('Exercise Plan')),
                  );
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Exercise Plan",
                    style: TextStyle(fontWeight: (pageName == "Exercise Plan") ? FontWeight.bold : FontWeight.normal, fontSize: 16),
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
                    MaterialPageRoute(builder: (context) => Vitals('Vitals')),
                  );
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Progress",
                    style: TextStyle(fontWeight: (pageName == "Progress") ? FontWeight.bold : FontWeight.normal, fontSize: 16),
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
                  icon: Icon(Icons.logout, color: Colours.darkBlue,),
                  label: Text('Logout', style: TextStyle(color: Colours.darkBlue),)
              ),
            )
          ],
        ),
      ),
    );
  }
}

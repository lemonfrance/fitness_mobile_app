import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wearable_intelligence/styles.dart';

// Eventually I would like it if this showed the user profile in the nav bar as well.
class AppDrawer extends StatelessWidget {
  static String pageName;

  AppDrawer(String page) {
    pageName = page;
    print(page);
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: EdgeInsets.only(left: 16, top: 50, right: 16, bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              child: Container(
                width: 100,
                height: 100,
                padding: EdgeInsets.only(bottom: 16),
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
                onPressed: () {},
                child: Text("Login"),
                style: ElevatedButton.styleFrom(
                  primary: Colours.lightBlue,
                  onSurface: Colours.white,
                ),
              ),
            ),
            Text(
              "Home",
              style: TextStyle(fontWeight: (pageName == "Home") ? FontWeight.bold : FontWeight.normal),
            ),
            Text(
              "Calender",
              style: TextStyle(fontWeight: (pageName == "Calender") ? FontWeight.bold : FontWeight.normal),
            ),
            Text(
              "Week Plan",
              style: TextStyle(fontWeight: (pageName == "Week Plan") ? FontWeight.bold : FontWeight.normal),
            ),
            Text(
              "Progress",
              style: TextStyle(fontWeight: (pageName == "Progress") ? FontWeight.bold : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}

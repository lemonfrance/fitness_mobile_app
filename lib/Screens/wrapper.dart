import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wearable_intelligence/Screens/authenticate/authenticate.dart';
import 'package:wearable_intelligence/pages/homepage.dart';
import 'package:wearable_intelligence/pages/welcome.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    // return either home or authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return WelcomePage();
    }
  }
}

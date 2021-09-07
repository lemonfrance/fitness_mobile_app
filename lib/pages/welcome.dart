import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:wearable_intelligence/Services/database.dart';
import 'package:wearable_intelligence/Services/fitbit.dart';
import 'package:wearable_intelligence/pages/homepage.dart';
import '../loading.dart';
import 'package:wearable_intelligence/utils/globals.dart' as global;
import 'package:flutter/material.dart';

Future verifyFitbit() async {
  FirebaseAuth mAuth = FirebaseAuth.instance;

  final user = await DatabaseService(uid: mAuth.currentUser!.uid).getFitbitUser();
  final refreshToken = await DatabaseService(uid: mAuth.currentUser!.uid).getRefreshToken();
  global.name = await DatabaseService(uid: mAuth.currentUser!.uid).getFirstName();
  if (user != '') {
    print(refreshToken);
    await FitBitService().getRefreshToken(refreshToken);
    await FitBitService().getDailyGoals();
    await FitBitService().getHeartRates();
    global.fitBitAccount=true;
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 10),
            () =>
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) =>
                    MyHomePage('Wearable Intelligence')
                )
            )
    );
  }
  @override
  Widget build(BuildContext context) {
    verifyFitbit();
    return Loading();
  }
}

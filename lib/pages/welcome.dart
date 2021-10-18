import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wearable_intelligence/Services/database.dart';
import 'package:wearable_intelligence/Services/evaluation.dart';
import 'package:wearable_intelligence/Services/fitbit.dart';
import 'package:wearable_intelligence/utils/globals.dart';
import 'package:wearable_intelligence/utils/onboardingQuestions.dart';
import 'package:wearable_intelligence/wearableIntelligence.dart';

import '../loading.dart';

Future verifyFitbit(BuildContext context) async {
  FirebaseAuth mAuth = FirebaseAuth.instance;

  final user = await DatabaseService(uid: mAuth.currentUser!.uid).getFitbitUser();
  final refreshToken = await DatabaseService(uid: mAuth.currentUser!.uid).getRefreshToken();
  name = await DatabaseService(uid: mAuth.currentUser!.uid).getFirstName();
  level = await DatabaseService(uid: mAuth.currentUser!.uid).getLevel();
  if (user != '') {
    await FitBitService().getRefreshToken(refreshToken);
    await FitBitService().getHeartRateInformation();
    await DatabaseService(uid: mAuth.currentUser!.uid).getExercisePlan();
    await FitBitService().getHeartRateDay();
    await EvaluationService().getTodaysData(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    fitBitAccount = true;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WearableIntelligence('Wearable Intelligence')));
  }
}

Future loadNewAccount(BuildContext context) async {
  FirebaseAuth mAuth = FirebaseAuth.instance;

  await FitBitService().getAuthToken(accessToken!);
  await FitBitService().getFitBitData(authToken, mAuth.currentUser!.uid);
  name = await DatabaseService(uid: mAuth.currentUser!.uid).getFirstName();
  await FitBitService().getHeartRateInformation();
  await CreateInitalExercisePlan(mAuth);
  await DatabaseService(uid: mAuth.currentUser!.uid).getExercisePlan();
  await EvaluationService().getTodaysData(DateFormat('yyyy-MM-dd').format(DateTime.now()));

  firstFitbit = false;

  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WearableIntelligence('Wearable Intelligence')));
}

Future CreateInitalExercisePlan(FirebaseAuth mAuth) async {
  String exerciseType;
  String heartRateRange = "77 - 95% Heart rate";
  int reps = 0;

  if (level == 1) {
    if (levelOneQuestions[0]["pain"] >= 6)
      exerciseType = "Swimming";
    else {
      exerciseType = "Walking";
    }
    reps = 5;
  } else if (level == 2) {
    exerciseType = "Jogging";
    reps = 10;
  } else {
    exerciseType = "Running";
    reps = 15;
  }

  for (int i = 1; i < 6; i++) {
    await DatabaseService(uid: mAuth.currentUser!.uid).createExercisePlan(i.toString(), exerciseType, '', heartRateRange, reps, 60);
  }
  await DatabaseService(uid: mAuth.currentUser!.uid).createExercisePlan(6.toString(), "Rest", '', '', 0, 0);
  await DatabaseService(uid: mAuth.currentUser!.uid).createExercisePlan(7.toString(), "Rest", '', '', 0, 0);
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
        () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WearableIntelligence('Wearable Intelligence'))));
  }

  @override
  Widget build(BuildContext context) {
    if (firstFitbit) {
      loadNewAccount(context);
    } else {
      verifyFitbit(context);
    }
    return Loading();
  }
}

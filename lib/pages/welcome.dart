import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wearable_intelligence/Services/database.dart';
import 'package:wearable_intelligence/Services/fitbit.dart';
import 'package:wearable_intelligence/utils/globals.dart' as global;
import 'package:wearable_intelligence/wearableIntelligence.dart';
import 'package:wearable_intelligence/utils/onboardingQuestions.dart';
import '../loading.dart';

Future verifyFitbit(BuildContext context) async {
  FirebaseAuth mAuth = FirebaseAuth.instance;

  final user = await DatabaseService(uid: mAuth.currentUser!.uid).getFitbitUser();
  final refreshToken = await DatabaseService(uid: mAuth.currentUser!.uid).getRefreshToken();
  global.name = await DatabaseService(uid: mAuth.currentUser!.uid).getFirstName();
  global.level = await DatabaseService(uid: mAuth.currentUser!.uid).getLevel();
  if (user != '') {
    await FitBitService().getRefreshToken(refreshToken);
    await FitBitService().getHeartRates();
    await DatabaseService(uid: mAuth.currentUser!.uid).getExercisePlan();
    global.fitBitAccount = true;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WearableIntelligence('Wearable Intelligence')));
  }
}

Future loadNewAccount(BuildContext context) async {
  FirebaseAuth mAuth = FirebaseAuth.instance;

  await FitBitService().getAuthToken(global.accessToken!);
  await FitBitService().getFitBitData(global.authToken, mAuth.currentUser!.uid);
  global.name = await DatabaseService(uid: mAuth.currentUser!.uid).getFirstName();
  await FitBitService().getHeartRates();
  await CreateInitalExercisePlan(mAuth);
  await DatabaseService(uid: mAuth.currentUser!.uid).getExercisePlan();
  global.firstFitbit = false;

  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WearableIntelligence('Wearable Intelligence')));
}


Future CreateInitalExercisePlan(FirebaseAuth mAuth) async{
   List exerciseType = [];
   String heartRateRange = global.heartRateMin.toString() +" - " + global.heartRateMax.toString() + "bpm";
   for(int i = 0;i<exerciseTypes.length;i++){
     if(exerciseTypes[i]["selected"]){
       exerciseType.add(exerciseTypes[i]["type"]);
     }
   }

   if(exerciseType.isEmpty){
     if(global.level == 1){
       if(levelOneQuestions[0]["pain"]>=8)
        exerciseType.add("Swimming");
       else{
         exerciseType.add("Walking");
       }
     } else if(global.level == 2){
       exerciseType.add("Running");
     } else{
       if(levelThreeQuestions[0]["selected"] || (!levelThreeQuestions[1]["selected"] && !levelThreeQuestions[2]["selected"])){
         exerciseType.add("Running");
       }
       if (levelThreeQuestions[1]["selected"]){
         exerciseType.add("Swimming");
       }
       if(levelThreeQuestions[2]["selected"]){
         exerciseType.add("Cycling");
       }
     }
   }

   int index = 0;
   for(int i = 1;i<6;i++){
     await DatabaseService(uid: mAuth.currentUser!.uid).createExercisePlan(i.toString(), exerciseType[index], '', heartRateRange);
     index++;
     if(index == exerciseType.length){
       index = 0;
     }
   }
   await DatabaseService(uid: mAuth.currentUser!.uid).createExercisePlan(6.toString(), "Rest", '', '');
   await DatabaseService(uid: mAuth.currentUser!.uid).createExercisePlan(7.toString(), "Rest", '', '');


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
    if(global.firstFitbit){
      loadNewAccount(context);
    }else{
      verifyFitbit(context);
    }
    return Loading();
  }
}

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wearable_intelligence/Services/database.dart';
import 'package:wearable_intelligence/Services/fitbit.dart';
import 'package:wearable_intelligence/utils/globals.dart';
import 'package:wearable_intelligence/wearableIntelligence.dart';
import 'package:wearable_intelligence/utils/onboardingQuestions.dart';
import '../loading.dart';

Future verifyFitbit(BuildContext context) async {
  FirebaseAuth mAuth = FirebaseAuth.instance;



  final user = await DatabaseService(uid: mAuth.currentUser!.uid).getFitbitUser();
  final refreshToken = await DatabaseService(uid: mAuth.currentUser!.uid).getRefreshToken();
  await DatabaseService(uid: mAuth.currentUser!.uid).getPreferredExercises();
  name = await DatabaseService(uid: mAuth.currentUser!.uid).getFirstName();
  level = await DatabaseService(uid: mAuth.currentUser!.uid).getLevel();
  if (user != '') {
    await FitBitService().getRefreshToken(refreshToken);
    await FitBitService().getHeartRateInformation();
    await DatabaseService(uid: mAuth.currentUser!.uid).getExercisePlan();
    await FitBitService().getHeartRate30();
    await FitBitService().getHeartRateDay();
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
  firstFitbit = false;

  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WearableIntelligence('Wearable Intelligence')));
}


Future CreateInitalExercisePlan(FirebaseAuth mAuth) async{
   List exerciseType = [];
   String heartRateRange = heartRateMin.toString() +" - " + heartRateMax.toString() + "bpm";
   for(int i = 0;i<exerciseTypes.length;i++){
     if(exerciseTypes[i]["selected"]){
       exerciseType.add(exerciseTypes[i]["type"]);
     }
   }

   if(exerciseType.isEmpty){
     if(level == 1){
       if(levelOneQuestions[0]["pain"]>=8)
        exerciseType.add("Swimming");
       else{
         exerciseType.add("Walking");
       }
     } else if(level == 2){
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
    if(firstFitbit){
      loadNewAccount(context);
    }else{
      verifyFitbit(context);
    }
    return Loading();
  }
}

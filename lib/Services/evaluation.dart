import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wearable_intelligence/utils/globals.dart';

class EvaluationService {
  EvaluationService();
  String userId = FirebaseAuth.instance.currentUser!.uid;

  final CollectionReference evaluationCollection = FirebaseFirestore.instance.collection('evaluation');

  Future setResponses(String date, String exerciseType, bool chestPain, bool coldSweats, int difficulty, int pain) async {
    return await evaluationCollection.doc(userId).collection('completedWorkouts').doc(date).set({
      'exerciseType': exerciseType,
      'chestPain': chestPain,
      'coldSweats': coldSweats,
      'difficultyLevel': difficulty,
      'painLevel': pain,
    });
  }

  Future setHeartRateData(String date) async {
    return await evaluationCollection.doc(userId).collection('completedWorkouts').doc(date).update({'heartRates': workoutHeartRatesDB});
  }

  Future getTodaysData(String date) async {
    try {
      var value = await evaluationCollection.doc(userId).collection("completedWorkouts").doc(date).get();
      value.get("0");
      exercisedToday = true;
    } catch (e) {
      exercisedToday = false;
    }
  }
}

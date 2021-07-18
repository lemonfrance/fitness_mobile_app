import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseService {

  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference wearIntelCollection = FirebaseFirestore.instance.collection('wearIntel');
  final CollectionReference exerciseCollection = FirebaseFirestore.instance.collection('exercises');

  Stream<QuerySnapshot> get users {
    return wearIntelCollection.snapshots();
  }

  Future updateUserData(String username, String email) async {
    return await wearIntelCollection.doc(uid).set({
      'username': username,
      'email': email,
    });
  }

  Future updateUserFitBitData(String firstName, String lastName, int age, int height, int weight,
  String gender, String birthDate) async {
    return await wearIntelCollection.doc(uid).update({
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'height': height,
      'weight': weight,
      'gender': gender,
      'birthDate': birthDate,
    });
  }

  Future getUserData(String uid) async {
    return await wearIntelCollection.doc(uid).get().then((value){
      print(value.data());
    });
  }


  Stream<QuerySnapshot> get exercises {
    return exerciseCollection.snapshots();
  }

  Future getExerciseData() async {
    final snapshot = await exerciseCollection.get();
    for (var doc in snapshot.docs ){
      print(doc.data());
    }
  }

  Future getExercise(weekID) async {
    final ID = await DatabaseService(uid: uid).getWeekPlan(weekID);
    String exerciseId = ID.toString();
    final value = await exerciseCollection.doc(exerciseId).get();
    var data = value.get('description');
    return data;
  }

  Future getWeekPlan(int weekID) async {
   final value = await wearIntelCollection.doc(uid).get();
   var weekPlan = value.get('weekPlanID');
   return weekPlan[weekID];
  }

  Future updateWeekPlan(String weekID, String exerciseID) async {
    return await wearIntelCollection.doc(uid).set({
    'weekPlanID': {'$weekID': exerciseID}
    });
  }


}
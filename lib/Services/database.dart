import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  final CollectionReference wearIntelCollection = FirebaseFirestore.instance.collection('wearIntel');
  final CollectionReference exerciseCollection = FirebaseFirestore.instance.collection('exercises');

  Stream<QuerySnapshot> get users {
    return wearIntelCollection.snapshots();
  }

  Future updateUserData(String username, String email) async {
    return await wearIntelCollection.doc(uid).update({
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

  Future getExercise(exerciseId) async {
    return await wearIntelCollection.doc(exerciseId).get();
  }

  Stream<QuerySnapshot> get weekPlan {
    return weekPlanCollection.snapshots();
  }

  Future getWeekPlan(String day, String weekID) async {
    var Day;
    await weekPlanCollection.doc(weekID).get().then((value){
      Day = value.data();
    });
    return Day['$day'];

  }

  Future updateWeekPlan(String day, String exerciseID) async {
    return await weekPlanCollection.doc("0").set({
      '$day': exerciseID
    });
  }


}
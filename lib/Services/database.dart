import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wearable_intelligence/models/exercisePlan.dart';
import 'package:wearable_intelligence/utils/globals.dart';
import 'package:wearable_intelligence/utils/onboardingQuestions.dart';


class DatabaseService {

  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference wearIntelCollection = FirebaseFirestore.instance.collection('wearIntel');

  Stream<QuerySnapshot> get users {
    return wearIntelCollection.snapshots();
  }

  Future updateUserData(String username, String email) async {
    return await wearIntelCollection.doc(uid).set({
      'username': username,
      'email': email,
      'firstName': '',
      'lastName': '',
      'age': '',
      'height': '',
      'weight': '',
      'gender': '',
      'birthDate': '',
      'totalHours':0,
      'refreshToken':'',
      'authToken':'',
      'fitbitId':'',
      'fitnessLevel':0
    });
  }

  Future updateUserFitBitData(String firstName, String lastName, int age, double height, double weight,
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

  Future updateToken(String refreshToken, String authToken, String userId) async {
    return await wearIntelCollection.doc(uid).update({
      'refreshToken': refreshToken,
      'authToken': authToken,
      'fitbitId': userId
    });
  }

  Future setLevel(int level) async{
    return await wearIntelCollection.doc(uid).update(
      {'fitnessLevel':level}
    );
  }

  Future getFitbitUser() async {
    final value = await wearIntelCollection.doc(uid).get();
    return value.get('fitbitId').toString();
  }

  Future getRefreshToken() async {
    final value = await wearIntelCollection.doc(uid).get();
    return value.get('refreshToken').toString();
  }

  Future getUserData() async {
    return await wearIntelCollection.doc(uid).get().then((value){
      print(value.data());
    });
  }

  Future getFirstName() async {
    final value = await wearIntelCollection.doc(uid).get();
    return value.get('firstName').toString();
  }

  Future getLastName() async {
    final value = await wearIntelCollection.doc(uid).get();
    return value.get('lastName').toString();
  }

  Future getAge() async {
    final value = await wearIntelCollection.doc(uid).get();
    return value.get('age').toString();
  }

  Future getHeight() async {
    final value = await wearIntelCollection.doc(uid).get();
    return value.get('height').toString();
  }

  Future getWeight() async {
    final value = await wearIntelCollection.doc(uid).get();
    return value.get('weight').toString();
  }

  Future getGender() async {
    final value = await wearIntelCollection.doc(uid).get();
    return value.get('gender').toString();
  }

  Future getBirthDate() async {
    final value = await wearIntelCollection.doc(uid).get();
    return value.get('dateOfBirth').toString();
  }

  Future getLevel() async {
    final value = await wearIntelCollection.doc(uid).get();
    return int.parse(value.get('fitnessLevel').toString());
  }

  Future getExercisePlan() async {
    weekPlan = [];
    final value = await wearIntelCollection.doc(uid).collection("ExercisePlan").get();
    for(DocumentSnapshot doc in value.docs){
      weekPlan.add(new ExercisePlan(doc.get("type"), doc.get("description"), doc.get("heartRate"), doc.get("reps"), doc.get("rest")));
    }
  }

  Future createExercisePlan(String day, String type, String description, String heartRate, int reps, int rest) async{
    await wearIntelCollection.doc(uid).collection("ExercisePlan").doc(day).set({
      'type': type,
      'description': description,
      'heartRate': heartRate,
      'reps': reps,
      'rest' : rest
    });
  }

  Future updateExercisePlan(String day, ExercisePlan plan) async{
    await wearIntelCollection.doc(uid).collection("ExercisePlan").doc(day).update({
      'type': plan.getType,
      'description': plan.getDescription,
      'heartRate': plan.getHeartRate,
      'reps': plan.getReps,
      'rest' : plan.getRest
    });
  }
}
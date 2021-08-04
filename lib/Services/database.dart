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
      'firstName': '',
      'lastName': '',
      'age': '',
      'height': '',
      'weight': '',
      'gender': '',
      'birthDate': '',
      'weekPlan':[],
      'questionnaireScore':0,
      'totalHours':0,
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
    var data = value.get('name');
    return data;
  }

  Future getExerciseDescription(weekID) async {
    final ID = await DatabaseService(uid: uid).getWeekPlan(weekID);
    String exerciseId = ID.toString();
    final value = await exerciseCollection.doc(exerciseId).get();
    var data = value.get('description');
    return data;
  }
  Future getExerciseRate(weekID) async {
    final ID = await DatabaseService(uid: uid).getWeekPlan(weekID);
    String exerciseId = ID.toString();
    final value = await exerciseCollection.doc(exerciseId).get();
    var data = value.get('heartRate');
    return data;
  }
  Future getExerciseDuration(weekID) async {
    final ID = await DatabaseService(uid: uid).getWeekPlan(weekID);
    String exerciseId = ID.toString();
    final value = await exerciseCollection.doc(exerciseId).get();
    var data = value.get('duration');
    return data;
  }
  Future getExerciseType(weekID) async {
    final ID = await DatabaseService(uid: uid).getWeekPlan(weekID);
    String exerciseId = ID.toString();
    final value = await exerciseCollection.doc(exerciseId).get();
    var data = value.get('type');
    return data;
  }
}
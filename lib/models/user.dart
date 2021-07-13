import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String username;
  String email;
  String uid;
  String firstName;
  String lastName;
  int age;
  int height;
  int weight;
  String gender;
  String birthDate;
  String weekPlanID;
  int questionnaireScore;
  int totalHours;


  Users({this.username, this.email, this.uid, this.firstName, this.lastName,
         this.age, this.height, this.weight, this.gender, this.birthDate,
         this.weekPlanID, this.questionnaireScore, this.totalHours});

}

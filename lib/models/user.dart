import 'dart:ffi';

class Users {
  String? username;
  String? email;
  String? uid;
  String? firstName;
  String? lastName;
  int? age;
  double? height;
  double? weight;
  String? gender;
  String? birthDate;
  int? totalHours;
  String? refreshToken;
  String? authToken;
  String? fitbitId;
  int? fitnessLevel;
  Array? preferredExercises;

  Users({this.username, this.email, this.uid, this.firstName, this.lastName,
         this.age, this.height, this.weight, this.gender, this.birthDate,  this.totalHours, this.refreshToken, this.authToken, this.fitbitId, this.preferredExercises});
}

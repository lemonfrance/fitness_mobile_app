import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:wearable_intelligence/pages/welcome.dart';
import 'package:wearable_intelligence/utils/globals.dart' as global;

import 'database.dart';

const Map config = const {
  'clientID': '<OAuth 2.0 Client ID>',
  'clientSecret': '<Client Secret>',
};

class FitBitService {
  FirebaseAuth mAuth = FirebaseAuth.instance;

  Future getCode(BuildContext context) async {
    const url =
        'https://www.fitbit.com/oauth2/authorize?response_type=code&client_id=23B82K&redirect_uri=wearintel://myapp&scope=activity%20heartrate%20location%20nutrition%20profile%20settings%20sleep%20social%20weight&prompt=login%20consent';

    final result = await FlutterWebAuth.authenticate(url: url, callbackUrlScheme: 'wearintel');

    //get auth code
    global.accessToken = Uri.parse(result).queryParameters['code'].toString();
    global.firstFitbit = true;
    Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomePage()));
  }

  Future reGetCode() async {
    const url =
        'https://www.fitbit.com/oauth2/authorize?response_type=code&client_id=23B82K&redirect_uri=wearintel://myapp&scope=activity%20heartrate%20location%20nutrition%20profile%20settings%20sleep%20social%20weight';

    final result = await FlutterWebAuth.authenticate(url: url, callbackUrlScheme: 'wearintel');

    //get auth code
    global.accessToken = Uri.parse(result).queryParameters['code'].toString();
  }

  Future getAuthToken(String code) async {
    http.Response response =
        await http.post(Uri.parse('https://api.fitbit.com/oauth2/token?code=$code&grant_type=authorization_code&redirect_uri=wearintel://myapp'), headers: {
      'Authorization': 'Basic MjNCODJLOjQ1MTA4ZTY1MDA0MzE2MmIzYThkODdjODNhY2JlOTdj',
      'Content-Type': 'application/x-www-form-urlencoded',
    });
    global.authToken = jsonDecode(response.body)["access_token"];
    global.refreshToken = jsonDecode(response.body)["refresh_token"];
    global.user_id = jsonDecode(response.body)["user_id"];
    global.fitBitAccount = true;

    final responseBody = (jsonDecode(response.body));
    await DatabaseService(uid: mAuth.currentUser!.uid).updateToken(responseBody["refresh_token"], responseBody["access_token"], responseBody["user_id"]);
  }

  Future getRefreshToken(refresh_token) async {
    try {
      http.Response response =
          await http.post(Uri.parse('https://api.fitbit.com/oauth2/token?refresh_token=$refresh_token&grant_type=refresh_token'), headers: {
        'Authorization': 'Basic MjNCODJLOjQ1MTA4ZTY1MDA0MzE2MmIzYThkODdjODNhY2JlOTdj',
        'Content-Type': 'application/x-www-form-urlencoded',
      });

      global.authToken = jsonDecode(response.body)["access_token"];
      global.refreshToken = jsonDecode(response.body)["refresh_token"];
      global.user_id = jsonDecode(response.body)["user_id"];
      global.fitBitAccount = true;

      final responseBody = (jsonDecode(response.body));
      await DatabaseService(uid: mAuth.currentUser!.uid).updateToken(responseBody["refresh_token"], responseBody["access_token"], responseBody["user_id"]);
    } catch (e) {
      await reGetCode();
      await getAuthToken(global.accessToken!);
    }
  }

  Future logoutFitBit() async {
    await http.post(Uri.parse('https://api.fitbit.com/oauth2/revoke?token=${global.refreshToken}'), headers: {
      'Authorization': 'Basic MjNCODJLOjQ1MTA4ZTY1MDA0MzE2MmIzYThkODdjODNhY2JlOTdj',
      'Content-Type': 'application/x-www-form-urlencoded',
    });

    global.authToken = '';
    global.refreshToken = '';
    global.user_id = '';
    await DatabaseService(uid: mAuth.currentUser!.uid).updateToken('', '', '');
    global.fitBitAccount = false;
  }

  Future getFitBitData(auth_code, uid) async {
    final http.Response response = await http.get(Uri.parse('https://api.fitbit.com/1/user/-/profile.json'), headers: {'Authorization': 'Bearer $auth_code'});
    final responseBody = (jsonDecode(response.body)["user"]);

    await DatabaseService(uid: uid).updateUserFitBitData(responseBody["firstName"], responseBody["lastName"], responseBody["age"], responseBody["height"],
        responseBody["weight"], responseBody["gender"], responseBody["dateOfBirth"]);
    return true;
  }

  Future getHeartRateInformation() async {
      http.Response response = await http.get(
          Uri.parse(
              'https://api.fitbit.com/1/user/${global.user_id}/activities/heart/date/today/7d.json'),
          headers: {'Authorization': 'Bearer ${global.authToken}'});


    global.heartRateMin = jsonDecode(response.body)["activities-heart"][0]["value"]["heartRateZones"][2]["min"];
    global.heartRateMax = jsonDecode(response.body)["activities-heart"][0]["value"]["heartRateZones"][2]["max"];

    //don't have data that can be received yet //
    global.calories = 0;
    global.totalHours = 0;
     try {
      for (int i = 0; i < 4; i++) {
        int calories = jsonDecode(response.body)["activities-heart"][0]["value"]
                ["heartRateZones"][i]["caloriesOut"]
            .round();
        global.calories += calories;
      }
      for (int i = 7; i > 0; i--) {
        var date = DateTime.now().subtract(Duration(days: i));
        global.weekActivityMinutes[date.weekday - 1] =
            jsonDecode(response.body)["activities-heart"][i - 1]["value"]
                ["heartRateZones"][2]["minutes"];
        int time = jsonDecode(response.body)["activities-heart"][i - 1]["value"]
                ["heartRateZones"][2]["minutes"]
            .round();
        global.totalHours += time;
      }
    }catch(e){
       print(e);
     }
  }

  Future getHeartRate30() async {
    var start = DateFormat("HH:mm").format(DateTime.now().subtract(Duration(minutes: 30)));
    var end = DateFormat("HH:mm").format(DateTime.now());
    http.Response response = await http.get(
        Uri.parse(
            'https://api.fitbit.com/1/user/${global.user_id}/activities/heart/date/today/1d/1min/time/$start/$end.json'),
        headers: {'Authorization': 'Bearer ${global.authToken}'});

    try {
      for (int i = 0;
          i <
              (jsonDecode(response.body)["activities-heart-intraday"]
                      ["dataset"])
                  .length;
          i++) {
        global.workoutHeartRates[i] = new global.heartRates(
            i.toString(),
            jsonDecode(response.body)["activities-heart-intraday"]["dataset"][i]
                ["value"]);
      }
    } catch(e){
      print(e);
    }
  }

  Future getHeartRateDay() async {
    var start = DateFormat("HH:mm").format(DateTime.now().subtract(Duration(days:1)));
    var end = DateFormat("HH:mm").format(DateTime.now());
    http.Response response = await http.get(
        Uri.parse(
            'https://api.fitbit.com/1/user/${global.user_id}/activities/heart/date/today/1d/1min/time/$start/$end.json'),
        headers: {'Authorization': 'Bearer ${global.authToken}'});

    try{
      for (int i = 0;
          i <
              (jsonDecode(response.body)["activities-heart-intraday"]
                          ["dataset"])
                      .length /
                  60;
          i++) {
        String time = (jsonDecode(response.body)["activities-heart-intraday"]
                ["dataset"][i * 60]["time"])
            .split(':')[0];
        global.dayHeartRates[i] = new global.heartRates(
            time,
            jsonDecode(response.body)["activities-heart-intraday"]["dataset"]
                [i * 60]["value"]);
      }
    }catch(e){
      print(e);
    }
  }
}



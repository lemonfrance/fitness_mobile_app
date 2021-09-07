import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:wearable_intelligence/utils/globals.dart' as global;
import 'package:intl/intl.dart';




import 'database.dart';

const Map config = const {
  'clientID': '<OAuth 2.0 Client ID>',
  'clientSecret': '<Client Secret>',
};

class FitBitService {

  Future getCode() async {
    const url = 'https://www.fitbit.com/oauth2/authorize?response_type=code&client_id=23B82K&redirect_uri=wearintel://myapp&scope=activity%20heartrate%20location%20nutrition%20profile%20settings%20sleep%20social%20weight';

    final result = await FlutterWebAuth.authenticate(
        url: url,
        callbackUrlScheme: 'wearintel');

    //get auth code
    global.accessToken = Uri.parse(result).queryParameters['code'].toString();

  }

  Future getAuthToken(String code) async{
    http.Response response = await http.post(Uri.parse('https://api.fitbit.com/oauth2/token?code=$code&grant_type=authorization_code&redirect_uri=wearintel://myapp'),
      headers: {
        'Authorization': 'Basic MjNCODJLOjQ1MTA4ZTY1MDA0MzE2MmIzYThkODdjODNhY2JlOTdj',
        'Content-Type' : 'application/x-www-form-urlencoded',
      });
    global.authToken = jsonDecode(response.body)["access_token"];
    global.refreshToken = jsonDecode(response.body)["refresh_token"];
    global.user_id = jsonDecode(response.body)["user_id"];
  }

  Future getRefreshToken(refresh_token) async {
    http.Response response = await http.post(Uri.parse('https://api.fitbit.com/oauth2/token?refresh_token=$refresh_token&grant_type=refresh_token'),
    headers: {
    'Authorization': 'Basic MjNCODJLOjQ1MTA4ZTY1MDA0MzE2MmIzYThkODdjODNhY2JlOTdj',
    'Content-Type' : 'application/x-www-form-urlencoded',
    });

    global.authToken = jsonDecode(response.body)["access_token"];
    global.refreshToken = jsonDecode(response.body)["refresh_token"];
    global.user_id = jsonDecode(response.body)["user_id"];
  }

  Future getFitBitData(auth_code, uid) async{
    final http.Response response = await http.get(Uri.parse('https://api.fitbit.com/1/user/-/profile.json'),
      headers: {
      'Authorization': 'Bearer $auth_code'
      }
    );
    final responseBody = (jsonDecode(response.body)["user"]);

    await DatabaseService(uid: uid).updateUserFitBitData(responseBody["firstName"], responseBody["lastName"], responseBody["age"], responseBody["height"], responseBody["weight"],
        responseBody["gender"], responseBody["dateOfBirth"]);
    return true;
  }

  Future getDailyGoals() async{
    final http.Response response = await http.get(Uri.parse('https://api.fitbit.com/1/user/${global.user_id}/activities/date/${DateFormat('yyyy-MM-dd').format(DateTime.now())}.json?'),
      headers: {
        'Authorization': 'Bearer ${global.authToken}'
      });

    global.calories = jsonDecode(response.body)["summary"]['caloriesOut'];
    global.totalHours = jsonDecode(response.body)["summary"]["activeScore"];
  }

  Future getHeartRates() async {
    var formatter = new DateFormat('yyyy-MM-dd');
    int index = 0;
    for(int i=6; i>=0; i--){
      http.Response response = await http.get(Uri.parse('https://api.fitbit.com/1/user/${global.user_id}/activities/heart/date/${formatter.format(DateTime.now().subtract(Duration(days: i)))}/1d.json'),
          headers: {
            'Authorization': 'Bearer ${global.authToken}'
          });
      global.heartRateMin = jsonDecode(response.body)["activities-heart"][0]["value"]["heartRateZones"][1]["min"];
      global.heartRateMax = jsonDecode(response.body)["activities-heart"][0]["value"]["heartRateZones"][1]["max"];
     //don't have data that can be received yet // global.weekActivityMinutes[index] = jsonDecode(response.body)["activities-heart"][0]["value"]["heartRateZones"][1]["minutes"];
      index ++;
    }
  }

}
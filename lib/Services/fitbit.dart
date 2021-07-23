import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_web_auth/flutter_web_auth.dart';



import 'database.dart';

const Map config = const {
  'clientID': '<OAuth 2.0 Client ID>',
  'clientSecret': '<Client Secret>',
};

class FitBitService {

  Future<String> getCode() async {
    const url = 'https://www.fitbit.com/oauth2/authorize?response_type=code&client_id=23B82K&redirect_uri=wearintel://myapp&scope=activity%20heartrate%20location%20nutrition%20profile%20settings%20sleep%20social%20weight&expires_in=604800';

    final result = await FlutterWebAuth.authenticate(
        url: url,
        callbackUrlScheme: 'wearintel');

    //get auth code
    return Uri.parse(result).queryParameters['code'].toString();

  }

  Future getAuthToken(String code) async{
    http.Response response = await http.post(Uri.parse('https://api.fitbit.com/oauth2/token?code=$code&grant_type=authorization_code&redirect_uri=wearintel://myapp'),
      headers: {
        'Authorization': 'Basic MjNCODJLOjQ1MTA4ZTY1MDA0MzE2MmIzYThkODdjODNhY2JlOTdj',
        'Content-Type' : 'application/x-www-form-urlencoded',
      });
    return (jsonDecode(response.body)["refresh_token"]);

  }

  Future<http.Response> getRefreshToken(refresh_token) {
    return http.post(Uri.parse('https://api.fitbit.com/oauth2/token?refresh_token=$refresh_token&grant_type=refresh_token'),
        headers: {
          'refresh_token': refresh_token,
          'grant_type' : 'refresh_token',
        });
  }

  Future getFitBitData(auth_code, uid) async{
    final http.Response response = await http.get(Uri.parse('https://api.fitbit.com/1/user/-/profile.json'),
      headers: {
      'Authorization': 'Bearer $auth_code'
      }
    );
    final responseBody = (jsonDecode(response.body)["user"]);
    print(responseBody);
    await DatabaseService(uid: uid).updateUserFitBitData(responseBody["firstName"], responseBody["lastName"], responseBody["age"], responseBody["height"], responseBody["weight"],
        responseBody["gender"], responseBody["dateOfBirth"]);
    return true;
  }

}
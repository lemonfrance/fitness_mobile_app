import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wearable_intelligence/Services/auth.dart';
import 'package:wearable_intelligence/Services/database.dart';
import 'package:wearable_intelligence/styles.dart';
import 'package:wearable_intelligence/Services/fitbit.dart';



class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  final url = 'https://www.fitbit.com/oauth2/authorize?response_type=code&client_id=23B82K&redirect_uri=http%3A%2F%2Flocalhost&scope=activity%20heartrate%20location%20nutrition%20profile%20settings%20sleep%20social%20weight';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colours.white,
        appBar: AppBar(
          title: Text('Signed In'),
          backgroundColor: Colours.highlight,
          elevation: 0.0,
        ),
        body: Container(
          child: Center(
            child: Column(
                children: <Widget>[
                  MaterialButton(
                    onPressed: () async {

                      //FitBitService().getCode(); <-- automated process throws PlugIn error
                      //launch url
                      // if (await canLaunch(url)) {
                      //   await launch(url);
                      // } else {
                      //   throw 'Could not launch $url';
                      // }

                      //returns user data
                        final user = await _auth.getUser();
                        final uid = user.uid;
                      //  DatabaseService().getUserData(uid);

                      //FitBitService().getRefreshToken(  ); <-- cors error
                      //FitBitService().getAuthToken();
                      // ^^ get the Bearer token from getAuthToken response
                      FitBitService().getFitBitData('Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyM0I4MksiLCJzdWIiOiI5RzQ0TlIiLCJpc3MiOiJGaXRiaXQiLCJ0eXAiOiJhY2Nlc3NfdG9rZW4iLCJzY29wZXMiOiJyc29jIHJhY3QgcnNldCBybG9jIHJ3ZWkgcmhyIHJwcm8gcm51dCByc2xlIiwiZXhwIjoxNjI1NTYzMzk2LCJpYXQiOjE2MjU1MzQ1OTZ9.C782mk3y9Ri9TYMnZr_oO_v8WV6gHQy7jny08n4cyes', uid);
                      //final plan = DatabaseService().getWeekPlan('Monday', '0');


                    },
                    child: Text('Connect to Fitbit', style: TextStyle(color: Colours.white)),
                    color: Colours.darkBlue,

                  ),
                  TextButton.icon(
                      onPressed: () async {
                        await _auth.signOut();
                      },
                      icon: Icon(Icons.logout, color: Colours.darkBlue,),
                      label: Text('Logout', style: TextStyle(color: Colours.darkBlue),)
                  )
                ]
                )
            )
          )
    );
  }
}

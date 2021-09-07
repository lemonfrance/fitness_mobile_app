import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wearable_intelligence/Services/database.dart';
import 'package:wearable_intelligence/Services/fitbit.dart';
import 'package:wearable_intelligence/components/drawer_state.dart';
import 'package:wearable_intelligence/components/exercisePlanTile.dart';
import 'package:wearable_intelligence/components/progressCircle.dart';
import 'package:wearable_intelligence/utils/globals.dart' as global;

import '../loading.dart';
import '../styles.dart';

Future getDailyStats() async {
  await FitBitService().getDailyGoals();
  await FitBitService().getHeartRates();
}

class MyHomePage extends StatefulWidget {
  MyHomePage(this.title) : super();

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseAuth mAuth = FirebaseAuth.instance;
  bool loading = false;

  Widget logInScreen() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/runner.png'),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              children: [
                Text('Welcome', style: TextStyle(fontSize: 60, color: Colours.darkBlue, fontWeight: FontWeight.w700)),
                Text('Log in to Fitbit to get started', style: TextStyle(fontSize: 20, color: Colours.darkBlue, fontWeight: FontWeight.w300)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 70),
            child: ElevatedButton(
              onPressed: () async {
                setState(() => loading = true);

                await FitBitService().getCode();
                await FitBitService().getAuthToken(global.accessToken!);

                global.fitBitAccount = await FitBitService().getFitBitData(global.authToken, mAuth.currentUser!.uid);
                global.name = await DatabaseService(uid: mAuth.currentUser!.uid).getFirstName();
                await FitBitService().getDailyGoals();
                await FitBitService().getHeartRates();

                setState(() => {loading = false});
              },
              child: Text(
                "Log in",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colours.white, fontSize: 24),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colours.highlight,
                onPrimary: Colours.white,
                minimumSize: Size(MediaQuery.of(context).size.width - 40, 45),
                shape: StadiumBorder(),
                elevation: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget homeScreen() {
    return loading
        ? Loading()
        : Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                exercisePlan(MediaQuery.of(context).size.width - 40, 1000, 75, 150, 30),
                ProgressCircle(90.0, Colours.highlight),
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.theme.backgroundColor,
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0.0,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colours.darkBlue,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colours.darkBlue,
        ),
        elevation: 0,
        backgroundColor: AppTheme.theme.backgroundColor,
        foregroundColor: Colours.darkBlue,
      ),
      drawer: AppDrawer('Home'),
      body: !(global.fitBitAccount == true) ? logInScreen() : homeScreen(),
    );
  }
}

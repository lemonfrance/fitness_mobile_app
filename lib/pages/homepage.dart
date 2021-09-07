import 'package:firebase_auth/firebase_auth.dart';
import 'package:wearable_intelligence/Services/database.dart';
import 'package:wearable_intelligence/components/drawer_state.dart';
import 'package:wearable_intelligence/components/progressCircle.dart';
import 'package:wearable_intelligence/Services/fitbit.dart';
import '../loading.dart';
import '../styles.dart';
import 'package:wearable_intelligence/utils/globals.dart' as global;
import 'package:flutter/material.dart';

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
      body:!(global.fitBitAccount == true)
                  ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(height: 40),
                    Text('Welcome', style: TextStyle(fontSize: 60, color: Colours.darkBlue, fontWeight:FontWeight.w700)),
                    Text('Log in to Fitbit to get started', style: TextStyle(fontSize: 20, color: Colours.darkBlue, fontWeight:FontWeight.w300)),
                    Container(height: 40),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() => loading = true);

                        await FitBitService().getCode();
                        await FitBitService().getAuthToken(global.accessToken!);

                        global.fitBitAccount = await FitBitService()
                            .getFitBitData(
                                global.authToken, mAuth.currentUser!.uid);
                        global.name =
                            await DatabaseService(uid: mAuth.currentUser!.uid)
                                .getFirstName();
                        await FitBitService().getDailyGoals();
                        await FitBitService().getHeartRates();

                        setState(() => {loading = false});
                      },
                      child: Text("Log in", style: TextStyle(fontSize: 20)),
                      style: ElevatedButton.styleFrom(
                        primary: Colours.highlight,
                        onSurface: Colours.white,
                      ),
                    )
                  ]): SingleChildScrollView(
                      //   something for when they haven't signed into fitbit
                      child: loading
                          ? Loading()
                          : Column(
                              children: [
                                Container(height: 20),
                                ProgressCircle(90.0, Colours.highlight),
                                Container(height: 20),
                              ],
                            ),
                    )
    );
  }
}

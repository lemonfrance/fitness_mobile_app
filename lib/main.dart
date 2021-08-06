import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wearable_intelligence/Screens/wrapper.dart';
import 'package:wearable_intelligence/Services/auth.dart';
import 'package:wearable_intelligence/Services/fitbit.dart';
import 'package:wearable_intelligence/models/user.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:wearable_intelligence/components/drawer_state.dart';
import 'package:wearable_intelligence/components/progressCircle.dart';
import 'package:wearable_intelligence/components/progressTile.dart';
import 'package:wearable_intelligence/styles.dart';
import 'package:wearable_intelligence/utils/globals.dart' as global;


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

Future getRefreshToken() async {
   await FitBitService().getRefreshToken(global.refreshToken);
}

Future getDailyStats() async {
  await FitBitService().getDailyGoals();
  //await FitBitService().getHeartRates();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if(global.fitBitAccount){
      getRefreshToken();
    }
    return StreamProvider<Users?>.value(
      value: AuthService().user,
      initialData: Users(),
      child: MaterialApp(
        title: 'Wearable Intelligence',
        theme: AppTheme.theme,
        home: Wrapper(),
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(this.title) : super();

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget goals() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colours.lightBlue,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Text(
            "Goal: Exercise 5 times",
            style: TextStyle(color: Colours.white, fontSize: 26, fontWeight: FontWeight.bold),
          ),
          Container(height: 20),
          Container(
            width: width,
            padding: EdgeInsets.only(left: 16),
            child: Text(
              "Weekly Average",
              style: TextStyle(color: Colours.white, fontSize: 18),
              textAlign: TextAlign.start,
            ),
          ),
          Container(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "0",
                style: TextStyle(color: Colours.white, fontSize: 18, height: 1.1),
              ),
              LinearPercentIndicator(
                width: width * 0.8,
                lineHeight: 6,
                percent: 0.8,
                backgroundColor: Colors.white,
                progressColor: Colours.darkBlue,
              ),
              Text(
                "5",
                style: TextStyle(color: Colours.white, fontSize: 18, height: 1.1),
              ),
            ],
          ),
          Container(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(global.fitBitAccount){
      getDailyStats();
    }
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
      body: SingleChildScrollView(  // !global.fitBitAccount? Text('hello'):  something for when they haven't signed into fitbit
        child: Column(
          children: [
            Container(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ProgressTile("Calories Burned", global.calories),
                ProgressTile("Maximum Heart Rate (bpm)", 170),
              ],
            ),
            Container(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ProgressTile("kg's Lost", 5),
                ProgressTile("Total Hours", global.totalHours),
              ],
            ),
            Container(height: 40),
            ProgressCircle(90.0, Colours.highlight),
            Container(height: 40),
            goals(),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wearable_intelligence/Services/database.dart';
import 'package:wearable_intelligence/components/drawer.dart';

import '../styles.dart';

class ExercisePlan extends StatefulWidget {
  ExercisePlan(this.title) : super();

  final String title;

  @override
  _ExercisePlanState createState() => _ExercisePlanState();
}

class _ExercisePlanState extends State<ExercisePlan> {
  /// This widget creates 1 individual date for the top navigation of the screen.
  Widget date(String date, String weekday, bool selected) {
    return Container(
      height: 60,
      width: 40,
      decoration: BoxDecoration(
        color: selected ? Colours.darkBlue : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            weekday,
            style: TextStyle(color: selected ? Colours.white : Colours.black),
          ),
          Text(
            date,
            style: TextStyle(fontWeight: FontWeight.bold, color: selected ? Colours.white : Colours.black),
          ),
        ],
      ),
    );
  }

  Widget exercisePlan(double width, int steps, int heartRate, int calories, int time) {
    TextStyle textStyle = TextStyle(color: Colours.white, fontSize: 18, fontWeight: FontWeight.bold, height: 1);
    return Container(
      height: 220,
      width: width,
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colours.lightBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                'assets/images/man.svg',
              ),
              SvgPicture.asset(
                'assets/images/heartBeat.svg',
              ),
              SvgPicture.asset(
                'assets/images/calories.svg',
              ),
              SvgPicture.asset(
                'assets/images/time.svg',
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(steps.toString() + " Steps", style: textStyle),
                Text(heartRate.toString() + "% Max Heart Rate", style: textStyle),
                Text(calories.toString() + " Calories", style: textStyle),
                Text(time.toString() + " Minutes", style: textStyle),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget education(String title, String body) {
    TextStyle headerStyle = TextStyle(color: Colours.darkBlue, fontSize: 18, fontWeight: FontWeight.bold, height: 1);
    TextStyle bodyStyle = TextStyle(color: Colours.darkBlue, fontSize: 18, height: 1);
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: headerStyle),
          Text(body, style: bodyStyle),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return StreamProvider<QuerySnapshot>.value(
      value: DatabaseService().weekPlan,
      initialData: null,
      child: Scaffold(
        backgroundColor: AppTheme.theme.backgroundColor,
        appBar: AppBar(
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
        drawer: AppDrawer('Exercise Plan'),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // TODO: Don't make this static and make it scrollable for weeks to come
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  date("2", "MON", false),
                  date("3", "TUE", false),
                  date("4", "WED", false),
                  date("5", "THU", false),
                  date("6", "FRI", true),
                  date("7", "SAT", false),
                  date("8", "SUN", false),
                ],
              ),
              // This might need to change since they can click on the dates.
              Padding(
                padding: EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Today's Workout", style: TextStyle(fontWeight: FontWeight.bold, color: Colours.black, fontSize: 18)),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text("BEGIN", style: TextStyle(fontWeight: FontWeight.bold, color: Colours.white, fontSize: 24)),
                style: ElevatedButton.styleFrom(
                  primary: Colours.highlight,
                  onPrimary: Colours.white,
                  minimumSize: Size(width - 40, 45),
                  shape: StadiumBorder(),
                  elevation: 10,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: SvgPicture.asset(
                  'assets/images/walking.svg',
                  width: width - 40,
                ),
              ),
              exercisePlan(width - 40, 1000, 75, 150, 30),
              education(
                //exercise id get intensity
                //DatabaseService().getWeekPlan(weekday, id ).toString();
                "Low impact",
                "It causes less strain and injuries than most other forms of exercise.",
              ),
              education(
                //get workout name
                "Muscle workout",
                "cycling uses all of the major muscle groups as you pedal.",
              ),
              education(
                //get workout type
                "Strength and stamina",
                "cycling increases stamina, strength and aerobic fitness.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

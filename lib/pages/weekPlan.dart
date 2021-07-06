import 'package:flutter/material.dart';
import 'package:wearable_intelligence/components/drawer.dart';

import '../styles.dart';

class ExercisePlan extends StatefulWidget {
  ExercisePlan(this.title) : super();

  final String title;

  @override
  _ExercisePlanState createState() => _ExercisePlanState();
}

class _ExercisePlanState extends State<ExercisePlan> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
        children: [
          // TODO: Don't make this static
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
        ],
      ),
    );
  }
}

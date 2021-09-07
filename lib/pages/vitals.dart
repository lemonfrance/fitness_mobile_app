import 'package:flutter/material.dart';
import 'package:wearable_intelligence/components/activeMinutesGaph.dart';
import 'package:wearable_intelligence/components/drawer_state.dart';
import 'package:wearable_intelligence/components/heartrateGraph.dart';
import 'package:wearable_intelligence/components/progressTile.dart';
import 'package:wearable_intelligence/utils/globals.dart' as globals;

import '../styles.dart';

class Vitals extends StatefulWidget {
  Vitals(this.title) : super();

  final String title;

  @override
  _VitalsState createState() => _VitalsState();
}

class _VitalsState extends State<Vitals> {
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
        drawer: AppDrawer('Progress'),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(height: 20),
            HeartrateGraph(),
            Container(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ProgressTile("Calories Burned", globals.calories),
                ProgressTile("Total Hours", globals.totalHours),
              ],
            ),
            Container(height: 20),
            ActiveMinutesGraph(),
            Container(height: 20),
          ],
        )));
  }
}

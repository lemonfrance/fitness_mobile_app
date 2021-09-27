import 'package:flutter/material.dart';
import 'package:wearable_intelligence/components/activeMinutesGaph.dart';
import 'package:wearable_intelligence/components/heartrateGraph.dart';
import 'package:wearable_intelligence/components/progressTile.dart';
import 'package:wearable_intelligence/utils/globals.dart' as globals;
import 'package:wearable_intelligence/utils/styles.dart';

class Vitals extends StatefulWidget {
  Vitals() : super();

  @override
  _VitalsState createState() => _VitalsState();
}

class _VitalsState extends State<Vitals> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.theme.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(height: 20),
            HeartrateGraph(false),
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
        ),
      ),
    );
  }
}

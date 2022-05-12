import 'package:flutter/material.dart';
import 'package:wearable_intelligence/Services/fitbit.dart';
import 'package:wearable_intelligence/components/activeMinutesGaph.dart';
import 'package:wearable_intelligence/components/heartrateGraph.dart';
import 'package:wearable_intelligence/components/progressTile.dart';
import 'package:wearable_intelligence/components/plantProgress.dart';
import 'package:wearable_intelligence/utils/globals.dart';
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
            dayHeartRates.length == 0
                ? Padding(
                    padding: EdgeInsets.only(right: 20, left: 20),
                    child: MaterialButton(
                      onPressed: () async {
                        await FitBitService().getHeartRateDay();
                        await FitBitService().getHeartRateInformation();
                        setState(() {});
                      },
                      minWidth: double.infinity,
                      height: 60,
                      elevation: 10,
                      shape: StadiumBorder(),
                      color: Colours.highlight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.autorenew_rounded,
                            color: Colours.white,
                          ),
                          Container(width: 10),
                          Text(
                            "Refresh heart rate data",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colours.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  )
                : HeartrateGraph(false),
            Container(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PlantProgress(),
                ProgressTile("Total Hours", totalHours),
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

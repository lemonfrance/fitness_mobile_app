import 'package:flutter/material.dart';
import 'package:wearable_intelligence/Services/fitbit.dart';
import 'package:wearable_intelligence/components/activeMinutesGaph.dart';
import 'package:wearable_intelligence/components/heartrateGraph.dart';
import 'package:wearable_intelligence/components/progressTile.dart';
import 'package:wearable_intelligence/components/plantProgress.dart';
import 'package:wearable_intelligence/utils/globals.dart';
import 'package:wearable_intelligence/utils/styles.dart';
//new import
import 'package:bubble/bubble.dart';

class Vitals extends StatefulWidget {
  Vitals() : super();

  @override
  _VitalsState createState() => _VitalsState();
}

class _VitalsState extends State<Vitals> {
  //TODO Filler values. To be changed...
  int heartRateYesterday = dayHeartRates.length;
  int heartRateToday = dayHeartRates.length;
  int desiredHeartRate = 0;

  //TODO burned calories conditions
  List progressData(int heartrate, int calories){
    String msg = "";
    bool improvedHeartRate = true;
    bool burnedCalories = true;

    bool heartRateIncreased = (heartRateToday > heartRateYesterday);
    bool heartRateDecreased = (heartRateToday < heartRateYesterday);
    bool heartRateMaintained = (heartRateToday == heartRateYesterday);

    bool improvedIncreased = heartRateIncreased && (heartRateToday<=desiredHeartRate);
    bool improvedDecreased = heartRateDecreased && (heartRateToday>=desiredHeartRate);

    if(improvedIncreased || improvedDecreased){
      msg = "Look at that, your stats improved from yesterday! Keep it up, bud!";
    }
    else if (heartRateMaintained){
      msg = "Hey bud, it seems like your stats have not changed from yesterday...";
    }
    else{
      msg = "Hey bud, it seems like your stats have not improved at the moment...";
    }

    if(heartRateToday == desiredHeartRate){
      msg += " OMG, wait... you met our target goal! Congrats! Treat yourself to a well-deserved rest.";
    }
    else{
      msg += " Also, the target wasn't met yet. It's okay, though! Let's just keep doing our best, bud.";
      improvedHeartRate = false;
      burnedCalories = false;
    }

    return [msg,improvedHeartRate,burnedCalories];
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    List progress = progressData(heartRate,calories);

    //TODO Filler data. To be changed...
    double heartRatePercent = 80;
    double caloriesPercent = 60;

    Column displayProgress = Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: width*0.6,
                width: width*0.4,
                child: PlantProgress()
              ),
              Container(
                padding: EdgeInsets.fromLTRB(width*0.02, 0, 0, width*0.08),
                width: width*0.5,
                child: Column(
                  children:[
                    Bubble(
                      alignment:Alignment.centerLeft,
                      nip: BubbleNip.leftBottom,
                      nipWidth: 20,
                      showNip: true,
                      nipHeight: 25,
                      padding: BubbleEdges.all(12),
                      color: Colors.amberAccent,
                      child:Text(progress[0],textScaleFactor: 1)
                    ),
                    ProgressTile("hrs", "assets/images/time.svg", totalHours,false,true,100),
                    ProgressTile("bpm", "assets/images/heartBeat.svg", heartRateToday,true,progress[1],heartRatePercent),
                    ProgressTile("cal", "assets/images/calories.svg", calories,true,progress[2],caloriesPercent)
                  ]
                )
              )
            ],
          ),
          ActiveMinutesGraph(),
          Divider(height:20,color:Colors.transparent),
          HeartrateGraph(false),
          Divider(height:40,color:Colors.transparent)
          ]);

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
                : displayProgress
          ]
      ),
    ));
  }
}

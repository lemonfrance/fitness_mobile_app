import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wearable_intelligence/utils/styles.dart';

Widget exercisePlan(double width, int steps, int heartRate, int calories, int time) {
  TextStyle textStyle = TextStyle(color: Colours.white, fontSize: 18, fontWeight: FontWeight.bold, height: 1);
  return Container(
    width: width,
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colours.lightBlue,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          blurRadius: 5,
          offset: Offset(3, 3), // changes position of shadow
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/images/heartBeat.svg',
              ),
              VerticalDivider(width: 20, color: Colors.transparent),
              Text(heartRate.toString() + "% Max Heart Rate", style: textStyle),
            ],
          ),
        ),
        Row(
          children: [
            SvgPicture.asset(
              'assets/images/time.svg',
            ),
            VerticalDivider(width: 20, color: Colors.transparent),
            Text(time.toString() + " Minutes", style: textStyle),
          ],
        ),
      ],
    ),
  );
}

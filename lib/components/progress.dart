import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

// Eventually I would like it if this showed the user profile in the nav bar as well.
class Progress extends StatelessWidget {
  static double _percentage = 0;
  static Color? _colour;

  Progress(double percentage, Color colour) {
    _percentage = percentage;
    _colour = colour;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return CircularPercentIndicator(
      radius: width * 0.7,
      lineWidth: 20.0,
      animation: true,
      percent: _percentage / 100,
      center: new Text(
        _percentage.toString() + "% progress",
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      backgroundColor: Colors.transparent,
      progressColor: _colour,
    );
  }
}

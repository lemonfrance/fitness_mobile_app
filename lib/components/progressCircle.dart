import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProgressCircle extends StatefulWidget {
  ProgressCircle(this._percentage, this._colour);

  double _percentage;
  Color _colour = Color(0);

  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<ProgressCircle> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return CircularPercentIndicator(
      radius: width * 0.7,
      lineWidth: 20.0,
      animation: true,
      percent: widget._percentage / 100,
      center: new Text(
        widget._percentage.toString() + "% progress",
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      backgroundColor: Colors.transparent,
      progressColor: widget._colour,
    );
  }
}

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
      radius: width * 0.05,
      lineWidth: 2.5,
      animation: true,
      percent: widget._percentage / 100,
      circularStrokeCap: CircularStrokeCap.round,
      backgroundColor: Colors.black,
      progressColor: widget._colour,
    );
  }
}

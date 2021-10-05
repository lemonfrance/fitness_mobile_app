import 'dart:core';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wearable_intelligence/utils/globals.dart';
import 'package:wearable_intelligence/utils/styles.dart';

class HeartrateGraph extends StatefulWidget {
  bool workout;
  // ignore: prefer_const_constructors_in_immutables
  HeartrateGraph(this.workout) : super();

  @override
  _HeartrateGraphState createState() => _HeartrateGraphState();
}

class _HeartrateGraphState extends State<HeartrateGraph> {
  // new List<int>.generate(10, (i) => i + 1)

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width - 50);
    return Container(
      width: width,
      height: width / 1.5,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5,
            offset: Offset(3, 3), // changes position of shadow
          ),
        ],
      ),
      child: SfCartesianChart(
        title: ChartTitle(
          text: widget.workout ? 'Heart rate during the workout' : 'Heart rate throughout the day',
          alignment: ChartAlignment.near,
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colours.black),
        ),
        primaryYAxis: NumericAxis(
            minimum: (heartRateMin < heartRatePit) ? heartRateMin - 10 : heartRatePit - 10,
            maximum: (heartRateMax > heartRatePeak) ? heartRateMax + 10 : heartRatePeak + 10,
            labelFormat: '{value} bpm',
            plotBands: <PlotBand>[
              PlotBand(
                isVisible: true,
                start: heartRateMin,
                end: heartRateMin,
                color: Colours.lightBlue,
                opacity: 0.4,
                dashArray: <double>[5, 5],
                borderColor: Colors.grey,
                borderWidth: 2,
              ),
              PlotBand(
                isVisible: true,
                start: heartRateMax,
                end: heartRateMax,
                color: Colours.lightBlue,
                opacity: 0.4,
                dashArray: <double>[5, 5],
                borderColor: Colors.grey,
                borderWidth: 2,
              ),
              PlotBand(isVisible: true, start: heartRateMin, end: heartRateMax, color: Colours.lightBlue, opacity: 0.4),
            ],
            axisLine: AxisLine(width: 0),
            majorGridLines: MajorGridLines(width: 0),
            majorTickLines: MajorTickLines(width: 0),
            interval: 30),
        primaryXAxis: CategoryAxis(
          axisLine: AxisLine(width: 0),
          majorGridLines: MajorGridLines(width: 0),
          majorTickLines: MajorTickLines(width: 0),
          labelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        ),
        plotAreaBorderWidth: 0,
        tooltipBehavior: TooltipBehavior(enable: true, header: ''),
        series: widget.workout
            ? (<ChartSeries>[
                SplineSeries<heartRates, String>(
                  dataSource: workoutHeartRates,
                  xValueMapper: (heartRates value, _) => value.time,
                  yValueMapper: (heartRates value, _) => (value.value != 0) ? value.value : null,
                  color: Colours.highlight,
                  width: 3,
                )
              ])
            : (<ChartSeries>[
                SplineSeries<heartRates, String>(
                  dataSource: dayHeartRates,
                  xValueMapper: (heartRates value, _) => value.time,
                  yValueMapper: (heartRates value, _) => (value.value != 0) ? value.value : null,
                  color: Colours.highlight,
                  width: 3,
                )
              ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wearable_intelligence/utils/globals.dart' as globals;
import 'package:wearable_intelligence/utils/styles.dart';

class HeartrateGraph extends StatefulWidget {
  bool workout;
  // ignore: prefer_const_constructors_in_immutables
  HeartrateGraph(this.workout) : super();

  @override
  _HeartrateGraphState createState() => _HeartrateGraphState();
}

class _HeartrateGraphState extends State<HeartrateGraph> {
  List<_SalesData> data = [
    /// use active zone heart rate when available
    _SalesData('8am', 100),
    _SalesData('10am', 80),
    _SalesData('12pm', 120),
    _SalesData('2pm', 110),
    _SalesData('4pm', 90),
    _SalesData('8pm', 90),
    _SalesData('10pm', 100),
  ];

  List<_SalesData> workoutData = [
    /// use active zone heart rate when available
    _SalesData('0 min', 100),
    _SalesData('5 min', 80),
    _SalesData('10 min', 120),
    _SalesData('15 min', 110),
    _SalesData('20 min', 90),
    _SalesData('25 min', 90),
    _SalesData('30 min', 100),
  ];
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
                minimum: 60,
                maximum: 160,
                labelFormat: '{value} bpm',
                plotBands: <PlotBand>[
                  PlotBand(
                    isVisible: true,
                    start: globals.heartRateMin,
                    end: globals.heartRateMin,
                    color: Colours.lightBlue,
                    opacity: 0.4,
                    dashArray: <double>[5, 5],
                    borderColor: Colors.grey,
                    borderWidth: 2,
                  ),
                  PlotBand(
                    isVisible: true,
                    start: globals.heartRateMax,
                    end: globals.heartRateMax,
                    color: Colours.lightBlue,
                    opacity: 0.4,
                    dashArray: <double>[5, 5],
                    borderColor: Colors.grey,
                    borderWidth: 2,
                  ),
                  PlotBand(isVisible: true, start: globals.heartRateMin, end: globals.heartRateMax, color: Colours.lightBlue, opacity: 0.4),
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
            series: <ChartSeries>[
              // Renders spline chart
              SplineSeries<_SalesData, String>(
                dataSource: widget.workout ? workoutData : data,
                xValueMapper: (_SalesData sales, _) => sales.year,
                yValueMapper: (_SalesData sales, _) => sales.sales,
                color: Colours.highlight,
                width: 3,
              )
            ]));
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final int sales;
}

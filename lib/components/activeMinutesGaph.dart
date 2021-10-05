import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wearable_intelligence/utils/globals.dart';
import 'package:wearable_intelligence/utils/styles.dart';

class ActiveMinutesGraph extends StatefulWidget {
  const ActiveMinutesGraph({Key? key}) : super(key: key);

  @override
  _ActiveMinutesGraphState createState() => _ActiveMinutesGraphState();
}

class _ActiveMinutesGraphState extends State<ActiveMinutesGraph> {
  List<ActiveData> data = [
    /// use active zone heart rate when available
    ActiveData('MON',  weekActivityMinutes[0]),
    ActiveData('TUE',  weekActivityMinutes[1]),
    ActiveData('WED',  weekActivityMinutes[2]),
    ActiveData('THU',  weekActivityMinutes[3]),
    ActiveData('FRI',  weekActivityMinutes[4]),
    ActiveData('SAT',  weekActivityMinutes[5]),
    ActiveData('SUN',  weekActivityMinutes[6]),
  ];

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
                text: 'Active minutes this week',
                alignment: ChartAlignment.near,
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colours.black)),
            primaryYAxis: NumericAxis(
              maximum: 45,
              labelFormat: '{value} min',
              plotBands: <PlotBand>[
                PlotBand(
                  isVisible: true,
                  start: weekPlan[0].getReps*2,
                  end: weekPlan[0].getReps*2,
                  dashArray: <double>[5, 10],
                  borderColor: Colors.grey,
                  borderWidth: 2,
                  opacity: 0.4,
                ),
              ],
              axisLine: AxisLine(width: 0),
              majorGridLines: MajorGridLines(width: 0),
              majorTickLines: MajorTickLines(width: 0),
              interval: 10,
            ),
            primaryXAxis: CategoryAxis(
              axisLine: AxisLine(width: 0),
              majorGridLines: MajorGridLines(width: 0),
              majorTickLines: MajorTickLines(width: 0),
              labelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            ),
            plotAreaBorderWidth: 0,
            series: <ChartSeries>[
              ColumnSeries<ActiveData, String>(
                  dataSource: data,
                  xValueMapper: (ActiveData data, _) => data.day,
                  yValueMapper: (ActiveData data, _) => data.minutes,
                  pointColorMapper: (ActiveData data, _) => (data.minutes > weekPlan[0].getReps*2) ? Colours.lightBlue : Colours.highlight,
                  // Sets the corner radius
                  width: 0.2,
                  borderRadius: BorderRadius.all(Radius.circular(30)))
            ]));
  }
}

class ActiveData {
  ActiveData(this.day, this.minutes);

  final String day;
  final int minutes;
}

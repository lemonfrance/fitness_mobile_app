import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wearable_intelligence/styles.dart';
import 'package:wearable_intelligence/utils/globals.dart' as globals;

class ActiveMinutesGraph extends StatefulWidget {
  const ActiveMinutesGraph({Key? key}) : super(key: key);

  @override
  _ActiveMinutesGraphState createState() => _ActiveMinutesGraphState();
}

class _ActiveMinutesGraphState extends State<ActiveMinutesGraph> {
  List<_SalesData> data = [
    /// use active zone heart rate when available
    _SalesData('MON', 20),
    _SalesData('TUE', 50),
    _SalesData('WED', 45),
    _SalesData('THU', 30),
    _SalesData('FRI', 35),
    _SalesData('SAT', 25),
    _SalesData('SUN', 40),
  ];

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width - 50);

    return Container(
        width: width,
        height: width/1.5,
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
                    textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colours.black)),
                primaryYAxis: NumericAxis(
                  maximum: 55,
                  labelFormat: '{value} min',
                  plotBands: <PlotBand>[
                    PlotBand(
                      isVisible: true,
                      start: 35,
                      end: 35,
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
                  labelStyle:
                      TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                ),
                plotAreaBorderWidth: 0,
                series: <ChartSeries>[
                  ColumnSeries<_SalesData, String>(
                      dataSource: data,
                      xValueMapper: (_SalesData sales, _) => sales.year,
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      pointColorMapper: (_SalesData sales, _) =>
                          (sales.sales > 35)
                              ? Colours.lightBlue
                              : Colours.highlight,
                      // Sets the corner radius
                      width: 0.2,
                      borderRadius: BorderRadius.all(Radius.circular(30)))
                ]));
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final int sales;
}

import 'dart:math';

import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_chart/sfcharts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'dart:ui';

ZoomPanBehavior zoomPan;
List<num> xValues;
List<num> yValues;

class ChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    zoomPan = ZoomPanBehavior(
        enablePinching: true, zoomMode: ZoomMode.x, enablePanning: true);

    return Container(
        height:400,
        child: SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: DateTimeAxis(
            intervalType: DateTimeIntervalType.minutes,
            dateFormat: DateFormat.Hm(),
            zoomFactor: 0.1,
            zoomPosition: 1.0,
//          interval: 5,
//        dateFormat: DateFormat.s(),
            majorGridLines: MajorGridLines(width: 0),
          ),
          primaryYAxis: NumericAxis(
              minimum: 8000,
              opposedPosition: true,
//        maximum: 13000,
//        interval: 100,
              axisLine: AxisLine(width: 0),
              majorTickLines: MajorTickLines(size: 0)),
          series: getLineSeries(),
          tooltipBehavior: TooltipBehavior(enable: true),
          zoomPanBehavior: zoomPan,
          trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              lineType: TrackballLineType.vertical,
              tooltipSettings:
              InteractiveTooltip(format: '{point.x} : {point.y}')),
        ));
  }
}

num getRandomInt(num min, num max) {
  final Random random = Random();
  return min + random.nextInt(max - min);
}

//List<CustomLineSeries<_ChartData, DateTime>> getLineSeries() {
//  final dynamic chartData = <_ChartData>[
//    _ChartData(DateTime(2018, 7), 2.9),
//    _ChartData(DateTime(2018, 8), 2.7),
//    _ChartData(DateTime(2018, 9), 2.3),
//    _ChartData(DateTime(2018, 10), 2.5),
//    _ChartData(DateTime(2018, 11), 2.2),
//    _ChartData(DateTime(2018, 12), 1.9),
//    _ChartData(DateTime(2019, 1), 1.6),
//    _ChartData(DateTime(2019, 2), 1.5),
//    _ChartData(DateTime(2019, 3), 1.9),
//    _ChartData(DateTime(2019, 4), 2),
//  ];
//  return <CustomLineSeries<_ChartData, DateTime>>[
//    CustomLineSeries<_ChartData, DateTime>(
//        animationDuration: 2500,
//        enableToolTip: true,
//        dataSource: chartData,
//        xValueMapper: (_ChartData sales, _) => sales.x,
//        yValueMapper: (_ChartData sales, _) => sales.y,
//        width: 2,
//        markerSettings: MarkerSettings(isVisible: true)),
//  ];
//}

List<LineSeries<_ChartData, DateTime>> getLineSeries() {

  DateTime today = new DateTime.now();
  List<_ChartData> chartDataLine = new List(310);
  today = today.add(new Duration(seconds: 60*10));
  for (int i = 0; i < 310; i++) {
    int val = getRandomInt(9000, 12000);
    // add some empty points
    double value = i>10?val.toDouble():null;
    chartDataLine[i] = _ChartData(
        today.subtract(new Duration(seconds: 60 * i)), value);
  }

  const Color t_green = Color.fromRGBO(0, 189, 174, 0);
  const Color t_red = Color.fromRGBO(229, 101, 144, 0);

  List<_ChartData> chartData = new List(30);

  const List<double> strikes = [8, 9, 10, 12, 13];
  const List<String> namesList = ["tradefun","tokehunt","shiranui-mai","cybest-test","hyper-jagger"];
  for (int i = 0; i < 30; i++) {
    int val = getRandomInt(0, strikes.length);
    _OrderInfo order = new _OrderInfo(strikes[val]*1000,strikes[val]<11, namesList[val]);
    chartData[i] =
        _ChartData(chartDataLine[i * 10].x, chartDataLine[i * 10].y, order);
  }

  return <LineSeries<_ChartData, DateTime>>[
    LineSeries<_ChartData, DateTime>(
        enableTooltip: false,
        animationDuration: 0,
        dataSource: chartDataLine,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y,
        color: Colors.blueAccent,
        width: 1),
    LineSeries<_ChartData, DateTime>(
        enableTooltip: true,
        animationDuration: 2500,
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y,
        pointColorMapper: (_ChartData sales, _) =>
            sales.order.isLong ? t_red : t_green,
        markerSettings: MarkerSettings(isVisible: true),
        width: 1)
  ];
}

class _ChartData {
  _ChartData(this.x, this.y, [this.order]);

  final DateTime x;
  final double y;
  final _OrderInfo order;
}

class _OrderInfo {
  _OrderInfo(this.strike, this.isLong, this.username);

  final double strike;
  final bool isLong;
  final String username;
}
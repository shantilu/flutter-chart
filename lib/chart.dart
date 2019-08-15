import 'dart:math';

import 'package:intl/intl.dart';
import 'package:flutter_chart/sfcharts/charts.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

ZoomPanBehavior zoomPan;
double profit = 12300;
double lost = 8600;

class ChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    zoomPan = ZoomPanBehavior(
        enablePinching: true, zoomMode: ZoomMode.x, enablePanning: true);

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Chart"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
          child: Container(
              height:400,
              child: SfCartesianChart(
                legend: Legend(
                    isVisible: true,
                    position: LegendPosition.bottom,
                    overflowMode: LegendItemOverflowMode.wrap),
                plotAreaBorderWidth: 0,
                primaryXAxis: DateTimeAxis(
                  intervalType: DateTimeIntervalType.minutes,
                  dateFormat: DateFormat.Hm(),
                  zoomFactor: 0.2,
                  zoomPosition: 1.0,
                  majorGridLines: MajorGridLines(width: 0),
                ),
                primaryYAxis: NumericAxis(
                    minimum: 8000,
                    opposedPosition: true,
                    axisLine: AxisLine(width: 0),
                    majorTickLines: MajorTickLines(size: 0)),
                series: getLineSeries(),
                tooltipBehavior: TooltipBehavior(enable: true),
                zoomPanBehavior: zoomPan,
//          trackballBehavior: TrackballBehavior(
//              enable: true,
//              activationMode: ActivationMode.singleTap,
//              lineType: TrackballLineType.vertical,
//              tooltipSettings:
//              InteractiveTooltip(format: '{point.x} : {point.y}')
//          ),
              ))
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          profit = profit + 1000;
          lost = lost - 1000;
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
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

  const List<double> strikes = [8, 9, 10, 12, 13];
  const List<String> namesList = ["tradefun","tokehunt","shiranui-mai","cybest-test","hyper-jagger"];

  const Color t_green = Color.fromRGBO(0, 189, 174, 0);
  const Color t_red = Color.fromRGBO(229, 101, 144, 0);

  double current = 0;
  for (int i = 0; i < 310; i++) {
    int val = getRandomInt(9000, 12000);
    // add some empty points
    double value = i>10?val.toDouble():null;
    if(current == 0 && value != null){
      current = value;
    }

    _OrderInfo order;
    if(i%10 == 0){
      int val = getRandomInt(0, strikes.length);
      order = new _OrderInfo(strikes[val]*1000,strikes[val]<11, namesList[val]);
    }
    chartDataLine[i] = _ChartData(
        today.subtract(new Duration(seconds: 60 * i)), value, order);
  }

  List<_ChartData> chartData = new List(30);
  for (int i = 0; i < 30; i++) {
    int val = getRandomInt(0, strikes.length);
    _OrderInfo order = new _OrderInfo(strikes[val]*1000,strikes[val]<11, namesList[val]);
    chartData[i] =
        _ChartData(chartDataLine[i * 10].x, chartDataLine[i * 10].y, order);
  }

  return <LineSeries<_ChartData, DateTime>>[
    LineSeries<_ChartData, DateTime>(
        name: 'Prices',
        enableTooltip: false,
        animationDuration: 0,
        dataSource: chartDataLine,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y,
        color: Colors.blueAccent,
        width: 1),
    LineSeries<_ChartData, DateTime>(
        name: 'Current',
        enableTooltip: false,
        animationDuration: 0,
        dataSource: chartDataLine,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => current,
        color: Colors.blue,
        width: 1),
    LineSeries<_ChartData, DateTime>(
        name: 'Profit',
        enableTooltip: false,
        animationDuration: 0,
        dashArray: [3, 3, 3, 3],
        dataSource: chartDataLine,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => profit,
        color: Colors.redAccent,
        width: 2),
    LineSeries<_ChartData, DateTime>(
        name: 'Loss',
        enableTooltip: false,
        animationDuration: 0,
        dashArray: [3, 3, 3, 3],
        dataSource: chartDataLine,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => lost,
        color: Colors.lightGreen,
        width: 2),
    LineSeries<_ChartData, DateTime>(
        name: 'Orders',
        enableTooltip: true,
        animationDuration: 500,
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
// ignore_for_file: file_names, prefer_const_constructors

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shop_manager/components/responsive.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

class ItemGraph extends StatefulWidget {
  const ItemGraph({
    Key? key,
  }) : super(key: key);

  @override
  _ItemGraphState createState() => _ItemGraphState();
}

class _ItemGraphState extends State<ItemGraph> {
  List<Color> gradientColors = [
    Color.fromARGB(255, 4, 0, 224),
    Color.fromARGB(255, 0, 102, 255),
    Color.fromARGB(255, 255, 153, 0),
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Total Earnings', style: bodyText1.copyWith(color: Colors.grey)),
        SizedBox(height: height * 0.01),
        Text('GHS 20945.90', style: headline1),
        SizedBox(height: height * 0.02),
        Stack(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 2.3,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                  //color: Color(0xff232d37)
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 0,
                    left: 0,
                    //top: height * 0.02,
                    //bottom: height * 0.01
                  ),
                  child: LineChart(
                    mainData(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      color: Responsive.isMobile()
          ? Color.fromARGB(255, 255, 255, 255)
          : Color.fromARGB(255, 92, 92, 92),
      fontWeight: FontWeight.bold,
      fontSize: Responsive.isTablet() ? 14 : 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('Sun', style: style);
        break;
      case 2:
        text = Text('Mon', style: style);
        break;
      case 3:
        text = Text('Tue', style: style);
        break;
      case 4:
        text = Text('Wed', style: style);
        break;
      case 5:
        text = Text('Thur', style: style);
        break;
      case 6:
        text = Text('Fri', style: style);
        break;
      case 7:
        text = Text('Sat', style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.0,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      color: Responsive.isMobile()
          ? Color.fromARGB(255, 255, 255, 255)
          : Color.fromARGB(255, 92, 92, 92),
      fontWeight: FontWeight.bold,
      fontSize: Responsive.isTablet() ? 14 : 12,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      case 7:
        text = '100k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
              color: Color.fromARGB(255, 46, 46, 46),
              strokeWidth: 0.5,
              dashArray: [2, 5]);
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
              color: Color.fromARGB(255, 46, 46, 46),
              strokeWidth: 1,
              dashArray: [2, 5]);
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
          show: false,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 8,
      minY: 0,
      maxY: 7,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 1),
            FlSpot(1, 3),
            FlSpot(2, 2.5),
            FlSpot(3, 4),
            FlSpot(4, 3),
            FlSpot(5, 3.5),
            FlSpot(6, 2),
            FlSpot(7, 4),
            FlSpot(8, 4.5),
          ],
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }
}

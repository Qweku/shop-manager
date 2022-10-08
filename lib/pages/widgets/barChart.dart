import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shop_manager/pages/widgets/constants.dart';

class SimpleBarChart extends StatelessWidget {
  const SimpleBarChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: const EdgeInsets.all(0),
          //tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.transparent,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, TitleMeta meta) {
              const style = TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              );
              Widget text;
              switch (value.toInt()) {
                case 0:
                  text = const Text('Mon', style: style);
                  break;
                case 1:
                  text = const Text('Tue', style: style);
                  break;
                case 2:
                  text = const Text('Wed', style: style);
                  break;
                case 3:
                  text = const Text('Thu', style: style);
                  break;
                case 4:
                  text = const Text('Fri', style: style);
                  break;
                case 5:
                  text = const Text('Sat', style: style);
                  break;
                // case 6:
                //   text = const Text('', style: style);
                //   break;
                default:
                  text = const Text('', style: style);
                  break;
              }
              return Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                  ),
                  child: text);
            },
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, TitleMeta meta) {
              const style = TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              );
              Widget text;
              switch (value.toInt()) {
                case 0:
                  text = const Text('230', style: style);
                  break;
                case 1:
                  text = const Text('520', style: style);
                  break;
                case 2:
                  text = const Text('780', style: style);
                  break;
                case 3:
                  text = const Text('800', style: style);
                  break;
                case 4:
                  text = const Text('750', style: style);
                  break;
                case 5:
                  text = const Text('520', style: style);
                  break;
                // case 6:
                //   text = const Text('', style: style);
                //   break;
                default:
                  text = const Text('', style: style);
                  break;
              }
              return Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                  ),
                  child: text);
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  List<BarChartGroupData> get barGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              borderRadius: BorderRadius.circular(5),
              width: 15,
              toY: 11,
              color: Color.fromARGB(255, 255, 255, 255),
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              borderRadius: BorderRadius.circular(5),
              width: 15,
              toY: 10,
              color: Color.fromARGB(255, 255, 255, 255),
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              borderRadius: BorderRadius.circular(5),
              width: 15,
              toY: 14,
              color: Color.fromARGB(255, 255, 255, 255),
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              borderRadius: BorderRadius.circular(5),
              width: 15,
              toY: 15,
              color: Color.fromARGB(255, 255, 255, 255),
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
              borderRadius: BorderRadius.circular(5),
              width: 15,
              toY: 13,
              color: Color.fromARGB(255, 255, 255, 255),
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
              borderRadius: BorderRadius.circular(5),
              width: 15,
              toY: 10,
              color: Color.fromARGB(255, 255, 255, 255),
            )
          ],
          showingTooltipIndicators: [0],
        ),
        //  BarChartGroupData(
        //     x: 6,
        //     barRods: [
        //       BarChartRodData(
        //          width:17,
        //           toY: 8, color: Colors.white)
        //     ],
        //     showingTooltipIndicators: [0],
        //   ),
      ];
}

class ShopBarChart extends StatefulWidget {
  const ShopBarChart({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ShopBarChartState();
}

class ShopBarChartState extends State<ShopBarChart> {
  @override
  Widget build(BuildContext context) {
    var theme=Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      height:  height * 0.25 ,
      width:  width ,
      decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                offset: Offset(0, 1),
                color: Color.fromARGB(255, 47, 48, 121),
                blurRadius: 2,
                spreadRadius: 1),
           
          ]),
      child: const SimpleBarChart(),
    );
  }
}

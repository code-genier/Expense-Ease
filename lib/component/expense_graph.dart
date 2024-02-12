import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample2 extends StatefulWidget {
  final List<String> monthList;
  final List<double> monthExpense;
  const LineChartSample2({
    super.key,
    required this.monthExpense,
    required this.monthList,
  });

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
   Colors.white10, Colors.white10,
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              mainData(),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 12,
      fontStyle: FontStyle.italic,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text(widget.monthList[4], style: style);
        break;
      case 2:
        text = Text(widget.monthList[3], style: style);
        break;
      case 3:
        text = Text(widget.monthList[2], style: style);
        break;
      case 4:
        text = Text(widget.monthList[1], style: style);
        break;
      case 5:
        text = Text(widget.monthList[0], style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 10,
      color: Colors.white30,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '20K';
        break;
      case 2:
        text = '40k';
        break;
      case 3:
        text = '60k';
        break;
      case 4:
        text = '80k';
        break;
      case 5:
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
          return const FlLine(
            color: Colors.white30,
            strokeWidth: 0.25,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.white30,
            strokeWidth: 0.25,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
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
        border: Border.all(color: Colors.white38),
      ),
      minX: 0,
      maxX: 5,
      minY: 0,
      maxY: 5,
      lineBarsData: [
        LineChartBarData(
          spots: [
            (widget.monthExpense.length > 5)?FlSpot(0, min(4, widget.monthExpense[5]/20000)):const FlSpot(0, 0/20000),
            (widget.monthExpense.length > 4)?FlSpot(1, min(4, widget.monthExpense[4]/20000)):const FlSpot(1, 0/20000),
            (widget.monthExpense.length > 3)?FlSpot(2, min(4, widget.monthExpense[3]/20000)):const FlSpot(2, 0/20000),
            (widget.monthExpense.length > 2)?FlSpot(3, min(5, widget.monthExpense[2]/20000)):const FlSpot(3, 0/20000),
            (widget.monthExpense.length > 1)?FlSpot(4, min(5, widget.monthExpense[1]/20000)):const FlSpot(4, 0/20000),
            (widget.monthExpense.length >= 0)?FlSpot(5, min(5, widget.monthExpense[0]/20000)):const FlSpot(5, 0/20000),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.2))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
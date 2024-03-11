import 'dart:async';
import 'dart:math';

import 'package:envo_admin_dashboard/models/bar_chart.dart';
import 'package:envo_admin_dashboard/utils/meta_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BarChartSample1 extends StatefulWidget {
  BarChartSample1({super.key, required this.data});
  final List<BarChartApiData> data;
  final Color barBackgroundColor = Colors.white60;
  final Color barColor = Colors.white;
  final Color touchedBarColor = Colors.white;

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample1> {
  final Duration animDuration = Duration(milliseconds: 250);

  int touchedIndex = -1;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Posts',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            'By Action',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 38,
          ),
          Expanded(
            child: Row(
              children: [
                RotatedBox(
                    quarterTurns: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Posts",
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: BarChart(
                      mainBarData(),
                      swapAnimationDuration: animDuration,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    barColor ??= widget.barColor;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? widget.touchedBarColor : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Colors.white)
              : BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: widget.barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() =>
      List.generate(widget.data.length, (i) {
        print("$i  ${widget.data[i].postCount!.toDouble()}");
        return makeGroupData(
            i,
            widget.data[i].postCount!.toDouble() == 0
                ? 0.1
                : widget.data[i].postCount!.toDouble(),
            isTouched: i == touchedIndex);
      });

  BarChartData mainBarData() {
    return BarChartData(
      groupsSpace: 10,
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.white,
          tooltipRoundedRadius: 12,
          tooltipHorizontalAlignment: FLHorizontalAlignment.center,
          tooltipMargin: 0,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay = DateFormat('dd MMM , yyyy')
                .format(widget.data[group.x.toInt()].date!);

            return BarTooltipItem(
              '$weekDay\n',
              TextStyle(
                color: MetaColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY - 1).toStringAsFixed(2),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
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
            getTitlesWidget: getTitles,
            reservedSize: 40,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      alignment: BarChartAlignment.spaceEvenly,
      gridData: FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 11,
    );
    Widget text;
    text = Text(
      "${DateFormat('dd MMM , yyyy').format(widget.data[value.toInt()].date!)}",
      softWrap: true,
      style: style,
    );
    return SideTitleWidget(
      fitInside: SideTitleFitInsideData(
          enabled: true,
          axisPosition: meta.axisPosition,
          parentAxisSize: meta.parentAxisSize,
          distanceFromEdge: meta.appliedInterval),
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }
}

import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'models/pie_chart.dart';
import 'dart:math' as math;

class PieChartSample1 extends StatefulWidget {
  const PieChartSample1({super.key, required this.data});
  final List<PieChartApiData> data;

  @override
  State<StatefulWidget> createState() => PieChartSample1State();
}

class PieChartSample1State extends State<PieChartSample1> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        centerSpaceRadius: 10,
        pieTouchData: PieTouchData(
          enabled: true,
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                log(" pie touch Data ${pieTouchResponse?.touchedSection?.touchedSectionIndex}");
                touchedIndex = -1;
                return;
              }
              touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        startDegreeOffset: 180,
        borderData: FlBorderData(
          show: false,
        ),
        sectionsSpace: 1,
        sections: showingSections(),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    double total = 0;
    widget.data.forEach((element) {
      total += element.count!;
    });

    return List.generate(widget.data.length, (i) {
      final isTouched = i == touchedIndex;
      log("  $i ${widget.data[i].count!}");
      return PieChartSectionData(
        color: widget.data[i].color,
        titleStyle:
            TextStyle(color: Colors.white, fontSize: isTouched ? 10 : 13),
        value: widget.data[i].count!.toDouble() == 0
            ? 0.1
            : widget.data[i].count!.toDouble(),
        title: !isTouched
            ? '${widget.data[i].count! == 0 ? "" : ((widget.data[i].count! / total) * 100).toStringAsFixed(2)+"%"}'
            : "${widget.data[i].action!}  ${widget.data[i].count!}",
        radius: isTouched ? 200 : 170,

      );

      // switch (i) {
      //   case 0:
      //     return PieChartSectionData(
      //       color: color0,
      //       value: 25,
      //       title: '',
      //       radius: 80,
      //       titlePositionPercentageOffset: 0.55,
      //       borderSide: isTouched
      //           ? const BorderSide(
      //               color: AppColors.contentColorWhite, width: 6)
      //           : BorderSide(
      //               color: AppColors.contentColorWhite.withOpacity(0)),
      //     );
      //   case 1:
      //     return PieChartSectionData(
      //       color: color1,
      //       value: 25,
      //       title: '',
      //       radius: 65,
      //       titlePositionPercentageOffset: 0.55,
      //       borderSide: isTouched
      //           ? const BorderSide(
      //               color: AppColors.contentColorWhite, width: 6)
      //           : BorderSide(
      //               color: AppColors.contentColorWhite.withOpacity(0)),
      //     );
      //   case 2:
      //     return PieChartSectionData(
      //       color: color2,
      //       value: 25,
      //       title: '',
      //       radius: 60,
      //       titlePositionPercentageOffset: 0.6,
      //       borderSide: isTouched
      //           ? const BorderSide(
      //               color: AppColors.contentColorWhite, width: 6)
      //           : BorderSide(
      //               color: AppColors.contentColorWhite.withOpacity(0)),
      //     );
      //   case 3:
      //     return PieChartSectionData(
      //       color: color3,
      //       value: 25,
      //       title: '',
      //       radius: 70,
      //       titlePositionPercentageOffset: 0.55,
      //       borderSide: isTouched
      //           ? const BorderSide(
      //               color: AppColors.contentColorWhite, width: 6)
      //           : BorderSide(
      //               color: AppColors.contentColorWhite.withOpacity(0)),
      //     );
      //   default:
      //     throw Error();
    });
  }
}

class AppColors {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}

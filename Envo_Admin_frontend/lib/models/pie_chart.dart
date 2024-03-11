// To parse this JSON data, do
//
//     final pieChartApiData = pieChartApiDataFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:math' as math;

List<PieChartApiData> pieChartApiDataFromJson(String str) =>
    List<PieChartApiData>.from(
        json.decode(str).map((x) => PieChartApiData.fromJson(x)));

String pieChartApiDataToJson(List<PieChartApiData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PieChartApiData {
  String? action;
  int? count;
  Color? color;

  PieChartApiData({this.action, this.count, this.color});

  factory PieChartApiData.fromJson(Map<String, dynamic> json) =>
      PieChartApiData(
          action: json["action"],
          count: json["count"],
          color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
              .withOpacity(1.0));

  Map<String, dynamic> toJson() => {
        "action": action,
        "count": count,
      };
}

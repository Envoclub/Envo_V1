// To parse this JSON data, do
//
//     final LineChartApiData = LineChartApiDataFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:math' as math;

List<LineChartApiData> lineChartApiDataFromJson(String str) =>
    List<LineChartApiData>.from(
        json.decode(str).map((x) => LineChartApiData.fromJson(x)));

String lineChartApiDataToJson(List<LineChartApiData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LineChartApiData {
  String? label;
  int? value;
  Color? color;

  LineChartApiData({this.label, this.value, this.color});

  factory LineChartApiData.fromJson(Map<String, dynamic> json) =>
      LineChartApiData(
          label: json["label"],
          value: json["value"],
          color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
              .withOpacity(1.0));

  Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
      };
}

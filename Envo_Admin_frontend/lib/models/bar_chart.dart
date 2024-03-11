// To parse this JSON data, do
//
//     final barChartApiData = barChartApiDataFromJson(jsonString);

import 'dart:convert';

List<BarChartApiData> barChartApiDataFromJson(String str) => List<BarChartApiData>.from(json.decode(str).map((x) => BarChartApiData.fromJson(x)));

String barChartApiDataToJson(List<BarChartApiData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BarChartApiData {
    DateTime? date;
    int? postCount;

    BarChartApiData({
        this.date,
        this.postCount,
    });

    factory BarChartApiData.fromJson(Map<String, dynamic> json) => BarChartApiData(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        postCount: json["post_count"],
    );

    Map<String, dynamic> toJson() => {
        "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "post_count": postCount,
    };
}

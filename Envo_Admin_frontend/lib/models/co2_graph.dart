// To parse this JSON data, do
//
//     final co2GraphData = co2GraphDataFromJson(jsonString);

import 'dart:convert';

Co2GraphData co2GraphDataFromJson(String str) => Co2GraphData.fromJson(json.decode(str));

String co2GraphDataToJson(Co2GraphData data) => json.encode(data.toJson());

class Co2GraphData {
    List<Co2SavedLast7Day>? co2SavedLast7Days;

    Co2GraphData({
        this.co2SavedLast7Days,
    });

    factory Co2GraphData.fromJson(Map<String, dynamic> json) => Co2GraphData(
        co2SavedLast7Days: json["co2_saved_last_7_days"] == null ? [] : List<Co2SavedLast7Day>.from(json["co2_saved_last_7_days"]!.map((x) => Co2SavedLast7Day.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "co2_saved_last_7_days": co2SavedLast7Days == null ? [] : List<dynamic>.from(co2SavedLast7Days!.map((x) => x.toJson())),
    };
}

class Co2SavedLast7Day {
    String? day;
    int? co2Saved;

    Co2SavedLast7Day({
        this.day,
        this.co2Saved,
    });

    factory Co2SavedLast7Day.fromJson(Map<String, dynamic> json) => Co2SavedLast7Day(
        day: json["day"],
        co2Saved: json["co2_saved"],
    );

    Map<String, dynamic> toJson() => {
        "day": day,
        "co2_saved": co2Saved,
    };
}

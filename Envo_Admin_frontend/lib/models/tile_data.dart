// To parse this JSON data, do
//
//     final tileData = tileDataFromJson(jsonString);

import 'dart:convert';

TileData tileDataFromJson(String str) => TileData.fromJson(json.decode(str));

String tileDataToJson(TileData data) => json.encode(data.toJson());

class TileData {
  double? carbonEmmisionSaved;
  int? totalParticipation;
  int? totalPostToday;
  double? percentageTotalPost;
  double? percentageCo2Change;
  double? percentageEmployeeParticipation;

  TileData(
      {this.carbonEmmisionSaved,
      this.totalParticipation,
      this.totalPostToday,
      this.percentageCo2Change,
      this.percentageEmployeeParticipation,
      this.percentageTotalPost});

  factory TileData.fromJson(Map<String, dynamic> json) => TileData(
      carbonEmmisionSaved: json["carbon_emmision_saved"],
      totalParticipation: json["Total_participation"],
      percentageTotalPost: json['percentage_total_post'],
      percentageCo2Change: json['percentage_co2_change'],
      percentageEmployeeParticipation:
          json['percentage_employee_participation'],
      totalPostToday: json["Total_Post_Today"]);

  Map<String, dynamic> toJson() => {
        "carbon_emmision_saved": carbonEmmisionSaved,
        "Total_participation": totalParticipation,
        "Total_Post_Today": totalPostToday,
        "percentage_total_post": percentageTotalPost,
        "percentage_co2_change": percentageCo2Change,
        "percentage_employee_participation": percentageEmployeeParticipation,
      };
}

// To parse this JSON data, do
//
//     final rewardsModel = rewardsModelFromJson(jsonString);

import 'dart:convert';

List<RewardsModel> rewardsModelFromJson(String str) => List<RewardsModel>.from(json.decode(str).map((x) => RewardsModel.fromJson(x)));

String rewardsModelToJson(List<RewardsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RewardsModel {
    int? id;
    String? company;
    String? banner;
    String? title;
    String? description;
    int? coinrequired;
    int? redeemedCount;

    RewardsModel({
        this.id,
        this.company,
        this.banner,
        this.title,
        this.description,
        this.coinrequired,
        this.redeemedCount,
    });

    factory RewardsModel.fromJson(Map<String, dynamic> json) => RewardsModel(
        id: json["id"],
        company: json["company"].toString(),
        banner: json["banner"],
        title: json["title"],
        description: json["description"],
        coinrequired: json["coinrequired"],
        redeemedCount: json["redeemed_count"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "company": company,
        "banner": banner,
        "title": title,
        "description": description,
        "coinrequired": coinrequired,
        "redeemed_count": redeemedCount,
    };
}

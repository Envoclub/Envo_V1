// To parse this JSON data, do
//
//     final leaderboardModel = leaderboardModelFromJson(jsonString);

import 'dart:convert';

List<LeaderboardModel> leaderboardModelFromJson(String str) => List<LeaderboardModel>.from(json.decode(str).map((x) => LeaderboardModel.fromJson(x)));

String leaderboardModelToJson(List<LeaderboardModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LeaderboardModel {
    int? id;
    String? username;
    int? reward;
    int? postCount;
    String? photoUrl;

    LeaderboardModel({
        this.id,
        this.username,
        this.reward,
        this.postCount,
        this.photoUrl,
    });

    factory LeaderboardModel.fromJson(Map<String, dynamic> json) => LeaderboardModel(
        id: json["id"],
        username: json["username"],
        reward: json["reward"],
        postCount: json["post_count"],
        photoUrl: json["photoUrl"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "reward": reward,
        "post_count": postCount,
        "photoUrl": photoUrl,
    };
}

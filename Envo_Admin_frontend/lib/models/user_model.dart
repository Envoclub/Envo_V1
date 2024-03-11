// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

List<UserModel> userModelFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  int? id;
  String? username;
  String? bio;
  String? photoUrl;
  int? followersCount;
  int? followCount;
  int? postCount;
  String? email;
  String? phoneNumber;
  double? Co2;
  int? reward;
  bool? surveyCompleted;
String? companyName;
int? company;
  UserModel(
      {this.id,
      this.username,
      this.bio,
      this.photoUrl,
      this.followersCount,
      this.followCount,
      this.postCount,
      this.email,
      this.phoneNumber,
      this.Co2,
      this.surveyCompleted,
      this.company,this.companyName,
      this.reward});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json["id"],
      username: json["username"],
      bio: json["bio"],
      photoUrl: json["photoUrl"],
      followersCount: json["followers_count"],
      followCount: json["follow_count"],
      postCount: json["post_count"],
      email: json["email"],
      phoneNumber: json["phone_number"],
      Co2: json["Co2"],
      surveyCompleted: json["survey_completed"] ?? false,
      company: json["company"],
      companyName: json["company_name"],
      reward: json["reward"] ?? 0);

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "bio": bio,
        "photoUrl": photoUrl,
        "followers_count": followersCount,
        "follow_count": followCount,
        "post_count": postCount,
        "email": email,
        "phone_number": phoneNumber,
        "Co2": Co2,
        "reward": reward,
        "survey_completed": surveyCompleted,
        "company": company,
        "company_name": companyName,
      };
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
    int? pk;
    String? description;
    String? postUrl;
    DateTime? datePosted;
    String? tags;
    String? myUsername;
    dynamic photoUrl;
    int? likeCount;
    List<Like>? likes;
    int? action;
bool? active;
    Post({
        this.pk,
        this.description,
        this.postUrl,
        this.datePosted,
        this.tags,
        this.myUsername,
        this.photoUrl,
        this.likeCount,
        this.likes,
        this.action,
        this.active
    });

    factory Post.fromJson(Map<String, dynamic> json) => Post(
        pk: json["pk"],
        description: json["description"],
        postUrl: json["postUrl"],
        datePosted: json["date_posted"] == null ? null : DateTime.parse(json["date_posted"]),
        tags: json["tags"],
        myUsername: json["my_username"],
        photoUrl: json["photo_url"],
        likeCount: json["like_count"],
        likes: json["likes"] == null ? [] : List<Like>.from(json["likes"]!.map((x) => Like.fromJson(x))),
        action: json["action"],
        active: json["active"]
    );

    Map<String, dynamic> toJson() => {
        "pk": pk,
        "description": description,
        "postUrl": postUrl,
        "date_posted": datePosted?.toIso8601String(),
        "tags": tags,
        "my_username": myUsername,
        "photo_url": photoUrl,
        "like_count": likeCount,
        "likes": likes == null ? [] : List<dynamic>.from(likes!.map((x) => x.toJson())),
        "action": action,
        "active": active
    };

  Post copyWith({
    int? pk,
    String? description,
    String? postUrl,
    DateTime? datePosted,
    String? tags,
    String? myUsername,
    dynamic? photoUrl,
    int? likeCount,
    List<Like>? likes,
    int? action,
    bool? active
  }) {
    return Post(
      pk: pk ?? this.pk,
      description: description ?? this.description,
      postUrl: postUrl ?? this.postUrl,
      datePosted: datePosted ?? this.datePosted,
      tags: tags ?? this.tags,
      myUsername: myUsername ?? this.myUsername,
      photoUrl: photoUrl ?? this.photoUrl,
      likeCount: likeCount ?? this.likeCount,
      likes: likes ?? this.likes,
      action: action ?? this.action,
      active: active ?? this.active
    );
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;
  
    return 
      other.pk == pk &&
      other.description == description &&
      other.postUrl == postUrl &&
      other.datePosted == datePosted &&
      other.tags == tags &&
      other.myUsername == myUsername &&
      other.photoUrl == photoUrl &&
      other.likeCount == likeCount &&
      listEquals(other.likes, likes) &&
      other.action == action &&
      other.active == active;
  }

  @override
  int get hashCode {
    return pk.hashCode ^
      description.hashCode ^
      postUrl.hashCode ^
      datePosted.hashCode ^
      tags.hashCode ^
      myUsername.hashCode ^
      photoUrl.hashCode ^
      likeCount.hashCode ^
      likes.hashCode ^
      action.hashCode ^
      active.hashCode;
  }
}

class Like {
    String? usernames;

    Like({
        this.usernames,
    });

    factory Like.fromJson(Map<String, dynamic> json) => Like(
        usernames: json["usernames"],
    );

    Map<String, dynamic> toJson() => {
        "usernames": usernames,
    };
}




class CreatePostModel {
  File postUrl;
  String description;
  int action;
  CreatePostModel({
    required this.postUrl,
    required this.description,
    required this.action,
  });

  CreatePostModel copyWith({
    File? postUrl,
    String? description,
    int? action,
  }) {
    return CreatePostModel(
      postUrl: postUrl ?? this.postUrl,
      description: description ?? this.description,
      action: action ?? this.action,
    );
  }

 
}

import 'dart:convert';
import 'dart:io';

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
    );
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

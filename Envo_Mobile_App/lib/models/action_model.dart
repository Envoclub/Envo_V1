// To parse this JSON data, do
//
//     final postActions = postActionsFromJson(jsonString);

import 'dart:convert';

PostActions postActionsFromJson(String str) => PostActions.fromJson(json.decode(str));

String postActionsToJson(PostActions data) => json.encode(data.toJson());

class PostActions {
    int? id;
    String? action;
    String? description;
    int? points;
    String? impact;
    Category? category;
    int? categoryId;
    num? savedemmision;
    String? color;
    String? image;

    PostActions({
        this.id,
        this.action,
        this.description,
        this.points,
        this.impact,
        this.category,
        this.categoryId,
        this.savedemmision,
        this.color,
        this.image,
    });

    factory PostActions.fromJson(Map<String, dynamic> json) => PostActions(
        id: json["id"],
        action: json["action"],
        description: json["description"],
        points: json["points"],
        impact: json["impact"],
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
        categoryId: json["categoryID"],
        savedemmision: json["savedemmision"],
        color: json["color"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "action": action,
        "description": description,
        "points": points,
        "impact": impact,
        "category": category?.toJson(),
        "categoryID": categoryId,
        "savedemmision": savedemmision,
        "color": color,
        "image": image,
    };
}

class Category {
    int? id;
    String? name;

    Category({
        this.id,
        this.name,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}

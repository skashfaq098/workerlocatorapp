// To parse this JSON data, do
//
//     final postModel = postModelFromJson(jsonString);

import 'dart:convert';

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  PostModel({
    this.status,
    this.result,
    this.data,
  });

  String status;
  int result;
  Data data;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        status: json["status"],
        result: json["result"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "result": result,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.posts,
  });

  List<Post> posts;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        posts: List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "posts": List<dynamic>.from(posts.map((x) => x.toJson())),
      };
}

class Post {
  Post({
    this.completedBy,
    this.images,
    this.postedAt,
    this.isActive,
    this.id,
    this.title,
    this.location,
    this.contact,
    this.user,
    this.category,
  });

  List<dynamic> completedBy;
  List<String> images;
  DateTime postedAt;
  bool isActive;
  String id;
  String title;
  String location;
  int contact;
  String user;
  String category;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        completedBy: List<dynamic>.from(json["completedBy"].map((x) => x)),
        images: List<String>.from(json["images"].map((x) => x)),
        postedAt: DateTime.parse(json["postedAt"]),
        isActive: json["isActive"],
        id: json["_id"],
        title: json["title"],
        location: json["location"],
        contact: json["contact"],
        user: json["user"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "completedBy": List<dynamic>.from(completedBy.map((x) => x)),
        "images": List<dynamic>.from(images.map((x) => x)),
        "postedAt": postedAt.toIso8601String(),
        "isActive": isActive,
        "_id": id,
        "title": title,
        "location": location,
        "contact": contact,
        "user": user,
        "category": category,
      };
}

// To parse this JSON data, do
//
//     final postDetailModel = postDetailModelFromJson(jsonString);

import 'dart:convert';

PostDetailModel postDetailModelFromJson(String str) =>
    PostDetailModel.fromJson(json.decode(str));

String postDetailModelToJson(PostDetailModel data) =>
    json.encode(data.toJson());

class PostDetailModel {
  PostDetailModel({
    this.status,
    this.data,
  });

  String status;
  Data data;

  factory PostDetailModel.fromJson(Map<String, dynamic> json) =>
      PostDetailModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.post,
  });

  Post post;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        post: Post.fromJson(json["post"]),
      );

  Map<String, dynamic> toJson() => {
        "post": post.toJson(),
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
  List<dynamic> images;
  DateTime postedAt;
  bool isActive;
  String id;
  String title;
  String location;
  int contact;
  User user;
  String category;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        completedBy: List<dynamic>.from(json["completedBy"].map((x) => x)),
        images: List<dynamic>.from(json["images"].map((x) => x)),
        postedAt: DateTime.parse(json["postedAt"]),
        isActive: json["isActive"],
        id: json["_id"],
        title: json["title"],
        location: json["location"],
        contact: json["contact"],
        user: User.fromJson(json["user"]),
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
        "user": user.toJson(),
        "category": category,
      };
}

class User {
  User({
    this.id,
    this.name,
    this.email,
  });

  String id;
  String name;
  String email;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
      };
}

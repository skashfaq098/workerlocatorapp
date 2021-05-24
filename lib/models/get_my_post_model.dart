// To parse this JSON data, do
//
//     final getMyPost = getMyPostFromJson(jsonString);

import 'dart:convert';

GetMyPost getMyPostFromJson(String str) => GetMyPost.fromJson(json.decode(str));

String getMyPostToJson(GetMyPost data) => json.encode(data.toJson());

class GetMyPost {
  GetMyPost({
    this.status,
    this.result,
    this.data,
  });

  String status;
  int result;
  Data data;

  factory GetMyPost.fromJson(Map<String, dynamic> json) => GetMyPost(
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
  User user;
  Category category;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        completedBy: List<dynamic>.from(json["completedBy"].map((x) => x)),
        images: List<String>.from(json["images"].map((x) => x)),
        postedAt: DateTime.parse(json["postedAt"]),
        isActive: json["isActive"],
        id: json["_id"],
        title: json["title"],
        location: json["location"],
        contact: json["contact"] == null ? null : json["contact"],
        user: userValues.map[json["user"]],
        category: categoryValues.map[json["category"]],
      );

  Map<String, dynamic> toJson() => {
        "completedBy": List<dynamic>.from(completedBy.map((x) => x)),
        "images": List<dynamic>.from(images.map((x) => x)),
        "postedAt": postedAt.toIso8601String(),
        "isActive": isActive,
        "_id": id,
        "title": title,
        "location": location,
        "contact": contact == null ? null : contact,
        "user": userValues.reverse[user],
        "category": categoryValues.reverse[category],
      };
}

enum Category { OTHER, PLUMBER, HELPER }

final categoryValues = EnumValues({
  "helper": Category.HELPER,
  "other": Category.OTHER,
  "plumber": Category.PLUMBER
});

enum User { THE_602_A47_F49_BCC7_E5_F43238_FAD }

final userValues = EnumValues(
    {"602a47f49bcc7e5f43238fad": User.THE_602_A47_F49_BCC7_E5_F43238_FAD});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

// To parse this JSON data, do
//
//     final getMyApplications = getMyApplicationsFromJson(jsonString);

import 'dart:convert';

GetMyApplications getMyApplicationsFromJson(String str) =>
    GetMyApplications.fromJson(json.decode(str));

String getMyApplicationsToJson(GetMyApplications data) =>
    json.encode(data.toJson());

class GetMyApplications {
  GetMyApplications({
    this.status,
    this.result,
    this.data,
  });

  String status;
  int result;
  Data data;

  factory GetMyApplications.fromJson(Map<String, dynamic> json) =>
      GetMyApplications(
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
    this.applications,
  });

  List<Application> applications;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        applications: List<Application>.from(
            json["applications"].map((x) => Application.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "applications": List<dynamic>.from(applications.map((x) => x.toJson())),
      };
}

class Application {
  Application({
    this.appliedAt,
    this.status,
    this.id,
    this.user,
    this.post,
    this.v,
  });

  DateTime appliedAt;
  Status status;
  String id;
  User user;
  Post post;
  int v;

  factory Application.fromJson(Map<String, dynamic> json) => Application(
        appliedAt: DateTime.parse(json["appliedAt"]),
        status: statusValues.map[json["status"]],
        id: json["_id"],
        user: userValues.map[json["user"]],
        post: Post.fromJson(json["post"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "appliedAt": appliedAt.toIso8601String(),
        "status": statusValues.reverse[status],
        "_id": id,
        "user": userValues.reverse[user],
        "post": post.toJson(),
        "__v": v,
      };
}

class Post {
  Post({
    this.id,
    this.title,
  });

  String id;
  String title;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["_id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
      };
}

enum Status { APPLIED }

final statusValues = EnumValues({"applied": Status.APPLIED});

enum User { THE_609_FED111_D4_F9_A00153_A120_F }

final userValues = EnumValues(
    {"609fed111d4f9a00153a120f": User.THE_609_FED111_D4_F9_A00153_A120_F});

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

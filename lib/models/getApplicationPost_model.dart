// To parse this JSON data, do
//
//     final getApplcationForPostModel = getApplcationForPostModelFromJson(jsonString);

import 'dart:convert';

GetApplcationForPostModel getApplcationForPostModelFromJson(String str) =>
    GetApplcationForPostModel.fromJson(json.decode(str));

String getApplcationForPostModelToJson(GetApplcationForPostModel data) =>
    json.encode(data.toJson());

class GetApplcationForPostModel {
  GetApplcationForPostModel({
    this.status,
    this.result,
    this.data,
  });

  String status;
  int result;
  Data data;

  factory GetApplcationForPostModel.fromJson(Map<String, dynamic> json) =>
      GetApplcationForPostModel(
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
  String status;
  String id;
  User user;
  String post;
  int v;

  factory Application.fromJson(Map<String, dynamic> json) => Application(
        appliedAt: DateTime.parse(json["appliedAt"]),
        status: json["status"],
        id: json["_id"],
        user: User.fromJson(json["user"]),
        post: json["post"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "appliedAt": appliedAt.toIso8601String(),
        "status": status,
        "_id": id,
        "user": user.toJson(),
        "post": post,
        "__v": v,
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

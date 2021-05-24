// To parse this JSON data, do
//
//     final userInfoModel = userInfoModelFromJson(jsonString);

import 'dart:convert';

UserInfoModel userInfoModelFromJson(String str) =>
    UserInfoModel.fromJson(json.decode(str));

String userInfoModelToJson(UserInfoModel data) => json.encode(data.toJson());

class UserInfoModel {
  UserInfoModel({
    this.user,
  });

  List<User> user;

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
        user: List<User>.from(json["user"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user": List<dynamic>.from(user.map((x) => x.toJson())),
      };
}

class User {
  User({
    this.skills,
    this.role,
    this.isPhoneVerified,
    this.photoUrl,
    this.id,
    this.name,
    this.email,
  });

  List<String> skills;
  String role;
  bool isPhoneVerified;
  String photoUrl;
  String id;
  String name;
  String email;

  factory User.fromJson(Map<String, dynamic> json) => User(
        skills: List<String>.from(json["skills"].map((x) => x)),
        role: json["role"],
        isPhoneVerified: json["isPhoneVerified"],
        photoUrl: json["photoUrl"],
        id: json["_id"],
        name: json["name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "skills": List<dynamic>.from(skills.map((x) => x)),
        "role": role,
        "isPhoneVerified": isPhoneVerified,
        "photoUrl": photoUrl,
        "_id": id,
        "name": name,
        "email": email,
      };
}

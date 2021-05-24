// To parse this JSON data, do
//
//     final getMyDetail = getMyDetailFromJson(jsonString);

import 'dart:convert';

GetMyDetail getMyDetailFromJson(String str) =>
    GetMyDetail.fromJson(json.decode(str));

String getMyDetailToJson(GetMyDetail data) => json.encode(data.toJson());

class GetMyDetail {
  GetMyDetail({
    this.status,
    this.data,
  });

  String status;
  Data data;

  factory GetMyDetail.fromJson(Map<String, dynamic> json) => GetMyDetail(
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
    this.user,
  });

  User user;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
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

  List<dynamic> skills;
  String role;
  bool isPhoneVerified;
  String photoUrl;
  String id;
  String name;
  String email;

  factory User.fromJson(Map<String, dynamic> json) => User(
        skills: List<dynamic>.from(json["skills"].map((x) => x)),
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

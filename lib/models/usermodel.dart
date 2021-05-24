class User {
  String token;
  String email;

  User();

  User.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        email = json['userEmail'];
  Map<String, dynamic> toJson() => {
        'token': token,
        'userEmail': email,
      };
}

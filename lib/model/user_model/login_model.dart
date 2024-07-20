import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    required this.onlineMp3,
  });

  final List<OnlineMp3> onlineMp3;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    onlineMp3: List<OnlineMp3>.from(json["AUDIO_BOOK"].map((x) => OnlineMp3.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "AUDIO_BOOK": List<dynamic>.from(onlineMp3.map((x) => x.toJson())),
  };
}

class OnlineMp3 {
  OnlineMp3({
    required this.userId,
    required this.name,
    required this.userImage,
    required this.email,
    required this.msg,
    required this.authId,
    required this.success,
  });

  final String userId;
  final String name;
  final String userImage;
  final String email;
  final String msg;
  final String authId;
  final String success;

  factory OnlineMp3.fromJson(Map<String, dynamic> json) => OnlineMp3(
    userId: json["user_id"],
    name: json["name"],
    userImage: json["user_image"],
    email: json["email"],
    msg: json["msg"],
    authId: json["auth_id"],
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "name": name,
    "user_image": userImage,
    "email": email,
    "msg": msg,
    "auth_id": authId,
    "success": success,
  };
}

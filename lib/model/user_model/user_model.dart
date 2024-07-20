import 'dart:convert';

GetUserModel getUserModelFromJson(String str) => GetUserModel.fromJson(json.decode(str));

String getUserModelToJson(GetUserModel data) => json.encode(data.toJson());

class GetUserModel {
  GetUserModel({
    required this.onlineMp3,
  });

  final List<OnlineMp3> onlineMp3;

  factory GetUserModel.fromJson(Map<String, dynamic> json) => GetUserModel(
        onlineMp3: List<OnlineMp3>.from(json["AUDIO_BOOK"].map((x) => OnlineMp3.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "AUDIO_BOOK": List<dynamic>.from(onlineMp3.map((x) => x.toJson())),
      };
}

class OnlineMp3 {
  OnlineMp3({
    required this.success,
    required this.userId,
    required this.userImage,
    required this.name,
    required this.email,
    required this.phone,
    required this.pnCountrycode,
  });

  final String success;
  final String userId;
  final String userImage;
  final String name;
  final String email;
  final String phone;
  final String pnCountrycode;

  factory OnlineMp3.fromJson(Map<String, dynamic> json) => OnlineMp3(
        success: json["success"],
        userId: json["user_id"],
        userImage: json["user_image"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        pnCountrycode: json["pn_countrycode"] ?? 'US',
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "user_id": userId,
        "user_image": userImage,
        "name": name,
        "email": email,
        "phone": phone,
        "pn_countrycode": pnCountrycode,
      };
}

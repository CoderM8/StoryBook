import 'dart:convert';

GetUpdatedModel getUpdatedModelFromJson(String str) => GetUpdatedModel.fromJson(json.decode(str));

String getUpdatedModelToJson(GetUpdatedModel data) => json.encode(data.toJson());

class GetUpdatedModel {
  GetUpdatedModel({
    required this.onlineMp3,
  });

  final List<OnlineMp3> onlineMp3;

  factory GetUpdatedModel.fromJson(Map<String, dynamic> json) => GetUpdatedModel(
        onlineMp3: List<OnlineMp3>.from(json["AUDIO_BOOK"].map((x) => OnlineMp3.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "AUDIO_BOOK": List<dynamic>.from(onlineMp3.map((x) => x.toJson())),
      };
}

class OnlineMp3 {
  OnlineMp3({
    required this.msg,
    required this.name,
    required this.email,
    required this.phone,
    required this.pnCountrycode,
    required this.userImage,
    required this.success,
  });

  final String msg;
  final String name;
  final String email;
  final String phone;
  final String pnCountrycode;

  final String userImage;
  final String success;

  factory OnlineMp3.fromJson(Map<String, dynamic> json) => OnlineMp3(
        msg: json["msg"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        pnCountrycode: json["pn_countrycode"],
        userImage: json["user_image"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "name": name,
        "email": email,
        "phone": phone,
        "pn_countrycode": pnCountrycode,
        "user_image": userImage,
        "success": success,
      };
}
